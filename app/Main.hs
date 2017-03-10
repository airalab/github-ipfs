module Main where

import qualified Data.Text          as T
import           Data.Text.Encoding (encodeUtf8)
import           Register
import           Server
import           System.Environment (getEnv)

main :: IO ()
main = do
    path <- T.pack <$> getEnv "REGISTRY_PATH"
    key  <- T.pack <$> getEnv "REGISTRY_KEY"
    port <- read <$> getEnv "PORT"
    serve (repoRegister path) (encodeUtf8 key) port
