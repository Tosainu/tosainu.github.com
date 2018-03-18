{-# LANGUAGE OverloadedStrings #-}

module Templates.Post where

import qualified Data.Text             as T
import           Hakyll
import           Lucid.Base
import           Lucid.Html5
import qualified Network.URI.Encode    as URI

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
        runLucidTemplate disqusTemplate

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
shareButtonsTemplate icons = LucidTemplate $ do
  StringField pageTitle <- lookupMeta "title"
  StringField pageUrl   <- lookupMeta "url"
  StringField siteTitle <- lookupMeta "site-title"
  StringField siteUrl   <- lookupMeta "site-url"

  let title = URI.encode $ pageTitle ++ " | " ++ siteTitle
      url   = URI.encode $ siteUrl ++ pageUrl

  aside_ [class_ "share"] $ do
    StringField twitter <- lookupMeta "author-twitter"
    a_ [ classes_ ["share-button", "twitter"]
       , target_ "_blank"
       , rel_ "nofollow noopener"
       , href_ (T.pack $ "https://twitter.com/share?text=" ++ title ++ "&via=" ++ twitter)
       ] $ do
      with (fontawesome' icons "fab" "twitter") [class_ "fa-lg"]
      span_ "Twitter"

    a_ [ classes_ ["share-button", "hatena"]
       , target_ "_blank"
       , rel_ "nofollow noopener"
       , href_ (T.pack $
           "http://b.hatena.ne.jp/add?mode=confirm&url=" ++ url ++ "&title=" ++ title)
       ] $ do
      img_ [src_ "/images/hatenabookmark-logomark.svg"]
      span_ "hatena"

    a_ [ classes_ ["share-button", "google-plus"]
       , target_ "_blank"
       , rel_ "nofollow noopener"
       , href_ (T.pack $ "https://plusone.google.com/_/+1/confirm?url=" ++ url)
       ] $ do
      with (fontawesome' icons "fab" "google-plus-g") [class_ "fa-lg"]
      span_ "Google+"

    a_ [ classes_ ["share-button", "pocket"]
       , target_ "_blank"
       , rel_ "nofollow noopener"
       , href_ (T.pack $ "https://getpocket.com/save?url=" ++ url)
       ] $ do
      with (fontawesome' icons "fab" "get-pocket") [class_ "fa-lg"]
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
