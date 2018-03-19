{-# LANGUAGE OverloadedStrings #-}

module Compiler where

import           Control.Monad
import qualified Data.HashMap.Strict as HM
import           Data.List           (isInfixOf)
import           Data.Monoid         ((<>))
import           Hakyll
import           System.FilePath
import qualified Text.HTML.TagSoup   as TS

kaTeXFilter :: Item String -> Compiler (Item String)
kaTeXFilter item = do
  metadata <- getMetadata $ itemIdentifier item
  if HM.member "math" metadata then withItemBody (unixFilter  "tools/katex.js" []) item
                               else return item

cleanIndexHtmls :: Item String -> Compiler (Item String)
cleanIndexHtmls = return . fmap (withUrls removeIndexHtml)
  where removeIndexHtml path
          | not (path `isInfixOf` "://") && takeFileName path == "index.html"
                      = dropFileName path
          | otherwise = path

modifyExternalLinkAttributes :: Item String -> Compiler (Item String)
modifyExternalLinkAttributes = return . fmap (withTags f)
  where f t | isExternalLink t = let (TS.TagOpen "a" as) = t
                                 in  (TS.TagOpen "a" $ as <> extraAttributs)
            | otherwise        = t
        isExternalLink = liftM2 (&&) (TS.isTagOpenName "a") (isExternal . TS.fromAttrib "href")
        extraAttributs = [("target", "_blank"), ("rel", "nofollow noopener")]
