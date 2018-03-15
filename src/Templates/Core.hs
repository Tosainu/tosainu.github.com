module Templates.Core where

import           Control.Monad.Trans.Class
import qualified Data.Text.Lazy               as TL
import           Hakyll
import           Hakyll.Web.Template.Internal (TemplateExpr (..),
                                               TemplateKey (..))
import           Lucid.Base

newtype LucidTemplate = LucidTemplate
  { runLucidTemplate :: (TemplateExpr -> Compiler ContextField) -> HtmlT Compiler () }

applyLucidTemplate :: LucidTemplate -> Context a -> Item a -> Compiler (Item String)
applyLucidTemplate template context item = do
    body <- fmap TL.unpack . renderTextT $ runLucidTemplate template applyExpr
    return $ itemSetBody body item
  where
    applyExpr (StringLiteral s)            = return (StringField s)
    applyExpr (Ident (TemplateKey k))      = context' k [] item
    applyExpr (Call  (TemplateKey k) args) = do
        args' <- mapM (\e -> applyExpr e >>= getString e) args
        context' k args' item

    context' = unContext $ context `mappend` missingField

    getString _ (StringField s) = return s
    getString e (ListField _ _) = fail $ "expected StringField but got ListField for expr " ++ show e

lookupMeta :: (TemplateExpr -> Compiler ContextField) -> String -> HtmlT Compiler ContextField
lookupMeta e k = lift $ e (Ident (TemplateKey k))

lookupMetaWithArgs :: (TemplateExpr -> Compiler ContextField) -> String -> [String] -> HtmlT Compiler ContextField
lookupMetaWithArgs e k a = lift $ e (Call (TemplateKey k) a')
  where a' = map StringLiteral a
