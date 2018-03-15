module Templates.Core where

import           Control.Monad.Trans.Class
import           Control.Monad.Trans.Reader
import qualified Data.Text.Lazy               as TL
import           Hakyll
import           Hakyll.Web.Template.Internal (TemplateExpr (..),
                                               TemplateKey (..))
import           Lucid.Base

type LucidTemplateMonad a r = HtmlT (ReaderT (Context a, Item a) Compiler) r

newtype LucidTemplate a = LucidTemplate { runLucidTemplate :: LucidTemplateMonad a () }

applyLucidTemplate :: LucidTemplate a -> Context a -> Item a -> Compiler (Item String)
applyLucidTemplate template context item = do
  body <- TL.unpack <$> runReaderT (renderTextT (runLucidTemplate template)) (context', item)
  return $ itemSetBody body item
  where context' = context `mappend` missingField

lookupMeta :: String -> LucidTemplateMonad a ContextField
lookupMeta k = do
  (c, i) <- lift ask
  lift $ lift $ applyTemplateExpr c i (Ident (TemplateKey k))

lookupMetaWithArgs :: String -> [String] -> LucidTemplateMonad a ContextField
lookupMetaWithArgs k a = do
  (c, i) <- lift ask
  lift $ lift $ applyTemplateExpr c i (Call (TemplateKey k) (map StringLiteral a))

applyTemplateExpr :: Context a -> Item a -> TemplateExpr -> Compiler ContextField
applyTemplateExpr _ _ (StringLiteral s)         = return (StringField s)
applyTemplateExpr c i (Ident (TemplateKey k))   = unContext c k [] i
applyTemplateExpr c i (Call  (TemplateKey k) a) = do
  a' <- mapM (\e -> applyTemplateExpr c i e >>= getString e) a
  unContext c k a' i
  where getString _ (StringField s) = return s
        getString e (ListField _ _) =
          fail $ "expected StringField but got ListField for expr " ++ show e
