{-# LANGUAGE OverloadedStrings #-}

module Templates.Default where

import           Control.Monad
import           Data.List
import qualified Data.Text             as T
import           Hakyll
import           Lucid.Base
import           Lucid.Html5

import           Templates.Core
import           Templates.FontAwesome

defaultTemplate :: FontAwesomeIcons -> LucidTemplate a
defaultTemplate icons = LucidTemplate $ do
  -- page infoemations
  StringField body      <- lookupMeta "body"
  StringField copyright <- lookupMeta "copyright"
  StringField lang      <- lookupMeta "lang"
  StringField siteDesc  <- lookupMeta "site-description"
  StringField siteTitle <- lookupMeta "site-title"
  StringField pageTitle <- lookupMeta "title"
  StringField allTags   <- lookupMeta "all-tags"
  StringField analytics <- lookupMeta "analytics"

  -- author informations
  StringField name      <- lookupMeta "name"
  StringField portfolio <- lookupMeta "portfolio"
  StringField profile   <- lookupMeta "profile"
  StringField avatar    <- lookupMeta "avatar"

  -- TODO: pass these variables by metadata
  let description = siteDesc
      title       = if pageTitle /= "" then pageTitle ++ " | " ++ siteTitle
                                       else siteTitle

  doctype_
  html_ [lang_ $ T.pack lang] $ do
    head_ $ do
      meta_ [charset_ "utf-8"]
      meta_ [name_ "authr",       content_ (T.pack name)]
      meta_ [name_ "description", content_ (T.pack description)]
      meta_ [name_ "generator",   content_ "Hakyll"]
      meta_ [name_ "viewport",    content_ "width=device-width, initial-scale=1"]

      -- TODO: OG tags

      title_ (toHtml title)

      link_ [rel_ "stylesheet", href_ "/stylesheets/style.css"]
      link_ [rel_ "stylesheet", href_ "/stylesheets/highlight.css"]
      link_ [rel_ "stylesheet", href_ "/stylesheets/fontawesome.css"]
      link_ [rel_ "stylesheet", href_ "/vendor/katex/katex.min.css"]

    body_ $ do
      header_ [class_ "site-header"] $
        div_ [class_ "container"] $
          h1_ $
            a_  [href_ "/", title_ "home"] $ toHtml siteTitle

      toHtmlRaw body

      footer_ [class_ "site-footer"] $ do
        div_ [class_ "footer-widgets"] $
          div_ [class_ "container"] $ do
            div_ [class_ "col"] $ do
              section_ [class_ "about-me"] $ do
                h4_ $ do
                  with (fontawesome' icons "fas" "user") [class_ "fa-fw"]
                  " About Me"
                div_ [class_ "about"] $ do
                  div_ [class_ "avatar"] $
                    img_ [class_ "icon", src_ (T.pack avatar), alt_ "avatar"]
                  div_ [class_ "info"] $ do
                    div_ [class_ "name"] $ a_ [href_ (T.pack portfolio)] $ toHtml name
                    div_ [class_ "info"] $ toHtml profile

              section_ [class_ "recent-posts"] $ do
                h4_ $ do
                  with (fontawesome' icons "fas" "file-alt") [class_ "fa-fw"]
                  " Recent Posts"
                ul_ $ do
                  ListField ctx items <- lookupMeta "recent-posts"
                  forM_ (zip (repeat ctx) items) $ flip withContext $ do
                    StringField t <- lookupMeta "title"
                    StringField u <- lookupMeta "url"
                    li_ $
                      a_ [href_ (T.pack u)] $ toHtml t

            section_ [class_ "tag-cloud"] $ do
              h4_ $ do
                with (fontawesome' icons "fas" "tags") [class_ "fa-fw"]
                " Tags"
              ul_ [class_ "tag-list"] $ toHtmlRaw allTags

            section_ [class_ "archives"] $ do
              h4_ $ do
                with (fontawesome' icons "fas" "archive") [class_ "fa-fw"]
                " Archives"
              ul_ $ li_ "TODO"

        div_ [class_ "footer-bottom"] $
          div_ [class_ "container"] $ do
            div_ [class_ "copyright"] (toHtml copyright)

            div_ [class_ "powered-by"] $ do
              "Powered by "
              mconcat $ intersperse ", " $ fmap (\(t, u) -> a_ [href_ u] t)
                [ ("Hakyll",       "https://jaspervdj.be/hakyll/")
                , ("Font Awesome", "http://fontawesome.io/")
                , ("KaTeX",        "https://khan.github.io/KaTeX/")
                , ("Travis CI",    "https://travis-ci.org/")
                , ("GitHub Pages", "https://pages.github.com/")
                , ("CloudFlare",   "https://www.cloudflare.com/")
                ]
              "."

      script_ $ mconcat
        [ "(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){"
        , "(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),"
        , "m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)"
        , "})(window,document,'script','//www.google-analytics.com/analytics.js','ga');"
        , "ga('create', '"
        , T.pack analytics
        , "', 'auto');ga('send', 'pageview');"
        ]
