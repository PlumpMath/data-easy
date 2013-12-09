{-# LANGUAGE NoMonomorphismRestriction #-}

module Control.Monad.Trans.Convert
  ( -- ** to MaybeT
    mMaybeToMaybeT
  , mMToMT
  , ioMaybeToMaybeT
  , ioMToMT

  , mEitherToMaybeT
  , mEToMT
  , ioEitherToMaybeT
  , ioEToMT

  , mPairToMaybeT
  , mPairToMaybeT'
  , mPairFstToMaybeT
  , mPairSndToMaybeT

  , mMonoidToMaybeT
  , mOToMT

  , mBoolToMaybeT
  , mBToMT

  -- ** toEitherT
  , mMaybeToEitherT
  , mMToET
  , ioMaybeToEitherT
  , ioMToET

  , mEitherToEitherT
  , mEToET
  , ioEitherToEitherT
  , ioEToET

  , mPairToEitherT
  , mPairToEitherT'
  , mPairBothToEitherT

  , mMonoidToEitherT
  , mOToET

  , mBoolToEitherT
  , mBToET


  ) where

import Data.UniformUtils
import Data.Monoid

import Control.Applicative

import Control.Monad.Trans.Class
import Control.Monad.Trans.Maybe
import Control.Monad.Trans.Either


------------------------------------------------------------------------------
-- Maybe ---------------------------------------------------------------------
------------------------------------------------------------------------------

-- | Lift a 'Maybe' to the 'MaybeT' monad
-- Shamelessly copied from "Control.Error.Util"
hoistMaybe :: (Monad m) => Maybe b -> MaybeT m b
hoistMaybe = MaybeT . return

-- | Transform a maybe value encapsulated in a @Monad m@ into the equivalent
-- MaybeT m monad transformer.
--
-- /NOTE/: this is not equivalent to either @lift@ or @hoistMaybe@ alone.
-- Check the types carefully.
mMaybeToMaybeT :: (Monad m) => m (Maybe a) -> MaybeT m a
mMaybeToMaybeT mF = lift mF >>= hoistMaybe

-- | Shorter alias for mMaybeToMaybeT
mMToMT :: (Monad m) => m (Maybe a) -> MaybeT m a
mMToMT = mMaybeToMaybeT

-- | Transform a IO (Maybe a) value into a MaybeT IO a value
ioMaybeToMaybeT :: IO (Maybe a) -> MaybeT IO a
ioMaybeToMaybeT = mMaybeToMaybeT

-- | Shorter alias for ioMaybeToMaybeT
ioMToMT :: IO (Maybe a) -> MaybeT IO a
ioMToMT = ioMaybeToMaybeT

-- | Transform a either value encapsulated in a @Monad m@ into the equivalent
-- MaybeT m monad transformer.
--
-- /Note/: The left value is silently discarded.
mEitherToMaybeT :: (Functor m, Monad m) => m (Either a b) -> MaybeT m b
mEitherToMaybeT eF = eitherToMaybe <$> lift eF >>= hoistMaybe

-- | Shorter alias for 'mEitherToMaybeT'.
mEToMT :: (Functor m, Monad m) => m (Either a b) -> MaybeT m b
mEToMT = mEitherToMaybeT

-- | Transform a either value encapsulated in a IO monad into the equivalent
-- MaybeT IO monad transformer.
--
-- /Note/: The left value is silently discarded.
ioEitherToMaybeT :: IO (Either a b) -> MaybeT IO b
ioEitherToMaybeT = mEitherToMaybeT

-- | Shorter alias for 'mEitherToMaybeT'.
ioEToMT :: IO (Either a b) -> MaybeT IO b
ioEToMT = mEitherToMaybeT

-- | Case analysis of a pair of monoid values returned by a monad into
-- a MaybeT value.
-- The value conversion is done by @'pairToMaybe'@.
mPairToMaybeT :: (Eq a, Monoid a, Functor m, Monad m) => m (a,a) -> MaybeT m a
mPairToMaybeT pF = pairToMaybe <$> lift pF >>= hoistMaybe

-- | Case analysis of a pair of monoid values returned by a monad into
-- a MaybeT value.
-- The value conversion is done by @'pairToMaybe''@.
mPairToMaybeT' :: (Eq a, Monoid a, Functor m, Monad m) => m (a,a) -> MaybeT m a
mPairToMaybeT' pF = pairToMaybe' <$> lift pF >>= hoistMaybe

-- | Case analysis of a pair of monoid values returned by a monad into
-- a MaybeT value.
-- The value conversion is done by @'pairFstToMaybe'@.
mPairFstToMaybeT :: (Eq a, Monoid a, Functor m, Monad m) => m (a,b) -> MaybeT m a
mPairFstToMaybeT pF = pairFstToMaybe <$> lift pF >>= hoistMaybe

-- | Case analysis of a pair of monoid values returned by a monad into
-- a MaybeT value.
-- The value conversion is done by @'pairSndToMaybe'@.
mPairSndToMaybeT :: (Eq b, Monoid b, Functor m, Monad m) => m (a,b) -> MaybeT m b
mPairSndToMaybeT pF = pairSndToMaybe <$> lift pF >>= hoistMaybe

-- | Transform a monoid value encapsulated in a @Monad m@ into the equivalent
-- MaybeT m monad transformer (@'mempty'@ -> @'Nothing'@).
mMonoidToMaybeT :: (Eq o, Monoid o, Functor m, Monad m) => m o -> MaybeT m o
mMonoidToMaybeT oF = monoidToMaybe <$> lift oF >>= hoistMaybe

-- | Shorter alias for 'mMonoidToMaybeT'
mOToMT :: (Eq o, Monoid o, Functor m, Monad m) => m o -> MaybeT m o
mOToMT = mMonoidToMaybeT

-- | Transform a boolean value encapsulated in a @Monad m@ into the equivalent
-- MaybeT m monad transformer (@'True'@ -> @Provided Default Value@).
mBoolToMaybeT :: (Functor m, Monad m) => a -> m Bool -> MaybeT m a
mBoolToMaybeT def bF = boolToMaybe def <$> lift bF >>= hoistMaybe

-- | Shorter alias for @'mBoolToMaybeT'@.
mBToMT :: (Functor m, Monad m) => a -> m Bool -> MaybeT m a
mBToMT = mBoolToMaybeT

------------------------------------------------------------------------------
-- Either --------------------------------------------------------------------
------------------------------------------------------------------------------
{-ioMaybeToEitherT :: b -> IO (Maybe a) -> EitherT b IO a-}
{-ioMaybeToEitherT err ioF = maybeToEither err <$> liftIO ioF >>= hoistEither-}

-- | Transform a maybe value encapsulated in a @Monad m@ into the equivalent
-- EitherT b m monad transformer.
--
-- /NOTE/: this is not equivalent to either @lift@ or @hoistEither@ alone.
-- Check the types carefully.
mMaybeToEitherT :: (Monad m) => b -> m (Maybe a) -> EitherT b m a
mMaybeToEitherT err mF = maybeToEither err <$> lift mF >>= hoistEither

-- | Shorter alias for mMaybeToEitherT
mMToET :: (Monad m) => b -> m (Maybe a) -> EitherT b m a
mMToET = mMaybeToEitherT

-- | Transform a IO (Maybe a) value into a EitherT b IO a value
ioMaybeToEitherT :: b -> IO (Maybe a) -> EitherT b IO a
ioMaybeToEitherT = mMaybeToEitherT

-- | Shorter alias for ioMaybeToEitherT
ioMToET :: b -> IO (Maybe a) -> EitherT b IO a
ioMToET = ioMaybeToEitherT

-- | Transform a either value encapsulated in a @Monad m@ into the equivalent
-- EitherT e m monad transformer.
mEitherToEitherT :: Monad m => m (Either b a) -> EitherT b m a
mEitherToEitherT eF = lift eF >>= hoistEither

-- | Shorter alias for 'mEitherToEitherT'.
mEToET :: Monad m => m (Either b a) -> EitherT b m a
mEToET = mEitherToEitherT

-- | Transform a either value encapsulated in a IO monad into the equivalent
-- EitherT b IO monad transformer.
ioEitherToEitherT :: IO (Either b a) -> EitherT b IO a
ioEitherToEitherT = mEitherToEitherT

-- | Shorter alias for 'mEitherToEitherT'.
ioEToET :: IO (Either b a) -> EitherT b IO a
ioEToET = mEitherToEitherT

-- | Case analysis of a pair of monoid values returned by a monad into
-- a EitherT value.
-- The value conversion is done by @'pairToEither'@.
mPairToEitherT
  :: (Eq a, Monoid a, Functor m, Monad m)
  => m (b,a)
  -> EitherT b m a
mPairToEitherT pF = pairToEither <$> lift pF >>= hoistEither

-- | Case analysis of a pair of monoid values returned by a monad into
-- a EitherT value.
-- The value conversion is done by @'pairToEither''@.
mPairToEitherT'
  :: (Eq b, Monoid b, Functor m, Monad m)
  => m (b,a)
  -> EitherT a m b
mPairToEitherT' pF = pairToEither' <$> lift pF >>= hoistEither

-- | Case analysis of a pair of monoid values returned by a monad into
-- a EitherT value.
-- The value conversion is done by @'pairBothToEither'@.
mPairBothToEitherT
  :: (Eq a, Monoid a, Functor m, Monad m)
  => b
  -> m (a,a)
  -> EitherT b m a
mPairBothToEitherT def pF = pairBothToEither def <$> lift pF >>= hoistEither

-- | Transform a monoid value encapsulated in a @Monad m@ into the equivalent
-- EitherT e m monad transformer (@'mempty'@ -> @'Nothing'@).
mMonoidToEitherT :: (Eq a, Monoid a, Functor m, Monad m)
  => b
  -> m a
  -> EitherT b m a
mMonoidToEitherT def oF = monoidToEither def <$> lift oF >>= hoistEither

-- | Shorter alias for 'mMonoidToEitherT'
mOToET :: (Eq a, Monoid a, Functor m, Monad m)
  => b
  -> m a
  -> EitherT b m a
mOToET = mMonoidToEitherT

-- | Transform a boolean value encapsulated in a @Monad m@ into the equivalent
-- Either m monad transformer. Uses @'boolToEither'@.
mBoolToEitherT
  :: (Functor m, Monad m)
  => b
  -> a
  -> m Bool
  -> EitherT b m a
mBoolToEitherT l r bF = boolToEither l r <$> lift bF >>= hoistEither

-- | Shorter alias for @'mBoolToEitherT'@.
mBToET
  :: (Functor m, Monad m)
  => b
  -> a
  -> m Bool
  -> EitherT b m a
mBToET = mBoolToEitherT

