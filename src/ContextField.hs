module ContextField
  ( descriptionField
  , imageField
  , localDateField
  , tagsListField
  , allTagsListField
  ) where

import           Control.Monad
import           Data.List         (find)
import           Data.Maybe
import qualified Data.Text         as T
import qualified Data.Text.Lazy    as TL
import qualified Data.Time.Format  as Time
import           Hakyll
import           Lucid.Base
import           Lucid.Html5
import qualified Text.HTML.TagSoup as TS

import           LocalTime

descriptionField :: String -> Int -> Context String
descriptionField key len = field key $ \_ ->
  take len . escapeHtml . concat . lines . itemBody <$> getResourceBody

imageField :: String -> Context String
imageField key = field key $ \item ->
  case find isImageTag $ TS.parseTags $ itemBody item of
       Just t  -> return $ TS.fromAttrib "src" t
       Nothing -> return ""
  where
    isImageTag (TS.TagOpen "img" _) = True
    isImageTag _                    = False

localDateField :: String -> String -> Context a
localDateField key format = field key $ \i ->
  Time.formatTime defaultTimeLocale format <$> getItemLocalTime (itemIdentifier i)

tagsListField :: String -> Tags -> Context a
tagsListField key tags = field key $ \item -> do
  tags' <- getTags $ itemIdentifier item
  links <- forM tags' $ \tag -> do
    route' <- getRoute $ tagsMakeId tags tag
    return $ toLink' tag route'
  return $ TL.unpack $ renderText $ mconcat $ map li_ $ catMaybes links
  where toLink' _   Nothing     = Nothing
        toLink' tag (Just path) = Just $ toLink tag path

allTagsListField :: String -> Tags -> Context a
allTagsListField key tags = field key $ \_ -> renderTags toLink' concat tags
  where toLink' tag path _ _ _ = TL.unpack $ renderText $ li_ $ toLink tag path

toLink :: String -> String -> Html ()
toLink text path = a_ [href_ (T.pack $ toUrl path)] $ span_ $ toHtml text
