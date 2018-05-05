{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Monad
import           Data.Char
import           Data.List               (find)
import           Data.Maybe              (fromMaybe)
import           Data.Monoid             ((<>))
import           Hakyll
import           Hakyll.Web.Sass
import qualified Skylighting.Format.HTML as SL
import qualified Skylighting.Styles      as SL
import           System.FilePath
import           System.Process          (readProcess)
import qualified Text.HTML.TagSoup       as TS
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
  faIcons <- fromMaybe mempty <$> loadFontAwesomeIcons

  match ("CNAME" .||. "favicon.ico" .||. "images/**") $ do
    route idRoute
    compile copyFileCompiler

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
      r <- pandocCompilerWith readerOptions writerOptions
        >>= renderKaTeX
        >>= saveSnapshot "content"
        >>= applyLucidTemplate postTemplate (postContext tags)

      recent <- fmap (take 5). recentFirst =<< loadAllSnapshots entryPattern "content"
      let ctx = listField  "recent-posts" (postContext tags) (return recent)
             <> yearMonthArchiveField "archives" yearMonthArchives
             <> postContext tags
      applyLucidTemplate defaultTemplate ctx r
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
        posts  <- recentFirst =<< loadAllSnapshots pat' "content"
        recent <- fmap (take 5) . recentFirst =<< loadAllSnapshots entryPattern "content"
        let ctx = constField  "title"        title
               <> constField  "tag"          tag
               <> listField   "posts"        postContext'       (return posts)
               <> listField   "recent-posts" (postContext tags) (return recent)
               <> yearMonthArchiveField "archives" yearMonthArchives
               <> paginateContext tagPages num
               <> siteContext tags
            postContext' = teaserField "teaser" "content" <> postContext tags
            title = "Tag archives: " ++ tag
        makeItem title
          >>= applyLucidTemplate entryListTemplate ctx
          >>= applyLucidTemplate defaultTemplate   ctx
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
        recent <- fmap (take 5) . recentFirst =<< loadAllSnapshots entryPattern "content"
        let ctx = constField  "title"         title
                <> listField   "posts"        postContext'       (return posts)
                <> listField   "recent-posts" (postContext tags) (return recent)
                <> yearMonthArchiveField' "archives" yearMonthArchives (year key)
                <> paginateContext ymaPages num
                <> siteContext tags
            postContext' = teaserField "teaser" "content" <> postContext tags
            title = case key of Yearly  _   -> "Yearly archives: "  ++ key'
                                Monthly _ _ -> "Monthly archives: " ++ key'
        makeItem title
          >>= applyLucidTemplate entryListTemplate ctx
          >>= applyLucidTemplate defaultTemplate   ctx
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
      posts  <- recentFirst =<< loadAllSnapshots pat "content"
      recent <- fmap (take 5) . recentFirst =<< loadAllSnapshots entryPattern "content"
      let ctx = constField  "title"        ""
             <> listField   "posts"        postContext'       (return posts)
             <> listField   "recent-posts" (postContext tags) (return recent)
             <> yearMonthArchiveField "archives" yearMonthArchives
             <> paginateContext entries num
             <> siteContext tags
          postContext' = teaserField "teaser" "content" <> postContext tags
      makeItem ""
        >>= applyLucidTemplate entryListTemplate ctx
        >>= applyLucidTemplate defaultTemplate   ctx
        >>= modifyExternalLinkAttributes
        >>= cleanIndexHtmls
        >>= renderFontAwesome faIcons

  create ["feed.xml"] $ do
    route idRoute
    compile $ do
      posts <- fmap (take 20) . recentFirst =<< loadAllSnapshots entryPattern "content"
      renderAtom atomFeedConfig (postContext tags) posts

  scssDependencies <- makePatternDependency "stylesheets/*/**.scss"
  rulesExtraDependencies [scssDependencies] $
    match "stylesheets/*.scss" $ do
      route $ setExtension "css"
      compile $ fmap compressCss <$> sassCompiler

  match "stylesheets/*.css" $ do
    route   idRoute
    compile compressCssCompiler

  create ["stylesheets/fontawesome.css"] $ do
    route   idRoute
    compile $ unsafeCompiler (readProcess fontAwesomeJS ["css"] [])
      >>= makeItem . compressCss

  create ["stylesheets/highlight.css"] $ do
    route   idRoute
    compile $ makeItem $ compressCss $ SL.styleToCss SL.pygments

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
                <> siteContext tags
  where descriptionField key len = field key $
          return . escapeHtml . take len . unescapeHtml . stripTags . itemBody
        unescapeHtml = TS.fromTagText . head . TS.parseTags

        imageField key = field key $ \item ->
          case find isImageTag $ TS.parseTags $ itemBody item of
               Just t  -> return $ TS.fromAttrib "src" t
               Nothing -> return ""
        isImageTag (TS.TagOpen "img" _) = True
        isImageTag _                    = False

siteContext :: Tags -> Context String
siteContext tags = constField       "lang"              "ja"
                <> constField       "site-title"        "Tosainu Lab"
                <> constField       "site-description"  "とさいぬのブログです"
                <> constField       "site-url"          "https://blog.myon.info"
                <> constField       "copyright"         "© 2011-2018 Tosainu."
                <> constField       "google-analytics"  "UA-57978655-1"
                <> constField       "disqus"            "tosainu"
                <> allTagsListField "all-tags"          tags
                <> authorContext
                <> defaultContext

authorContext :: Context String
authorContext    = constField       "author-name"       "Tosainu"
                <> constField       "author-profile"    "❤ Arch Linux, ごちうさ"
                <> constField       "author-portfolio"  "https://myon.info"
                <> constField       "author-avatar"     "https://myon.info/images/avatar.svg"
                <> constField       "author-twitter"    "myon___"

--- Misc
loadFontAwesomeIcons :: Rules (Maybe FontAwesomeIcons)
loadFontAwesomeIcons = preprocess $
  parseFontAwesomeIcons <$> readProcess fontAwesomeJS ["list"] []

sanitizeTagName :: String -> String
sanitizeTagName = map (\x -> if x == ' ' then '-' else toLower x) .
                  filter (liftM2 (||) isAlphaNum (`elem` [' ', '-', '_']))

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

fontAwesomeJS :: FilePath
fontAwesomeJS = "tools/fontawesome.js"
