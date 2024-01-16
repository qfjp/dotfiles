module Utils where

import           Data.List                      ( findIndex
                                                , intersect
                                                , isInfixOf
                                                , nub
                                                )
import           Data.List.Split                ( splitOn
                                                , splitOneOf
                                                )
import           Data.Maybe                     ( fromMaybe )
import           System.IO                      ( Handle
                                                , hGetContents
                                                )
import           System.Process                 ( StdStream(CreatePipe)
                                                , createProcess
                                                , cwd
                                                , proc
                                                , std_err
                                                , std_out
                                                )

displayForBar :: String
displayForBar = "HDMI-0"

list2Tup :: [a] -> (a, a)
list2Tup (x : y : _) = (x, y)
list2Tup _           = undefined

convertTup :: (Read a, Read b) => (String, String) -> (a, b)
convertTup (x, y) = (read x, read y)

execute :: FilePath -> [String] -> IO String
execute exe arg = getProcHandle exe arg >>= hGetContents

getProcHandle :: FilePath -> [String] -> IO Handle
getProcHandle exe arg = do
    (_, Just hout, _, _) <- createProcess (proc exe arg) { cwd     = Just "."
                                                         , std_out = CreatePipe
                                                         , std_err = CreatePipe
                                                         }
    return hout

getDpi :: IO String
getDpi = do
    xdpyOut <- execute "xdpyinfo" []
    let xdpyLines = lines xdpyOut
        dpiLine   = (head . filter ("dot" `isInfixOf`)) xdpyLines
        dpis      = words dpiLine !! 1
    return dpis

yDpi :: (Integral a, Read a) => IO a
yDpi = do
    dpis <- getDpi
    let splt = splitOn "x" dpis
        yStr = (head . tail) splt
        yInt = read yStr :: (Integral a, Read a) => a
    return yInt

ioLineHeight :: Integral a => IO a
ioLineHeight = do
    ydpi <- yDpi
    return $ floor $ (0.1875 :: Double) * fromIntegral ydpi

ioIconHeight :: Integral a => IO a
ioIconHeight = do
    ydpi <- yDpi
    return $ floor $ (0.1667 :: Double) * fromIntegral ydpi

xrandr :: IO String
xrandr = execute "xrandr" []

containsAllOf :: Eq a => [a] -> [a] -> Bool
containsAllOf x y =
    let x' = nub x
        y' = nub y
    in  length (x' `intersect` y') == (length . nub) y'

getGeo :: IO (String, String)
getGeo = getGeoFromDisplay "primary"

getGeoFromDisplay :: String -> IO (String, String)
getGeoFromDisplay disp = do
    xrandrLines <- lines <$> xrandr
    let primary      = (!! 0) $ filter (disp `isInfixOf`) xrandrLines
        primGeo      = (!! 0) . filter (`containsAllOf` "x+") . words $ primary
        primGeoSplit = splitOneOf "+x" primGeo
    return
        ( head primGeoSplit ++ "x" ++ (primGeoSplit !! 1)
        , (primGeoSplit !! 2) ++ "+" ++ (primGeoSplit !! 3)
        )

getResolution :: (Integral a, Read a) => IO (a, a)
getResolution =
    convertTup
        .   list2Tup
        .   splitOn "x"
        .   fst
        <$> getGeoFromDisplay displayForBar

getOffset :: (Integral a, Read a) => IO (a, a)
getOffset =
    convertTup
        .   list2Tup
        .   splitOn "+"
        .   snd
        <$> getGeoFromDisplay displayForBar
