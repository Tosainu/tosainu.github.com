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
import           Hakyll
import           Text.HTML.TagSoup
import           Text.HTML.TagSoup.Tree

import           Compiler                   (tagSoupOption)

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

fontawesome :: FontAwesomeIcons -> String -> String -> Maybe (TagTree String)
fontawesome db prefix name = toTagTree <$> (HM.lookup prefix db >>= HM.lookup name)

toTagTree :: Element -> TagTree String
toTagTree = TagBranch <$> tag <*> attributes <*> children'
  where children' = map toTagTree . children

parseFontAwesomeIcons :: String -> Maybe FontAwesomeIcons
parseFontAwesomeIcons = decode . BSL.pack

renderFontAwesome :: FontAwesomeIcons -> Item String -> Compiler (Item String)
renderFontAwesome icons = return . fmap
    (renderTreeOptions tagSoupOption . transformTree renderFontAwesome' . parseTree)
  where
    renderFontAwesome' tag@(TagBranch "i" as []) =
      case toFontAwesome $ classes as of
           Just tree -> [tree]
           Nothing   -> [tag]
    renderFontAwesome' tag = [tag]

    toFontAwesome (prefix:('f':'a':'-':name):cs) =
      fmap (`appendClasses` cs) (fontawesome icons prefix name)
    toFontAwesome _ = Nothing

    appendClasses t [] = t
    appendClasses (TagBranch x y z) cs =
      let as1 = HM.fromList y
          as2 = HM.singleton "class" $ unwords cs
          y'  = HM.toList $ HM.unionWith (\v1 v2 -> v1 ++ " " ++ v2) as1 as2
      in  TagBranch x y' z
    appendClasses t _ = t

    classes = words . fromMaybe "" . lookup "class"
