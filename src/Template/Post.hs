{-# LANGUAGE OverloadedStrings #-}

module Template.Post where

import qualified Data.Text   as T
import           Hakyll
import           Lucid.Base
import           Lucid.Html5

import           Template.Core

postTemplate :: LucidTemplate a
postTemplate = LucidTemplate $ do
  StringField body <- lookupField "body"

  main_ [class_ "post"] $
    article_ $ do
      header_ [class_ "post-header"] $
        div_ [class_ "container"] $
          runLucidTemplate postHeaderTemplate

      div_ [class_ "container"] $ do
        div_ [class_ "post-contents"] $
          toHtmlRaw body

        runLucidTemplate disqusTemplate

postHeaderTemplate :: LucidTemplate a
postHeaderTemplate = LucidTemplate $ do
  StringField date  <- lookupField "date"
  StringField tags  <- lookupField "tags"
  StringField title <- lookupField "title"
  StringField url   <- lookupField "url"

  h1_ $
    a_ [href_ (T.pack url), title_ (T.pack title)] $ toHtml title

  ul_ [class_ "post-meta"] $ do
    li_                 $ i_ [classes_ ["fas", "fa-calendar-alt"]] ""
    li_ [class_ "date"] $ toHtml date

    if tags == "" then return () else do
      li_ $ i_  [classes_ ["fas", "fa-tags"]] ""
      li_ $ ul_ [class_ "tag-list"] $ toHtmlRaw tags

disqusTemplate :: LucidTemplate a
disqusTemplate = LucidTemplate $ do
  StringField shortname <- lookupField "disqus"
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
