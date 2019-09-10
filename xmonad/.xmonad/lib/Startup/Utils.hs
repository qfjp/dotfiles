module Startup.Utils where
import System.IO ( Handle, hGetContents )
import System.Process
  ( StdStream(CreatePipe)
  , createProcess
  , cwd, proc
  , std_err
  , std_out )
import Data.List (isInfixOf)
import Data.List.Split (splitOn)

execute :: FilePath -> [String] -> IO String
execute exe arg =  getProcHandle exe arg >>= \x -> hGetContents x

getProcHandle :: FilePath -> [String] -> IO Handle
getProcHandle exe arg =  do (_, Just hout, _, _) <-
                              createProcess (proc exe arg)
                                { cwd = Just "."
                                , std_out = CreatePipe
                                , std_err = CreatePipe
                                }
                            return hout

getDpi :: IO String
getDpi = do xdpyOut <- execute "xdpyinfo" []
            let xdpyLines =  lines xdpyOut
                dpiLine = (head . filter ("dot" `isInfixOf`)) xdpyLines
                dpis = words dpiLine !! 1
            return dpis

yDpi :: IO Int
yDpi = do
        dpis <- getDpi
        let splt = splitOn "x" dpis
            yStr = (head . tail) splt
            yInt = read yStr :: Int
        return yInt

ioHeight :: IO Int
ioHeight = do
        ydpi <- yDpi
        return $ floor $ (0.1875 :: Double) * fromIntegral ydpi

getResolution :: IO (Int, Int)
getResolution = do xrandrOut <- execute "xrandr" []
                   let xrandrLines = lines xrandrOut
                       resolutions = filter ('*' `elem`) xrandrLines
                       primary = (head . words . head) resolutions
                       xres = (head . splitOn "x") primary
                       yres = (last . splitOn "x") primary
                   return (read xres, read yres)
