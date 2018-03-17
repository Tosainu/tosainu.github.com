{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Monad
import           Data.Char
import qualified Data.HashMap.Strict     as HM
import           Data.List               (isInfixOf)
import           Data.Maybe              (fromMaybe)
import           Data.Monoid             ((<>))
import           Hakyll
import           Hakyll.Web.Sass
import qualified Skylighting.Format.HTML as SL
import qualified Skylighting.Styles      as SL
import           System.FilePath
import           System.Process          (readProcess)
import qualified Text.HTML.TagSoup       as TS
import           Text.Pandoc.Options

import           Templates

main :: IO ()
main = hakyllWith hakyllConfig $ do
  faIcons <- fromMaybe mempty <$> loadFontAwesomeIcons

  match ("CNAME" .||. "favicon.ico" .||. "images/**") $ do
    route idRoute
    compile copyFileCompiler

  tags <- buildTags "entry/*/*/*/*/index.md" $
    fromCapture "entry/tags/*/index.html" . sanitizeTagName

  -- "entry/year/month/day/title/index.md"
  match "entry/*/*/*/*/index.md" $ do
    route $ setExtension "html"
    compile $ do
      r <- pandocCompilerWith readerOptions writerOptions
        >>= kaTeXFilter
        >>= saveSnapshot "content"
        >>= applyLucidTemplate (postTemplate faIcons) (postContext tags)

      recent <- fmap (take 5). recentFirst
        =<< loadAllSnapshots "entry/*/*/*/*/index.md" "content"
      let ctx = listField  "recent-posts" (postContext tags) (return recent)
             <> postContext tags
      applyLucidTemplate (defaultTemplate faIcons) ctx r
        >>= modifyExternalLinkAttributes
        >>= cleanIndexHtmls

  match "entry/*/*/*/*/**" $ do
    route idRoute
    compile copyFileCompiler

  tagsRules tags $ \tag pat -> do
    let grouper  = fmap (paginateEvery 5) . sortRecentFirst
        tag'     = sanitizeTagName tag
        makeId n = fromFilePath $
                     if n == 1 then "entry/tags/" ++ tag' ++ "/index.html"
                               else "entry/tags/" ++ tag' ++ "/page/" ++ show n ++ "/index.html"
    tagPages <- buildPaginateWith grouper pat makeId

    paginateRules tagPages $ \num pat' -> do
      route idRoute
      compile $ do
        posts  <- recentFirst =<< loadAllSnapshots pat' "content"
        recent <- fmap (take 5) . recentFirst
          =<< loadAllSnapshots "entry/*/*/*/*/index.md" "content"
        let ctx = constField  "title"        ("Tag archives: " ++ tag)
               <> constField  "tag"          tag
               <> listField   "posts"        postContext'       (return posts)
               <> listField   "recent-posts" (postContext tags) (return recent)
               <> paginateContext tagPages num
               <> siteContext tags
            postContext' = teaserField "teaser" "content" <> postContext tags
        makeItem ""
          >>= applyLucidTemplate (entryListTemplate faIcons) ctx
          >>= applyLucidTemplate (defaultTemplate faIcons)   ctx
          >>= modifyExternalLinkAttributes
          >>= cleanIndexHtmls

  entries <- buildPaginateWith (fmap (paginateEvery 5) . sortRecentFirst)
                               "entry/*/*/*/*/index.md"
                               (\n -> if n == 1 then fromFilePath "index.html"
                                                else fromFilePath $ "page/" ++ show n ++ "/index.html")
  paginateRules entries $ \num pat -> do
    route idRoute
    compile $ do
      posts  <- recentFirst =<< loadAllSnapshots pat "content"
      recent <- fmap (take 5) . recentFirst
        =<< loadAllSnapshots "entry/*/*/*/*/index.md" "content"
      let ctx = listField   "posts"        postContext'       (return posts)
             <> listField   "recent-posts" (postContext tags) (return recent)
             <> paginateContext entries num
             <> siteContext tags
          postContext' = teaserField "teaser" "content" <> postContext tags
      makeItem ""
        >>= applyLucidTemplate (entryListTemplate faIcons) ctx
        >>= applyLucidTemplate (defaultTemplate faIcons)   ctx
        >>= modifyExternalLinkAttributes
        >>= cleanIndexHtmls

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

--- Contexts
postContext :: Tags -> Context String
postContext tags = dateField        "date"          "%Y/%m/%d %R%z"
                <> tagsListField    "tags"          tags
                <> siteContext tags

siteContext :: Tags -> Context String
siteContext tags = constField       "lang"              "ja"
                <> constField       "site-title"        "Tosainu Lab"
                <> constField       "site-description"  "todo"
                <> constField       "copyright"         "© 2011-2018 Tosainu."
                <> constField       "analytics"         "UA-57978655-1"
                <> constField       "disqus"            "tosainu"
                <> allTagsListField "all-tags"          tags
                <> authorContext
                <> defaultContext

authorContext :: Context String
authorContext    = constField       "name"          "Tosainu"
                <> constField       "profile"       "Arch Linux, ごちうさ❤"
                <> constField       "portfolio"     "https://myon.info"
                <> constField       "avatar"        "https://www.gravatar.com/avatar/a8648d613afd1ec0c84bb04973c98ad2.png?s=256"
                <> constField       "twitter"       "myon___"

--- Compilers
kaTeXFilter :: Item String -> Compiler (Item String)
kaTeXFilter item = do
  metadata <- getMetadata $ itemIdentifier item
  if HM.member "math" metadata then withItemBody (unixFilter kaTeXJS []) item
                               else return item

cleanIndexHtmls :: Item String -> Compiler (Item String)
cleanIndexHtmls = return . fmap (withUrls removeIndexHtml)
  where removeIndexHtml path
          | not (path `isInfixOf` "://") && takeFileName path == "index.html"
                      = dropFileName path
          | otherwise = path

modifyExternalLinkAttributes :: Item String -> Compiler (Item String)
modifyExternalLinkAttributes = return . fmap (withTags f)
  where f t | isExternalLink t = let (TS.TagOpen "a" as) = t
                                 in  (TS.TagOpen "a" $ as <> extraAttributs)
            | otherwise        = t
        isExternalLink = liftM2 (&&) (TS.isTagOpenName "a") (isExternal . TS.fromAttrib "href")
        extraAttributs = [("target", "_blank"), ("rel", "nofollow noopener")]

--- Misc
loadFontAwesomeIcons :: Rules (Maybe FontAwesomeIcons)
loadFontAwesomeIcons = preprocess $
  parseFontAwesomeIcons <$> readProcess fontAwesomeJS ["list"] []

sanitizeTagName :: String -> String
sanitizeTagName = map (\x -> if isSpace x then '-' else toLower x) .
                  filter (liftM2 (||) isAlphaNum isSpace)

--- Configurations
hakyllConfig :: Configuration
hakyllConfig = defaultConfiguration
  { destinationDirectory = "build"
  , storeDirectory       = ".cache"
  , tmpDirectory         = ".cache/tmp"
  , previewHost          = "0.0.0.0"
  , previewPort          = 4567
  }

readerOptions :: ReaderOptions
readerOptions = defaultHakyllReaderOptions
  { readerExtensions = readerExtensions defaultHakyllReaderOptions
                    <> extensionsFromList [ Ext_east_asian_line_breaks
                                          , Ext_emoji
                                          ]
  }

writerOptions :: WriterOptions
writerOptions = defaultHakyllWriterOptions
  { writerHTMLMathMethod = KaTeX ""
  }

kaTeXJS :: FilePath
kaTeXJS = "tools/katex.js"

fontAwesomeJS :: FilePath
fontAwesomeJS = "tools/fontawesome.js"
