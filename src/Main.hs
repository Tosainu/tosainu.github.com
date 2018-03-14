{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.HashMap.Strict     as HM
import           Hakyll
import           Hakyll.Web.Sass
import qualified Skylighting.Format.HTML as SL
import qualified Skylighting.Styles      as SL
import           System.Process          (readProcess)
import           Text.Pandoc.Options

import           Templates

main :: IO ()
main = hakyllWith hakyllConfig $ do
  match ("CNAME" .||. "favicon.ico" .||. "images/**") $ do
    route idRoute
    compile copyFileCompiler

  -- "entry/year/month/day/title/index.md"
  match "entry/*/*/*/*/index.md" $ do
    route $ setExtension "html"
    compile $ pandocCompilerWith readerOptions writerOptions

  match "entry/*/*/*/*/**" $ do
    route idRoute
    compile copyFileCompiler

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

--- Compilers
kaTeXFilter :: Item String -> Compiler (Item String)
kaTeXFilter item = do
  metadata <- getMetadata $ itemIdentifier item
  if HM.member "math" metadata then withItemBody (unixFilter kaTeXJS []) item
                               else return item

--- Misc
loadFontAwesomeIcons :: Rules (Maybe FontAwesomeIcons)
loadFontAwesomeIcons = preprocess $
  parseFontAwesomeIcons <$> readProcess fontAwesomeJS ["list"] []

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

writerOptions :: WriterOptions
writerOptions = defaultHakyllWriterOptions
  { writerHTMLMathMethod = KaTeX ""
  }

kaTeXJS :: FilePath
kaTeXJS = "tools/katex.js"

fontAwesomeJS :: FilePath
fontAwesomeJS = "tools/fontawesome.js"
