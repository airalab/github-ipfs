{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeFamilies  #-}
{-# LANGUAGE TypeOperators #-}
-- |
-- Module      :  Server
-- Copyright   :  Alexander Krupenkin 2017
-- License     :  BSD3
--
-- Maintainer  :  mail@akru.me
-- Stability   :  experimental
-- Portability :  portable
--
-- Simple GitHub webhook server.
--
module Server (serve) where

import           Control.Monad.IO.Class   (liftIO)
import           Data.Aeson               (Object)
import           Data.ByteString          (ByteString)
import           Network.Wai.Handler.Warp (Port, run)
import           Servant                  hiding (serve)
import           Servant.GitHub.Webhook

type API
  =  GitHubEvent '[ 'WebhookPushEvent ]
  :> GitHubSignedReqBody '[JSON] Object
  :> Post '[JSON] ()

handler :: (Object -> IO ()) -> RepoWebhookEvent -> ((), Object) -> Handler ()
handler f _ = liftIO . f . snd

serve :: (Object -> IO ())
      -> ByteString
      -> Port
      -> IO ()
serve f key port =
    run port $
        serveWithContext
            (Proxy :: Proxy API)
            (gitHubKey (pure key) :. EmptyContext)
            (handler f :: Server API)
