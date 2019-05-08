{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module FontAwesome
  ( FontAwesomeIcons
  , fontawesome
  , loadFontAwesomeIcons
  ) where

import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BSL
import qualified Data.HashMap.Strict        as HM
import           System.Process             (readProcess)
import           Text.HTML.TagSoup
import           Text.HTML.TagSoup.Tree

data Element = Element { tag        :: String
                       , attributes :: [Attribute String]
                       , children   :: [Element]
                       }
             deriving Show

instance FromJSON Element where
  parseJSON = withObject "Element" $ \o -> do
    tag        <- o .: "tag"
    attributes <- HM.toList <$> o .:? "attributes" .!= HM.empty
    children   <- o .:? "children" .!= []
    return Element {..}

-- FontAwesomeIcons [(prefix, [(name, icon-meta)])]
type FontAwesomeIcons = HM.HashMap String (HM.HashMap String Element)

loadFontAwesomeIcons :: IO (Maybe FontAwesomeIcons)
loadFontAwesomeIcons = decode . BSL.pack <$> readProcess "tools/fontawesome.js" [] ""

fontawesome :: FontAwesomeIcons -> String -> String -> Maybe (TagTree String)
fontawesome db prefix name = toTagTree <$> (HM.lookup prefix db >>= HM.lookup name)

toTagTree :: Element -> TagTree String
toTagTree = TagBranch <$> tag <*> attributes <*> children'
  where children' = map toTagTree . children
