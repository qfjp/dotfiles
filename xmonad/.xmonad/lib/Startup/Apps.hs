module Startup.Apps where

import           Startup.Utils
import           System.Environment (getEnv)
import           XMonad

spawnedApps :: [String]
spawnedApps = ["dzen2", "stalonetray", "compton", "flashfocus"]

killSpawns :: X ()
killSpawns = mapM_ (\x -> spawn ("killall " ++ x)) spawnedApps

ioIconHeight :: IO Int
ioIconHeight = do
    ydpi <- yDpi
    return $ floor $ (0.1667 :: Double) * fromIntegral ydpi

barWidth :: IO Int
barWidth = do
    (res, _) <- getResolution
    return $ res - 10

barOffset :: IO Int
barOffset = do
    (res, _) <- getResolution
    return $ res `div` 2

comptonCmd :: IO String
comptonCmd = do
    (xres, _) <- getResolution
    home <- getEnv "HOME"
    intHeight <- ioHeight
    let height = show intHeight
        compReg = xres - 10
    return $ "compton -CGf"

flashfocusCmd :: IO String
flashfocusCmd = return "flashfocus"
