{-# LANGUAGE OverloadedStrings #-}

module Templates.Post where

import           Hakyll
import           Lucid.Base
import           Lucid.Html5
import qualified Data.Text                 as T

import           Templates.Core
import           Templates.FontAwesome

postTemplate :: FontAwesomeIcons -> LucidTemplate a
postTemplate icons = LucidTemplate $ do
  StringField body <- lookupMeta "body"

  main_ [class_ "post", role_ "main"] $
    article_ $ do
      header_ [class_ "post-header"] $
        div_ [class_ "container"] $
          runLucidTemplate $ postHeaderTemplate icons

      div_ [class_ "container"] $ do
        div_ [class_ "post-contents"] $
          toHtmlRaw body

        runLucidTemplate $ shareButtonsTemplate icons

postHeaderTemplate :: FontAwesomeIcons -> LucidTemplate a
postHeaderTemplate icons = LucidTemplate $ do
  StringField date  <- lookupMeta "date"
  StringField tags  <- lookupMeta "tags"
  StringField title <- lookupMeta "title"
  StringField url   <- lookupMeta "url"

  h1_ $
    a_ [href_ (T.pack url), title_ (T.pack title)] $ toHtml title

  ul_ [class_ "post-meta"] $ do
    li_                 $ fontawesome' icons "fas" "calendar-alt"
    li_ [class_ "date"] $ toHtml date
    li_                 $ fontawesome' icons "fas" "tags"
    li_ $
      ul_ [class_ "tag-list"] $ toHtmlRaw tags

shareButtonsTemplate :: FontAwesomeIcons -> LucidTemplate a
shareButtonsTemplate icons = LucidTemplate $
  aside_ [class_ "share"] $ do
    a_ [classes_ ["share-button", "twitter"]] $ do
      with (fontawesome' icons "fab" "twitter") [class_ "fa-lg"]
      span_ "Twitter"

    a_ [classes_ ["share-button", "hatena"]] $ do
      img_ [src_ "/images/hatenabookmark-logomark.svg"]
      span_ "hatena"

    a_ [classes_ ["share-button", "google-plus"]] $ do
      with (fontawesome' icons "fab" "google-plus-g") [class_ "fa-lg"]
      span_ "Google+"

    a_ [classes_ ["share-button", "pocket"]] $ do
      with (fontawesome' icons "fab" "get-pocket") [class_ "fa-lg"]
      span_ "Pocket"
