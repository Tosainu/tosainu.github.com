{-# LANGUAGE OverloadedStrings #-}

module Archives where

import           Control.Monad
import           Control.Monad.Trans.Class (lift)
import           Data.Function             (on)
import           Data.List                 (groupBy, sortBy)
import qualified Data.Map                  as M
import           Data.Maybe
import qualified Data.Set                  as S
import qualified Data.Text                 as T
import qualified Data.Text.Lazy            as TL
import qualified Data.Time.Format          as Time
import           Hakyll
import           Lucid.Base
import           Lucid.Html5

import           LocalTime
import           Templates.FontAwesome

data Archives k = Archives
                { archivesMap        :: [(k, [Identifier])]
                , archivesMakeId     :: k -> Identifier
                , archivesDependency :: Dependency
                }

data YearMonthKey = Yearly (String) | Monthly (String, String)
       deriving (Eq, Show)

instance Ord YearMonthKey where
  (Yearly  (ya))     <= (Yearly  (yb))     = ya <= yb
  (Yearly  (ya))     <= (Monthly (yb,  _)) = ya <  yb
  (Monthly (ya,  _)) <= (Yearly  (yb))     = ya <= yb
  (Monthly (ya, ma)) <= (Monthly (yb, mb)) = if ya == yb then ma <= mb else ya <= yb

buildArchivesWith :: (MonadMetadata m, Ord k)
                  => (Identifier -> m [k])
                  -> Pattern
                  -> (k -> Identifier)
                  -> m (Archives k)
buildArchivesWith f pattern makeId = do
  ids <- getMatches pattern
  am  <- M.toList <$> foldM addToMap M.empty ids
  return $ Archives am makeId $ PatternDependency pattern (S.fromList ids)
  where addToMap m i = do
          ks <- f i
          let m' = M.fromList $ zip ks $ repeat [i]
          return $ M.unionWith (++) m m'

archivesRules :: Archives a -> (a -> Pattern -> Rules ()) -> Rules ()
archivesRules archives rules =
  forM_ (archivesMap archives) $ \(key, identifiers) ->
    rulesExtraDependencies [archivesDependency archives] $
      create [archivesMakeId archives key] $
        rules key $ fromList identifiers

buildYearlyArchives :: MonadMetadata m => Pattern -> (String -> Identifier) -> m (Archives String)
buildYearlyArchives = buildArchivesWith (fmap (replicate 1) . getYear)

buildMonthlyArchives :: MonadMetadata m => Pattern -> (String -> Identifier) -> m (Archives String)
buildMonthlyArchives = buildArchivesWith (fmap (replicate 1) . getMonth)

buildYearMonthArchives :: MonadMetadata m
                       => Pattern
                       -> (YearMonthKey -> Identifier)
                       -> m (Archives YearMonthKey)
buildYearMonthArchives = buildArchivesWith f
  where f i = do
          y <- getYear i
          m <- getMonth i
          return [Yearly (y), Monthly (y, m)]

getYear :: MonadMetadata m => Identifier -> m String
getYear identifier = Time.formatTime defaultTimeLocale "%Y" <$> getItemLocalTime identifier

getMonth :: MonadMetadata m => Identifier -> m String
getMonth identifier = Time.formatTime defaultTimeLocale "%m" <$> getItemLocalTime identifier

yearMonthArchiveField :: String -> Archives YearMonthKey -> FontAwesomeIcons -> Context a
yearMonthArchiveField key archives icons = field key $ \_ -> fmap TL.unpack $ renderTextT $
  ul_ [class_ "archive-tree"] $ do
    let archives' = groupBy (isSameYear `on` fst) $
                    sortBy  (flip compare `on` fst) $ archivesMap archives
    forM_ archives' $ \yas -> do
      li_ $ do
        let (yk@(Yearly y), yids) = head yas
        yurl <- lift $ fmap toUrl' $ getRoute $ archivesMakeId archives yk

        input_ [ class_ "tree-toggle"
               , type_ "checkbox"
               , id_ (T.pack $ "tree-label-" ++ y) ]
        label_ [ class_ "tree-toggle-button"
               , for_ (T.pack $ "tree-label-" ++ y) ] $ do
          with (fontawesome' icons "fas" "angle-right") [class_ " fa-fw"]
          with (fontawesome' icons "fas" "angle-down")  [class_ " fa-fw"]
          a_ [href_ (T.pack yurl)] $
            toHtml $ y ++ " (" ++ show (length yids) ++ ")"

        ul_ [class_ "tree-child"] $
          forM_ (tail yas) $ \ma -> do
            let (mk@(Monthly (_, m)), mids) = ma
            murl <- lift $ fmap toUrl' $ getRoute $ archivesMakeId archives mk

            li_ $
              a_ [href_ (T.pack murl)] $
                toHtml $ y ++ "/" ++ m ++  " (" ++ show (length mids) ++ ")"

  where isSameYear a b = getYear' a == getYear' b
        getYear' (Yearly y)       = y
        getYear' (Monthly (y, _)) = y

        toUrl' = toUrl . fromMaybe "/"
