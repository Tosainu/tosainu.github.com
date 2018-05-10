{-# LANGUAGE OverloadedStrings #-}

module Template.Post where

import qualified Data.Text          as T
import           Hakyll
import           Lucid.Base
import           Lucid.Html5
import qualified Network.URI.Encode as URI

import           Template.Core

postTemplate :: LucidTemplate a
postTemplate = LucidTemplate $ do
  StringField body <- lookupMeta "body"

  main_ [class_ "post"] $
    article_ $ do
      header_ [class_ "post-header"] $
        div_ [class_ "container"] $
          runLucidTemplate postHeaderTemplate

      div_ [class_ "container"] $ do
        div_ [class_ "post-contents"] $
          toHtmlRaw body

        runLucidTemplate shareButtonsTemplate
        runLucidTemplate disqusTemplate
        runLucidTemplate entryNavigationTeplate

postHeaderTemplate :: LucidTemplate a
postHeaderTemplate = LucidTemplate $ do
  StringField date  <- lookupMeta "date"
  StringField tags  <- lookupMeta "tags"
  StringField title <- lookupMeta "title"
  StringField url   <- lookupMeta "url"

  h1_ $
    a_ [href_ (T.pack url), title_ (T.pack title)] $ toHtml title

  ul_ [class_ "post-meta"] $ do
    li_                 $ i_ [classes_ ["fas", "fa-calendar-alt"]] ""
    li_ [class_ "date"] $ toHtml date

    if tags == "" then return () else do
      li_ $ i_  [classes_ ["fas", "fa-tags"]] ""
      li_ $ ul_ [class_ "tag-list"] $ toHtmlRaw tags

shareButtonsTemplate :: LucidTemplate a
shareButtonsTemplate = LucidTemplate $ do
  StringField pageTitle <- lookupMeta "title"
  StringField pageUrl   <- lookupMeta "url"
  StringField siteTitle <- lookupMeta "site-title"
  StringField siteUrl   <- lookupMeta "site-url"

  let title = URI.encode $ pageTitle ++ " | " ++ siteTitle
      url   = URI.encode $ siteUrl ++ pageUrl

  aside_ [class_ "share"] $ do
    a_ [ classes_ ["share-button", "twitter"]
       , href_ (T.pack $ "https://twitter.com/share?text=" ++ title ++ "&url=" ++ url)
       ] $ do
      i_ [classes_ ["fab", "fa-twitter", "fa-lg"]] ""
      span_ "Twitter"

    a_ [ classes_ ["share-button", "hatena"]
       , href_ (T.pack $
           "http://b.hatena.ne.jp/add?mode=confirm&url=" ++ url ++ "&title=" ++ title)
       ] $ do
      img_ [src_ "/images/hatenabookmark-logomark.svg"]
      span_ "hatena"

    a_ [ classes_ ["share-button", "google-plus"]
       , href_ (T.pack $ "https://plusone.google.com/_/+1/confirm?url=" ++ url)
       ] $ do
      i_ [classes_ ["fab", "fa-google-plus-g", "fa-lg"]] ""
      span_ "Google+"

    a_ [ classes_ ["share-button", "pocket"]
       , href_ (T.pack $ "https://getpocket.com/save?url=" ++ url)
       ] $ do
      i_ [classes_ ["fab", "fa-get-pocket", "fa-lg"]] ""
      span_ "Pocket"

disqusTemplate :: LucidTemplate a
disqusTemplate = LucidTemplate $ do
  StringField shortname <- lookupMeta "disqus"
  aside_ [class_ "comments"] $ do
    div_ [id_ "disqus_thread"] ""
    script_ $ mconcat
      [ "(function() { var d = document, s = d.createElement('script');"
      , "s.src = 'https://"
      , T.pack shortname
      , ".disqus.com/embed.js';"
      , "s.setAttribute('data-timestamp', +new Date());"
      , "(d.head || d.body).appendChild(s); })();"
      ]
    noscript_ $ do
      "Please enable JavaScript to view the "
      a_ [href_ "https://disqus.com/?ref_noscript"] "comments powered by Disqus."

entryNavigationTeplate :: LucidTemplate a
entryNavigationTeplate = LucidTemplate $
  nav_ [classes_ ["nav", "post-nav"]] $
    -- div_ [class_ "prev"] "TODO"
    --
    -- div_ [class_ "next"] "TODO"
    return ()
