{-# LANGUAGE OverloadedStrings #-}

module Templates.Default where

import           Control.Monad.Trans.Class
import           Data.List
import qualified Data.Text                 as T
import           Hakyll
import           Lucid.Base
import           Lucid.Html5

import           Templates.Core
import           Templates.FontAwesome

defaultTemplate :: FontAwesomeIcons -> LucidTemplate
defaultTemplate icons = LucidTemplate $ \ctx -> do
  StringField body      <- lift $ ctx "body"
  StringField copyright <- lift $ ctx "copyright"
  StringField lang      <- lift $ ctx "lang"
  StringField siteTitle <- lift $ ctx "site-title"
  StringField pageTitle <- lift $ ctx "title"

  -- TODO: pass these variables by metadata
  let description = "nyan"
      author      = "Tosainu"

      title       = if pageTitle /= "" then pageTitle ++ " | " ++ siteTitle
                                       else siteTitle

  doctype_
  html_ [lang_ $ T.pack lang] $ do
    head_ $ do
      meta_  [charset_ "utf-8"]
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
                div_ [class_ "about"] "TODO"

              section_ [class_ "recent-posts"] $ do
                h4_ $ do
                  with (fontawesome' icons "fas" "file-alt") [class_ "fa-fw"]
                  " Recent Posts"
                ul_ $ li_ "TODO"

            section_ [class_ "tag-cloud"] $ do
              h4_ $ do
                with (fontawesome' icons "fas" "tags") [class_ "fa-fw"]
                " Tags"
              ul_ $ li_ "TODO"

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
