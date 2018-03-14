{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Hakyll
import           Hakyll.Web.Sass
import qualified Skylighting.Format.HTML as SL
import qualified Skylighting.Styles      as SL

main :: IO ()
main = hakyllWith hakyllConfig $ do
  match ("CNAME" .||. "favicon.ico" .||. "images/**") $ do
    route idRoute
    compile copyFileCompiler

  -- "entry/year/month/day/title/index.md"
  match "entry/*/*/*/*/index.md" $ do
    route $ setExtension "html"
    compile pandocCompiler

  match "entry/*/*/*/*/**" $ do
    route idRoute
    compile copyFileCompiler

  match "stylesheets/*.scss" $ do
    route $ setExtension "css"
    compile $ fmap compressCss <$> sassCompiler

  match "stylesheets/*.css" $ do
    route   idRoute
    compile compressCssCompiler

  create ["stylesheets/highlight.css"] $ do
    route   idRoute
    compile $ makeItem $ compressCss $ SL.styleToCss SL.pygments

  match ("node_modules/katex/dist/**" .&&. complement "**.js") $ do
    route $ gsubRoute "node_modules/katex/dist/" (const "vendor/katex/")
    compile copyFileCompiler

--- Configurations
hakyllConfig :: Configuration
hakyllConfig = defaultConfiguration
  { destinationDirectory = "build"
  , storeDirectory       = ".cache"
  , tmpDirectory         = ".cache/tmp"
  , previewHost          = "0.0.0.0"
  , previewPort          = 4567
  }

