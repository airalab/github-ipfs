{-# LANGUAGE OverloadedStrings #-}
module Register where

import           Data.Aeson
import           Data.Aeson.Types (parseMaybe)
import           Data.Text        (Text)
import qualified Data.Text        as T
import           Shelly

ipfsPublish :: Text -> Sh ()
ipfsPublish = command_ "ipfs" ["name", "publish"]
            . pure

ipfsAddDir :: Text -> Sh Text
ipfsAddDir = fmap (last . T.lines)
           . command "ipfs" ["add", "-rq"]
           . pure

ipfsAddRepo :: Text -> Sh Text
ipfsAddRepo repoUrl =
    withTmpDir $ \tmp -> do
        repoPath <- toTextWarn tmp
        run_ "git" ["clone", repoUrl, repoPath]
        ipfsAddDir repoPath

repoRegister :: Text -> Object -> IO ()
repoRegister path = maybe (return ()) go . parseMeta
  where parseMeta = parseMaybe $ \meta -> do
            ref <- meta .: "ref"
            let branch = T.takeWhileEnd (/= '/') ref
            repository <- meta .: "repository"
            name <- repository .: "full_name"
            url  <- repository .: "html_url"
            return ((name :: Text), branch, url)

        go (name, branch, url) = shelly $ do
            hash <- ipfsAddRepo url
            mkdir_p (path </> name)
            writefile (path </> name </> branch) hash
            regHash <- ipfsAddDir path
            ipfsPublish regHash
