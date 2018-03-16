{-# LANGUAGE OverloadedStrings #-}

module Templates.EntryList where

import           Control.Monad
import           Hakyll
import           Lucid.Base
import           Lucid.Html5

import           Templates.Core
import           Templates.FontAwesome
import           Templates.Post

entryListTemplate :: FontAwesomeIcons -> LucidTemplate a
entryListTemplate icons = LucidTemplate $ do
  StringField body <- lookupMeta "body"

  main_ [class_ "list", role_ "main"] $ do
    toHtmlRaw body

    div_ [class_ "container"] $
      div_ [class_ "items"] $ do
        ListField ctx items <- lookupMeta "posts"
        forM_ (zip (repeat ctx) items) $ flip withContext $ do
          StringField postBody <- lookupMeta "body"

          article_ $ do
            header_ [class_ "post-header"] $
              runLucidTemplate $ postHeaderTemplate icons

            div_ [class_ "post-contents"] $
              toHtmlRaw postBody
