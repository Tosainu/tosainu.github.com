{-# LANGUAGE OverloadedStrings #-}

module Templates.EntryList where

import           Control.Monad
import           Data.Maybe
import qualified Data.Text             as T
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

    div_ [class_ "container"] $ do
      div_ [class_ "items"] $ do
        ListField ctx items <- lookupMeta "posts"
        forM_ (zip (repeat ctx) items) $ flip withContext $ do
          StringField postBody <- lookupMeta "body"

          article_ $ do
            header_ [class_ "post-header"] $
              runLucidTemplate $ postHeaderTemplate icons

            div_ [class_ "post-contents"] $
              toHtmlRaw postBody

      runLucidTemplate entryListNavigationTeplate

entryListNavigationTeplate :: LucidTemplate a
entryListNavigationTeplate = LucidTemplate $ do
  hasPaginateContext <- isJust <$> lookupMetaMaybe "currentPageNum"
  if not hasPaginateContext then return () else
    nav_ [classes_ ["nav", "list-nav"]] $ do
      div_ [class_ "prev"] $ do
        mppu <- lookupMetaMaybe "previousPageUrl"
        case mppu of
             Just (StringField ppu) -> a_ [href_ (T.pack ppu)] "« Previous"
             _                      -> " "

      div_ [class_ "counter"] $ do
        StringField numPages       <- lookupMeta "numPages"
        StringField currentpageNum <- lookupMeta "currentPageNum"
        toHtml $ "- " ++ currentpageNum ++ " of " ++ numPages ++ " -"

      div_ [class_ "next"] $ do
        mnpu <- lookupMetaMaybe "nextPageUrl"
        case mnpu of
             Just (StringField npu) -> a_ [href_ (T.pack npu)] "Next »"
             _                      -> " "
