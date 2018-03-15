module Templates.Tags
  ( tagsListField
  , allTagsListField
  ) where

import           Text.Blaze.Html                 (toHtml, toValue, (!))
import           Text.Blaze.Html.Renderer.String (renderHtml)
import qualified Text.Blaze.Html5                as H
import qualified Text.Blaze.Html5.Attributes     as A
import           Hakyll

tagsListField :: String -> Tags -> Context a
tagsListField = tagsFieldWith getTags toLink' $ mconcat . map H.li
  where toLink' _   Nothing     = Nothing
        toLink' tag (Just path) = Just $ toLink tag path

allTagsListField :: String -> Tags -> Context a
allTagsListField key tags = field key $ \_ -> renderTags toLink' concat tags
  where toLink' tag path _ _ _ = renderHtml $ H.li $ toLink tag path

toLink :: String -> String -> H.Html
toLink text path = H.a ! A.href (toValue $ toUrl path) $ H.span $ toHtml text
