module Templates.Tags
  ( tagsListField
  , allTagsListField
  ) where

import           Hakyll
import           Text.Blaze.Html                 ((!))
import qualified Text.Blaze.Html.Renderer.String as B
import qualified Text.Blaze.Html5                as BH
import qualified Text.Blaze.Html5.Attributes     as BA

tagsListField :: String -> Tags -> Context a
tagsListField = tagsFieldWith getTags toLink' $ mconcat . map BH.li
  where toLink' _   Nothing     = Nothing
        toLink' tag (Just path) = Just $ toLink tag path

allTagsListField :: String -> Tags -> Context a
allTagsListField key tags = field key $ \_ -> renderTags toLink' concat tags
  where toLink' tag path _ _ _ = B.renderHtml $ BH.li $ toLink tag path

toLink :: String -> String -> BH.Html
toLink text path = BH.a ! BA.href (BH.toValue $ toUrl path) $ BH.span $ BH.toHtml text
