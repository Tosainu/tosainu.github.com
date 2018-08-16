{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Monad
import           Data.Char
import           Data.Foldable          (fold)
import           Data.List              (find)
import           Hakyll
import           Hakyll.Web.Sass
import           Skylighting            (pygments, styleToCss)
import           System.FilePath
import qualified Text.HTML.TagSoup      as TS
import           Text.Pandoc.Extensions
import           Text.Pandoc.Options

import           Archives
import           Compiler
import           FontAwesome
import           LocalTime
import           TagField
import           Template

main :: IO ()
main = hakyllWith hakyllConfig $ do
  faIcons <- fold <$> preprocess loadFontAwesomeIcons

  -- "entry/year/month/day/title/index.md"
  let entryPattern      = "entry/*/*/*/*/index.md"
      entryFilesPattern = "entry/*/*/*/*/**"

  tags <- buildTags entryPattern $ fromCapture "entry/tags/*/index.html" . sanitizeTagName

  yearMonthArchives <- buildYearMonthArchives entryPattern $
    \case Yearly  y   -> fromFilePath ("entry" </> y </> "index.html")
          Monthly y m -> fromFilePath ("entry" </> y </> m </> "index.html")

  match entryPattern $ do
    route $ setExtension "html"
    compile $ do
      content <- pandocCompilerWith readerOptions writerOptions
        >>= renderKaTeX
        >>= saveSnapshot "content"

      let ctx = yearMonthArchiveField "archives" yearMonthArchives
             <> postContext tags

      flc    <- mapM load ["footer_left.html", "footer_center.html"]
      fr     <- applyLucidTemplate footerWidgetRightTemplate ctx =<< makeEmptyItem'
      footer <- applyLucidTemplate footerTemplate ctx
                  =<< makeItem (concatMap itemBody $ flc ++ [fr])

      applyLucidTemplate postTemplate ctx content
        >>= withItemBody (\item -> return $ item <> itemBody footer)
        >>= applyLucidTemplate defaultTemplate ctx
        >>= modifyExternalLinkAttributes
        >>= cleanIndexHtmls
        >>= renderFontAwesome faIcons

  match entryFilesPattern $ do
    route idRoute
    compile copyFileCompiler

  tagsRules tags $ \tag pat -> do
    let grouper  = fmap (paginateEvery 5) . sortRecentFirst
        tag'     = sanitizeTagName tag
        makeId n = fromFilePath $
                     if n == 1 then "entry" </> "tags" </> tag' </> "index.html"
                               else "entry" </> "tags" </> tag' </> "page" </> show n </> "index.html"
    tagPages <- buildPaginateWith grouper pat makeId

    paginateRules tagPages $ \num pat' -> do
      route idRoute
      compile $ do
        footer <- loadBody "footer.html"
        posts  <- recentFirst =<< loadAllSnapshots pat' "content"
        let ctx = listField "posts" postContext' (return posts)
               <> paginateContext tagPages num
               <> defaultContext
            postContext' = teaserField "teaser" "content" <> postContext tags
            siteContext' = constField "title" title <> siteContext
            title = "Tag archives: " ++ tag
        makeItem title
          >>= applyLucidTemplate entryListTemplate ctx
          >>= withItemBody (\item -> return $ item <> footer)
          >>= applyLucidTemplate defaultTemplate siteContext'
          >>= modifyExternalLinkAttributes
          >>= cleanIndexHtmls
          >>= renderFontAwesome faIcons

  archivesRules yearMonthArchives $ \key pat -> do
    let grouper  = fmap (paginateEvery 5) . sortRecentFirst
        key'     = case key of Yearly  y   -> y
                               Monthly y m -> y </> m
        makeId n = fromFilePath $
                     if n == 1 then "entry" </> key' </> "index.html"
                               else "entry" </> key' </> "page" </> show n </> "index.html"
    ymaPages <- buildPaginateWith grouper pat makeId
    paginateRules ymaPages $ \num pat' -> do
      route idRoute
      compile $ do
        posts  <- recentFirst =<< loadAllSnapshots pat' "content"
        let ctx = listField "posts" postContext' (return posts)
                <> paginateContext ymaPages num
                <> defaultContext
            postContext' = teaserField "teaser" "content" <> postContext tags
            siteContext' = constField "title" title
                         <> yearMonthArchiveField' "archives" yearMonthArchives (year key)
                         <> siteContext
            title = case key of Yearly  _   -> "Yearly archives: "  ++ key'
                                Monthly _ _ -> "Monthly archives: " ++ key'

        flc    <- mapM load ["footer_left.html", "footer_center.html"]
        fr     <- applyLucidTemplate footerWidgetRightTemplate siteContext' =<< makeEmptyItem'
        footer <- applyLucidTemplate footerTemplate siteContext
                    =<< makeItem (concatMap itemBody $ flc ++ [fr])

        makeItem title
          >>= applyLucidTemplate entryListTemplate ctx
          >>= withItemBody (\item -> return $ item <> itemBody footer)
          >>= applyLucidTemplate defaultTemplate siteContext'
          >>= modifyExternalLinkAttributes
          >>= cleanIndexHtmls
          >>= renderFontAwesome faIcons

  entries <- buildPaginateWith (fmap (paginateEvery 5) . sortRecentFirst)
                               entryPattern
                               (\n -> if n == 1 then fromFilePath "index.html"
                                                else fromFilePath $ "page" </> show n </> "index.html")
  paginateRules entries $ \num pat -> do
    route idRoute
    compile $ do
      footer <- loadBody "footer.html"
      posts  <- recentFirst =<< loadAllSnapshots pat "content"
      let ctx = listField "posts" postContext' (return posts)
             <> paginateContext entries num
             <> defaultContext
          postContext' = teaserField "teaser" "content" <> postContext tags
          siteContext' = constField "title" "" <> siteContext
      makeEmptyItem'
        >>= applyLucidTemplate entryListTemplate ctx
        >>= withItemBody (\item -> return $ item <> footer)
        >>= applyLucidTemplate defaultTemplate siteContext'
        >>= modifyExternalLinkAttributes
        >>= cleanIndexHtmls
        >>= renderFontAwesome faIcons

  -- precompiled footer and footer widgets
  create ["footer.html"] $
    compile $
      mapM loadBody ["footer_left.html", "footer_center.html", "footer_right.html"]
        >>= makeItem . concat
        >>= applyLucidTemplate footerTemplate siteContext

  create ["footer_left.html"] $
    compile $ do
      recent <- fmap (take 5) . recentFirst =<< loadAllSnapshots entryPattern "content"
      let ctx = listField "recent-posts" (postContext tags) (return recent)
             <> authorContext
      makeEmptyItem' >>= applyLucidTemplate footerWidgetLeftTemplate ctx

  create ["footer_center.html"] $
    compile $ do
      let ctx = allTagsListField "all-tags" tags
      makeEmptyItem' >>= applyLucidTemplate footerWidgetCenterTemplate ctx

  create ["footer_right.html"] $
    compile $ do
      let ctx = yearMonthArchiveField "archives" yearMonthArchives
      makeEmptyItem' >>= applyLucidTemplate footerWidgetRightTemplate ctx

  create ["feed.xml"] $ do
    route idRoute
    compile $ do
      posts <- fmap (take 20) . recentFirst =<< loadAllSnapshots entryPattern "content"
      renderAtom atomFeedConfig (postContext tags) posts

  match "images/**/*.svg" $ do
    route idRoute
    compile $ optimizeSVGCompiler ["-p", "4"]

  match ("CNAME" .||. "favicon.ico" .||. "images/**") $ do
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

  match ("node_modules/katex/dist/**" .&&. complement "**.js") $ do
    route $ gsubRoute "node_modules/katex/dist/" (const "vendor/katex/")
    compile copyFileCompiler

  match "node_modules/normalize.css/**" $ do
    route $ gsubRoute "node_modules/" (const "vendor/")
    compile copyFileCompiler

--- Contexts
postContext :: Tags -> Context String
postContext tags = localDateField   "date"          "%Y/%m/%d %R"
                <> tagsListField    "tags"          tags
                <> descriptionField "description"   150
                <> imageField       "image"
                <> siteContext
  where descriptionField key len = field key $
          return . filter (/= '\n') . escapeHtml . take len . unescapeHtml . stripTags . itemBody
        unescapeHtml = TS.fromTagText . head . TS.parseTags

        imageField key = field key $ \item ->
          case find isImageTag $ TS.parseTags $ itemBody item of
               Just t  -> return $ TS.fromAttrib "src" t
               Nothing -> return ""
        isImageTag (TS.TagOpen "img" _) = True
        isImageTag _                    = False

siteContext :: Context String
siteContext   = constField "lang"              "ja"
             <> constField "site-title"        "Tosainu Lab"
             <> constField "site-description"  "とさいぬのブログです"
             <> constField "site-url"          "https://blog.myon.info"
             <> constField "copyright"         "© 2011-2018 Tosainu."
             <> constField "google-analytics"  "UA-57978655-1"
             <> constField "disqus"            "tosainu"
             <> authorContext
             <> defaultContext

authorContext :: Context String
authorContext = constField "author-name"       "Tosainu"
             <> constField "author-profile"    "❤ Arch Linux, ごちうさ"
             <> constField "author-portfolio"  "https://myon.info"
             <> constField "author-avatar"     "/images/icon/cocoa.svg"
             <> constField "author-twitter"    "myon___"

--- Misc
sanitizeTagName :: String -> String
sanitizeTagName = map (\x -> if x == ' ' then '-' else toLower x) .
                  filter (liftM2 (||) isAlphaNum (`elem` [' ', '-', '_']))

makeEmptyItem :: Monoid a => Compiler (Item a)
makeEmptyItem = makeItem mempty

makeEmptyItem' :: Compiler (Item String)
makeEmptyItem' = makeEmptyItem

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
