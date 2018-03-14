module Templates.Core where

import qualified Data.Text.Lazy as TL
import           Hakyll
import           Lucid.Base

newtype LucidTemplate = LucidTemplate
  { runLucidTemplate :: (String -> Compiler ContextField) -> HtmlT Compiler () }

applyLucidTemplate :: LucidTemplate -> Context a -> Item a -> Compiler (Item String)
applyLucidTemplate template context item = do
    body <- fmap TL.unpack . renderTextT $ runLucidTemplate template lookupMeta
    return $ itemSetBody body item
  where
    lookupMeta key = unContext context key [] item
