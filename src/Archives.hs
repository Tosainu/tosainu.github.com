{-# LANGUAGE OverloadedStrings #-}

module Archives where

import           Control.Monad
import           Control.Monad.Except (MonadError (..))
import           Control.Monad.Trans  (lift)
import           Data.Function        (on)
import           Data.List            (groupBy, sortBy)
import qualified Data.Map             as M
import           Data.Maybe
import qualified Data.Set             as S
import qualified Data.Text            as T
import qualified Data.Text.Lazy       as TL
import qualified Data.Time.Format     as Time
import           Hakyll
import           Lucid.Base
import           Lucid.Html5

import           LocalTime

data Archives k = Archives
                { archivesMap        :: [(k, [Identifier])]
                , archivesMakeId     :: k -> Identifier
                , archivesDependency :: Dependency
                }

data YearMonthKey = Yearly String | Monthly String String
       deriving (Eq, Show)

instance Ord YearMonthKey where
  (Yearly  ya)    <= (Yearly  yb)     = ya <= yb
  (Yearly  ya)    <= (Monthly yb  _)  = ya <  yb
  (Monthly ya  _) <= (Yearly  yb)     = ya <= yb
  (Monthly ya ma) <= (Monthly yb mb)  = if ya == yb then ma <= mb else ya <= yb

year :: YearMonthKey -> String
year (Yearly  y)   = y
year (Monthly y _) = y

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

buildYearMonthArchives :: MonadMetadata m
                       => Pattern
                       -> (YearMonthKey -> Identifier)
                       -> m (Archives YearMonthKey)
buildYearMonthArchives = buildArchivesWith $ \i -> do
  t <- getItemLocalTime i
  let y = Time.formatTime defaultTimeLocale "%Y" t
      m = Time.formatTime defaultTimeLocale "%m" t
  return [Yearly y, Monthly y m]

yearMonthArchiveField :: String -> Archives YearMonthKey -> Context a
yearMonthArchiveField key archives = field key $ getPageYear >=> buildYearMonthArchiveField archives
  where
    getPageYear item = (Time.formatTime defaultTimeLocale "%Y" <$>
                         getItemLocalTime (itemIdentifier item)) `catchError` const (return "")

yearMonthArchiveField' :: String -> Archives YearMonthKey -> String -> Context a
yearMonthArchiveField' key archives pageYear =
  field key $ const $ buildYearMonthArchiveField archives pageYear

buildYearMonthArchiveField :: Archives YearMonthKey -> String -> Compiler String
buildYearMonthArchiveField archives pageYear = fmap TL.unpack $ renderTextT $
  ul_ [class_ "archive-tree"] $ do
    let getUrl    = lift . fmap (toUrl . fromMaybe "#") . getRoute
        archives' = groupBy (isSameYear `on` fst) $
                    sortBy  (flip compare `on` fst) $ archivesMap archives
        isSameYear a b = year a == year b

    forM_ archives' $ \yas ->
      li_ $ do
        let (yk@(Yearly y), yids) = head yas
        yurl <- getUrl $ archivesMakeId archives yk

        input_ $ [ class_ "tree-toggle"
                 , type_ "checkbox"
                 , id_ (T.pack $ "tree-label-" ++ y) ] ++
                 [ checked_ | y == pageYear ]
        label_ [ class_ "tree-toggle-button"
               , for_ (T.pack $ "tree-label-" ++ y) ] $ do
          i_ [classes_ ["fas", "fa-angle-right", "fa-fw"]] ""
          i_ [classes_ ["fas", "fa-angle-down", "fa-fw"]] ""
          a_ [href_ (T.pack yurl)] $
            toHtml $ y ++ " (" ++ show (length yids) ++ ")"

        ul_ [class_ "tree-child"] $
          forM_ (tail yas) $ \ma -> do
            let (mk@(Monthly _ m), mids) = ma
            murl <- getUrl $ archivesMakeId archives mk

            li_ $
              a_ [href_ (T.pack murl)] $
                toHtml $ y ++ "/" ++ m ++  " (" ++ show (length mids) ++ ")"
