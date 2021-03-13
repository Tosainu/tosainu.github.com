{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Monad
import           Control.Monad.Except   (MonadError (..))
import           Data.Char
import           Data.Foldable          (fold)
import           Data.Time.Format       (TimeLocale (..), defaultTimeLocale, formatTime)
import           Data.Time.LocalTime    (TimeZone (..), utcToLocalTime)
import           Hakyll
import           Hakyll.Web.Sass
import           Skylighting            (pygments, styleToCss)
import           System.FilePath
import           Text.Pandoc.Extensions
import           Text.Pandoc.Options

import           Archives
import           Compiler
import           ContextField
import           FontAwesome

main :: IO ()
main = hakyllWith hakyllConfig $ do
  faIcons <- fold <$> preprocess loadFontAwesomeIcons

  -- "entry/year/month/day/title/index.md"
  let entryPattern      = "entry/*/*/*/*/index.md"
      entryFilesPattern = "entry/*/*/*/*/**"

  let tagPagesPath tag = "entry" </> "tags" </> sanitizeTagName tag </> "index.html"
  tags <- buildTags entryPattern $ fromFilePath . tagPagesPath

  let appendFooter locale zone item = do
        utc <- fmap Just (getItemUTC locale (itemIdentifier item))
                 `catchError` const (return Nothing)
        let y = fmap (formatTime locale "%Y" . utcToLocalTime zone) utc
        appendFooterWith y item
      appendFooterWith y item = do
        footer <- loadBody $ setVersion y "footer.html"
        appendItemBody footer item

  match entryPattern $ do
    route $ setExtension "html"
    compile $
      pandocCompilerWith readerOptions writerOptions
        >>= absolutizeUrls
        >>= saveSnapshot "feed-content"
        >>= renderKaTeX
        >>= saveSnapshot "content"
        >>= loadAndApplyTemplate "templates/entry.html" (postContext tags)
        >>= appendFooter defaultTimeLocale' timeZoneJST
        >>= loadAndApplyTemplate "templates/default.html" (postContext tags)
        >>= modifyExternalLinkAttributes
        >>= cleanIndexHtmls
        >>= renderFontAwesome faIcons

  match entryFilesPattern $ do
    route idRoute
    compile copyFileCompiler

  let listPageRules title footerVer pages = paginateRules pages $ \num pat -> do
        route idRoute
        compile $ do
          posts  <- recentFirst =<< loadAllSnapshots pat "content"
          let listContext' = listField "posts" postContext' (return posts)
                          <> boolField "noindex" (const (num /= 1))
                          <> paginateContext pages num
                          <> maybe missingField (constField "title") title
                          <> listContext
              postContext' = teaserField "teaser" "content" <> postContext tags
          makeEmptyItem'
            >>= loadAndApplyTemplate "templates/entry_list.html" listContext'
            >>= appendFooterWith footerVer
            >>= loadAndApplyTemplate "templates/default.html" listContext'
            >>= modifyExternalLinkAttributes
            >>= cleanIndexHtmls
            >>= renderFontAwesome faIcons

  tagsRules tags $ \tag pat ->
    let grouper = fmap (paginateEvery 5) . sortRecentFirst
        makeId  = makePageIdentifier $ tagPagesPath tag
        title   = "Tag archives: " ++ tag
    in  buildPaginateWith grouper pat makeId >>= listPageRules (Just title) Nothing

  let yearlyPagePath year = "entry" </> year </> "index.html"
  yearlyArchives <- buildYearlyArchives defaultTimeLocale' timeZoneJST entryPattern $
                      fromFilePath . yearlyPagePath
  archivesRules yearlyArchives $ \year pat ->
    let grouper = fmap (paginateEvery 5) . sortRecentFirst
        makeId  = makePageIdentifier $ yearlyPagePath year
        title   = "Yearly archives: " <> year
    in  buildPaginateWith grouper pat makeId >>= listPageRules (Just title) (Just year)

  let monthlyPagePath (year, month) = "entry" </> year </> month </> "index.html"
  monthlyArchives <- buildMonthlyArchives defaultTimeLocale' timeZoneJST entryPattern $
                       fromFilePath . monthlyPagePath
  archivesRules monthlyArchives $ \key@(year, month) pat ->
    let grouper = fmap (paginateEvery 5) . sortRecentFirst
        makeId  = makePageIdentifier $ monthlyPagePath key
        title   = "Monthly archives: " <> year <> "/" <> month
    in  buildPaginateWith grouper pat makeId >>= listPageRules (Just title) (Just year)

  listPageRules Nothing Nothing =<<
    let grouper = fmap (paginateEvery 5) . sortRecentFirst
        makeId  = makePageIdentifier "index.html"
    in  buildPaginateWith grouper entryPattern makeId

  let years = map fst $ archivesMap yearlyArchives
      version' = maybe id version
  forM_ (Nothing:map Just years) $ \year -> version' year $
    create ["footer.html"] $
      compile $ do
        recent <- fmap (take 5) . recentFirst =<< loadAllSnapshots entryPattern "content"
        let ctx = listField "recent-posts" (postContext tags) (return recent)
               <> tagCloudField' "tag-cloud" tags
               <> yearMonthArchiveField "archives" yearlyArchives monthlyArchives year
               <> siteContext
        makeEmptyItem' >>= loadAndApplyTemplate "templates/footer.html" ctx

  create ["feed.xml"] $ do
    route idRoute
    compile $ do
      let ctx = bodyField "description" <> postContext tags
      loadAllSnapshots entryPattern "feed-content"
        >>= fmap (take 20) . recentFirst
        >>= mapM (prependBaseUrl (feedRoot atomFeedConfig))
        >>= renderAtom atomFeedConfig ctx

  match "images/**/*.svg" $ do
    route idRoute
    compile $ optimizeSVGCompiler ["-p", "4"]

  match "images/icon/cocoa.ico" $ do
    route $ constRoute "favicon.ico"
    compile copyFileCompiler

  match ("CNAME" .||. "images/**") $ do
    route idRoute
    compile copyFileCompiler

  scssDependencies <- makePatternDependency "stylesheets/*/**.scss"
  match "stylesheets/*/**.scss" $ compile getResourceBody
  rulesExtraDependencies [scssDependencies] $
    match "stylesheets/*.scss" $ do
      route $ setExtension "css"
      compile $ fmap compressCss <$> sassCompiler

  match "stylesheets/*.css" $ do
    route   idRoute
    compile compressCssCompiler

  create ["stylesheets/highlight.css"] $ do
    route   idRoute
    compile $ makeItem $ compressCss $ styleToCss pygments

  match "node_modules/@fortawesome/fontawesome-svg-core/styles.css" $ do
    route $ constRoute "vendor/fontawesome/style.css"
    compile compressCssCompiler

  match ("node_modules/katex/dist/katex.min.css" .||. "node_modules/katex/dist/fonts/**") $ do
    route $ gsubRoute "node_modules/katex/dist/" (const "vendor/katex/")
    compile copyFileCompiler

  match "node_modules/normalize.css/normalize.css" $ do
    route $ gsubRoute "node_modules/" (const "vendor/")
    compile copyFileCompiler

  match "templates/*" $ compile templateBodyCompiler

--- Contexts
postContext :: Tags -> Context String
postContext tags = localDateField defaultTimeLocale' timeZoneJST "date" "%Y/%m/%d %R"
                <> tagsField'       "tags"          tags
                <> descriptionField "description"   150
                <> imageField       "image"
                <> siteContext
                <> defaultContext

listContext :: Context String
listContext = siteContext <> defaultContext'

siteContext :: Context String
siteContext   = constField "lang"              "ja"
             <> constField "site-title"        "Tosainu Lab"
             <> constField "site-description"  "とさいぬのブログです"
             <> constField "site-url"          "https://blog.myon.info"
             <> constField "site-image"        "/images/icon/cocoa-512.jpg"
             <> constField "copyright"         "© 2011-2020 Tosainu."
             <> constField "google-analytics"  "UA-57978655-1"
             <> constField "disqus"            "tosainu"
             <> authorContext

authorContext :: Context String
authorContext = constField "author-name"       "Tosainu"
             <> constField "author-profile"    "❤ Arch Linux, ごちうさ"
             <> constField "author-portfolio"  "https://myon.info"
             <> constField "author-avatar"     "/images/icon/cocoa.svg"
             <> constField "author-twitter"    "myon___"

defaultContext' :: Context String
defaultContext' =  bodyField "body"
                <> metadataField
                <> urlField "url"
                <> pathField "path"

--- Misc
sanitizeTagName :: String -> String
sanitizeTagName = map (\x -> if x == ' ' then '-' else toLower x) .
                  filter (liftM2 (||) isAlphaNum (`elem` [' ', '-', '_']))

makePageIdentifier :: FilePath -> PageNumber -> Identifier
makePageIdentifier p 1 = fromFilePath p
makePageIdentifier p n = fromFilePath $ takeDirectory' p </> "page" </> show n </> takeFileName p
  where takeDirectory' x = let x' = takeDirectory x in if x' == "." then "" else x'

makeEmptyItem :: Monoid a => Compiler (Item a)
makeEmptyItem = makeItem mempty

makeEmptyItem' :: Compiler (Item String)
makeEmptyItem' = makeEmptyItem

appendItemBody :: Semigroup a => a -> Item a -> Compiler (Item a)
appendItemBody x = withItemBody (return . (<> x))

--- Configurations
hakyllConfig :: Configuration
hakyllConfig = defaultConfiguration
  { destinationDirectory = "build"
  , storeDirectory       = ".cache"
  , tmpDirectory         = ".cache/tmp"
  , previewHost          = "0.0.0.0"
  , previewPort          = 4567
  }

atomFeedConfig :: FeedConfiguration
atomFeedConfig = FeedConfiguration
  { feedTitle       = "Tosainu Lab"
  , feedDescription = "とさいぬのブログです"
  , feedAuthorName  = "Tosainu"
  , feedAuthorEmail = "tosainu.maple@gmail.com"
  , feedRoot        = "https://blog.myon.info"
  }

readerOptions :: ReaderOptions
readerOptions = defaultHakyllReaderOptions
  { readerExtensions = enableExtension  Ext_east_asian_line_breaks $
                       enableExtension  Ext_emoji $
                       disableExtension Ext_citations $
                       readerExtensions defaultHakyllReaderOptions
  }

writerOptions :: WriterOptions
writerOptions = defaultHakyllWriterOptions
  { writerHTMLMathMethod = KaTeX ""
  }

timeZoneJST :: TimeZone
timeZoneJST = TimeZone (9 * 60) False "JST"

defaultTimeLocale' :: TimeLocale
defaultTimeLocale' = defaultTimeLocale
  { knownTimeZones = knownTimeZones defaultTimeLocale ++ [timeZoneJST]
  }
