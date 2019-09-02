{-# LANGUAGE OverloadedStrings #-}

module Template.EntryList where

import           Control.Monad
import           Data.Maybe
import qualified Data.Text     as T
import           Hakyll
import           Lucid.Base
import           Lucid.Html5

import           Template.Core
import           Template.Post

entryListTemplate :: LucidTemplate a
entryListTemplate = LucidTemplate $ do
  StringField body <- lookupField "body"

  main_ [class_ "list"] $ do
    if body == "" then return () else
      aside_ [class_ "filter"] $
        div_ [class_ "container"] $
          span_ $ toHtmlRaw body

    div_ [class_ "container"] $ do
      div_ [class_ "items"] $ do
        ListField ctx items <- lookupField "posts"
        forM_ (zip (repeat ctx) items) $ flip withContext $
          article_ $ do
            header_ [class_ "post-header"] $
              runLucidTemplate postHeaderTemplate

            div_ [class_ "post-contents"] $ do
              mt <- lookupFieldMaybe "teaser"
              case mt of
                   Just (StringField t) -> do
                     StringField url <- lookupField "url"
                     toHtmlRaw t
                     a_ [href_ (T.pack url)] "Read More »"

                   _ -> do
                     StringField postBody <- lookupField "body"
                     toHtmlRaw postBody

      runLucidTemplate entryListNavigationTeplate

entryListNavigationTeplate :: LucidTemplate a
entryListNavigationTeplate = LucidTemplate $ do
  hasPaginateContext <- isJust <$> lookupFieldMaybe "currentPageNum"
  if not hasPaginateContext then return () else
    nav_ [classes_ ["nav", "list-nav"]] $ do
      div_ [class_ "prev"] $ do
        mppu <- lookupFieldMaybe "previousPageUrl"
        case mppu of
             Just (StringField ppu) -> a_ [href_ (T.pack ppu)] "« Previous"
             _                      -> " "

      div_ [class_ "counter"] $ do
        StringField numPages       <- lookupField "numPages"
        StringField currentpageNum <- lookupField "currentPageNum"
        toHtml $ "- " ++ currentpageNum ++ " of " ++ numPages ++ " -"

      div_ [class_ "next"] $ do
        mnpu <- lookupFieldMaybe "nextPageUrl"
        case mnpu of
             Just (StringField npu) -> a_ [href_ (T.pack npu)] "Next »"
             _                      -> " "
