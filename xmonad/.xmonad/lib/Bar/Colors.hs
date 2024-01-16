module Bar.Colors where

import           Numeric                        ( readHex
                                                , showHex
                                                )

data Triple a = Triple (a, a, a)

instance Functor Triple where
    fmap f (Triple (x, y, z)) = Triple (f x, f y, f z)

instance Applicative Triple where
    pure x = Triple (x, x, x)
    (Triple (f1, f2, f3)) <*> (Triple (x1, x2, x3)) =
        (Triple (f1 x1, f2 x2, f3 x3))

type Color = Triple Int

string2col :: String -> Color
string2col s = Triple (r, g, b)
  where
    s'       = drop 1 s
    readHex' = fst . head . readHex
    r        = readHex' . take 2 $ s'
    g        = readHex' . take 2 . drop 2 $ s'
    b        = readHex' . take 2 . drop 4 $ s'

col2string :: Color -> String
col2string (Triple (r, g, b)) = "#" ++ showHex' r ++ showHex' g ++ showHex' b
  where
    showHex' n =
        let result = showHex n ""
        in  if length result == 1 then "0" ++ result else result

darken :: Color -> Color
darken = shift (-50)

brighten :: Color -> Color
brighten = shift 50

shift :: Int -> Color -> Color
shift amt = fmap colshift
  where
    colshift x | x + amt > 255 = 255
               | x + amt < 0   = 0
               | otherwise     = x + amt

gradientStr :: Color -> Color -> String
gradientStr c1 c2 =
    " " ++ bg left ++ " " ++ bg mid ++ " " ++ bg right ++ " " ++ bg c2 ++ " "
  where
    mid   = avgColor c1 c2
    left  = avgColor c1 mid
    right = avgColor c2 mid

avgColor :: Color -> Color -> Color
avgColor c1 c2 = fmap (`div` 2) $ (+) <$> c1 <*> c2

dkstGrey, dkerGrey, ltstGrey, lterGrey :: Color
dkstGrey = string2col "#121212"

dkerGrey = string2col "#303030"

ltstGrey = string2col "#d0d0d0"

lterGrey = string2col "#585858"

textGrey = string2col "#9e9e9e"

fdBlue, fdGrey, brBlue, brGrey :: Color
fdBlue = string2col "#00627f"

fdGrey = string2col "#8ea5ab"

brBlue = string2col "#0097af"

brGrey = string2col "#d2eaf0"

orange :: Color
orange = string2col "#7d5b39"

fg, bg :: Color -> String
bg x = "^bg(" ++ col2string x ++ ")"

fg x = "^fg(" ++ col2string x ++ ")"

fgbg :: Color -> Color -> String
fgbg f b = fg f ++ bg b
