{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Hakyll

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

