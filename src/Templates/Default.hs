{-# LANGUAGE OverloadedStrings #-}

module Templates.Default where

import           Control.Monad.Trans.Class
import           Hakyll
import           Lucid.Base
import           Lucid.Html5

import           Templates.Core

defaultTemplate :: LucidTemplate
defaultTemplate = LucidTemplate $ \ctx -> do
  StringField title <- lift $ ctx "title"
  StringField body  <- lift $ ctx "body"

  -- TODO: pass these variables by metadata
  let lang        = "ja"
      description = "nyan"
      author      = "Tosainu"

  doctype_
  html_ [lang_ lang] $ do
    head_ $ do
      meta_  [charset_ "utf-8"]
      title_ (toHtml title)
      link_ [rel_ "stylesheet", href_ "/stylesheets/style.css"]
      link_ [rel_ "stylesheet", href_ "/stylesheets/highlight.css"]
      link_ [rel_ "stylesheet", href_ "/stylesheets/fontawesome.css"]
      link_ [rel_ "stylesheet", href_ "/vendor/katex/katex.min.css"]

    body_ $ toHtmlRaw body
