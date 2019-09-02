module Template.Core where

import           Control.Monad.Except (MonadError (..))
import           Control.Monad.Reader
import qualified Data.Text.Lazy       as TL
import           Hakyll
import           Lucid.Base

type LucidTemplateMonad a r = HtmlT (ReaderT (Context a, Item a) Compiler) r

newtype LucidTemplate a = LucidTemplate { runLucidTemplate :: LucidTemplateMonad a () }

applyLucidTemplate :: LucidTemplate a -> Context a -> Item a -> Compiler (Item String)
applyLucidTemplate tpl ctx item = do
  body <- TL.unpack <$> runReaderT (renderTextT (runLucidTemplate tpl)) (ctx', item)
  return $ itemSetBody body item
  where ctx' = ctx `mappend` missingField

lookupField :: String -> LucidTemplateMonad a ContextField
lookupField = flip lookupFieldWith []

lookupFieldWith :: String -> [String] -> LucidTemplateMonad a ContextField
lookupFieldWith k a = lift $ ask >>= lift . unContext'
  where unContext' (c, i) = unContext c k a i

lookupFieldMaybe :: String -> LucidTemplateMonad a (Maybe ContextField)
lookupFieldMaybe k = (Just <$> lookupField k) `catchError` const (return Nothing)

lookupFieldMaybeWith :: String -> [String] -> LucidTemplateMonad a (Maybe ContextField)
lookupFieldMaybeWith k a = (Just <$> lookupFieldWith k a) `catchError` const (return Nothing)

withContext :: Monad m => a' -> HtmlT (ReaderT a' m) r -> HtmlT (ReaderT a m) r
withContext c = HtmlT . withReaderT (const c) . runHtmlT
