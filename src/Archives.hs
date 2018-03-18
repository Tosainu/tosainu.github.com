module Archives where

import           Control.Monad
import qualified Data.Map         as M
import qualified Data.Set         as S
import qualified Data.Time.Format as Time
import           Hakyll

import           LocalTime

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
