module Startup.Apps where

import           System.Environment             ( getEnv )
import           Utils                          ( getResolution
                                                , ioLineHeight
                                                )
import           XMonad                         ( X
                                                , spawn
                                                )

spawnedApps :: [String]
spawnedApps = ["dzen2", "stalonetray", "picom", "flashfocus"]

killSpawns :: X ()
killSpawns = mapM_ (\x -> spawn ("killall " ++ x)) spawnedApps

barOffset :: IO Int
barOffset = do
  (res, _) <- getResolution
  return $ res `div` 2

comptonCmd :: IO String
comptonCmd = do
  (xres, _) <- getResolution
  home      <- getEnv "HOME"
  intHeight <- ioLineHeight
  let height  = show intHeight
      compReg = xres - 10
  return $ "picom -f --corner-radius 8"

flashfocusCmd :: IO String
flashfocusCmd = return "flashfocus"
