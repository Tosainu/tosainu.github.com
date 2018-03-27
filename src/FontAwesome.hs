{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module FontAwesome
  ( FontAwesomeIcons
  , fontawesome
  , parseFontAwesomeIcons
  , renderFontAwesome
  ) where

import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BSL
import qualified Data.HashMap.Strict        as HM
import           Data.Maybe
import qualified Data.Text                  as T
import qualified Data.Text.Lazy             as TL
import           Hakyll
import           Lucid.Base
import           Lucid.Html5
import qualified Text.HTML.TagSoup.Tree     as TS

import           Compiler                   (tagSoupOption)

data Element = Element { tag        :: T.Text
                       , attributes :: [Attribute]
                       , children   :: [Element]
                       }
             deriving Show

instance FromJSON Element where
  parseJSON = withObject "Element" $ \o -> do
    tag        <- o .: "tag"
    attributes <- objectToAttributes <$> o .:? "attributes" .!= HM.empty
    children   <- o .:? "children" .!= []
    return Element {..}

    where objectToAttributes = map (uncurry makeAttribute) . HM.toList

-- FontAwesomeIcons [(prefix, [(name, icon-meta)])]
type FontAwesomeIcons = HM.HashMap T.Text (HM.HashMap T.Text Element)

fontawesome :: Monad m => FontAwesomeIcons -> T.Text -> T.Text -> Maybe (HtmlT m ())
fontawesome db prefix name = toLucid <$> (HM.lookup prefix db >>= HM.lookup name)

toLucid :: Monad m => Element -> HtmlT m ()
toLucid = termWith <$> tag <*> attributes <*> children'
  where children' = mconcat . map toLucid . children

parseFontAwesomeIcons :: String -> Maybe FontAwesomeIcons
parseFontAwesomeIcons = decode . BSL.pack

renderFontAwesome :: FontAwesomeIcons -> Item String -> Compiler (Item String)
renderFontAwesome icons = return . fmap
    (TS.renderTreeOptions tagSoupOption . TS.transformTree renderFontAwesome' . TS.parseTree)
  where
    renderFontAwesome' tag@(TS.TagBranch "i" as []) =
      case toFontAwesome $ classes as of
           Just html -> TS.parseTree $ TL.unpack $ renderText html
           Nothing   -> [tag]
    renderFontAwesome' tag = [tag]

    toFontAwesome (prefix:('f':'a':'-':name):cs) =
      let prefix'  = T.pack prefix
          name'    = T.pack name
          classes' = T.pack $ " " ++ unwords cs
      in  fmap (`with` [class_ classes']) (fontawesome icons prefix' name')
    toFontAwesome _ = Nothing

    classes = words . fromMaybe "" . lookup "class"
