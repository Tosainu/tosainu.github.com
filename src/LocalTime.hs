module LocalTime where

import qualified Data.Time.Format    as Time
import qualified Data.Time.LocalTime as Time
import           Hakyll

defaultTimeZone :: Time.TimeZone
defaultTimeZone = Time.TimeZone (9 * 60) False "JST"

defaultTimeLocale :: Time.TimeLocale
defaultTimeLocale = Time.defaultTimeLocale
  { Time.knownTimeZones =
      Time.knownTimeZones Time.defaultTimeLocale ++ [defaultTimeZone] }

getItemLocalTime :: MonadMetadata m => Identifier -> m Time.LocalTime
getItemLocalTime = fmap (Time.utcToLocalTime defaultTimeZone) . getItemUTC defaultTimeLocale
