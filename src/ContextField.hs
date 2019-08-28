module ContextField
  ( descriptionField
  , imageField
  , localDateField
  , tagsField'
  , tagCloudField'
  ) where

import           Control.Monad
import           Data.List           (find)
import           Data.Maybe
import qualified Data.Text           as T
import qualified Data.Text.Lazy      as TL
import           Data.Time.Format
import           Data.Time.LocalTime
import           Hakyll
import           Lucid.Base
import           Lucid.Html5
import qualified Text.HTML.TagSoup   as TS

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

localDateField :: TimeLocale -> TimeZone -> String -> String -> Context a
localDateField locale zone key format = field key $ \i ->
  formatTime locale format . utcToLocalTime zone <$> getItemUTC locale (itemIdentifier i)

tagsField' :: String -> Tags -> Context a
tagsField' key tags = field key $ \item -> do
  tags' <- getTags $ itemIdentifier item
  links <- forM tags' $ \tag -> do
    route' <- getRoute $ tagsMakeId tags tag
    return $ toLink' tag route'
  return $ TL.unpack $ renderText $ mconcat $ map li_ $ catMaybes links
  where toLink' _   Nothing     = Nothing
        toLink' tag (Just path) = Just $ toLink tag path

tagCloudField' :: String -> Tags -> Context a
tagCloudField' key tags = field key $ \_ -> renderTags toLink' concat tags
  where toLink' tag path _ _ _ = TL.unpack $ renderText $ li_ $ toLink tag path

toLink :: String -> String -> Html ()
toLink text path = a_ [href_ (T.pack $ toUrl path)] $ span_ $ toHtml text
