{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Templates.FontAwesome
  ( FontAwesomeIcons
  , fontawesome
  , fontawesome'
  , parseFontAwesomeIcons
  ) where

import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BSL
import qualified Data.HashMap.Strict        as HM
import           Data.Maybe                 (fromJust)
import           Data.Monoid                (mconcat)
import qualified Data.Text                  as T
import           Lucid.Base

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

fontawesome' :: Monad m => FontAwesomeIcons -> T.Text -> T.Text -> HtmlT m ()
fontawesome' = ((fromJust .) .) . fontawesome

toLucid :: Monad m => Element -> HtmlT m ()
toLucid = termWith <$> tag <*> attributes <*> children'
  where children' = mconcat . map toLucid . children

parseFontAwesomeIcons :: String -> Maybe FontAwesomeIcons
parseFontAwesomeIcons = decode . BSL.pack
