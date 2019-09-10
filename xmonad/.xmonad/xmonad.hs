-- Use /usr/share/xmonad-2.9/ghc-6.12.3/man/xmonad.hs as a reference
-- A good resource for dzen config: http://thinkingeek.com/2011/11/21/simple-guide-configure-xmonad-dzen2-conky/
-- http://lynnard.me/blog/2013/11/05/building-a-vim-like-xmonad-prompt-task-groups-topical-workspaces-float-styles-and-more/
import qualified Data.Map                       as M
import           Data.Maybe
import           Data.Ratio                     ((%))
import           Data.Word

import           XMonad                         hiding (Color)

import           XMonad.Actions.FloatKeys       (keysResizeWindow)
import           XMonad.Actions.RotSlaves       (rotAllDown, rotAllUp)
import           XMonad.Hooks.Place

import           XMonad.Hooks.DynamicLog
    ( dynamicLogWithPP
    , dzenPP
    , ppCurrent
    , ppExtras
    , ppHidden
    , ppHiddenNoWindows
    , ppLayout
    , ppOutput
    , ppTitle
    , ppVisible
    , shorten
    , wrap
    )
import           XMonad.Hooks.EwmhDesktops      (ewmh)
import           XMonad.Hooks.ManageDocks
    (ToggleStruts(ToggleStruts), avoidStruts, docksEventHook, manageDocks)
import           XMonad.Hooks.ManageHelpers     (doFullFloat, isFullscreen)
import           XMonad.Hooks.SetWMName         (setWMName)

import           XMonad.Layout.NoBorders        (noBorders, smartBorders)
import           XMonad.Layout.Reflect          (reflectHoriz, reflectVert)
import           XMonad.Layout.Spacing          (spacing)
import           XMonad.Layout.Spiral           (spiral)
import           XMonad.Layout.ToggleLayouts

import qualified XMonad.StackSet                as W

import           XMonad.Util.Font
    (Align(AlignCenter, AlignLeft, AlignRight))
import           XMonad.Util.Loggers
import           XMonad.Util.Run                (spawnPipe)

import           System.Exit                    (exitSuccess)
import           System.IO                      (Handle, hPutStrLn)

import           XMonad.Actions.Navigation2D
import           XMonad.Layout.WindowNavigation

import           XMonad.Hooks.FadeInactive

import           Data.Monoid
import qualified XMonad.Util.ExtensibleState    as XS
import           XMonad.Util.Timer

import           Numeric                        (readHex, showHex)

import           ShapedWindow
import           Startup.Apps
import           Startup.Utils

desktopHost, laptopHost :: String
desktopHost = "franky"

laptopHost = "krang"

maxTitleLen :: Int
maxTitleLen = 100

-- wrapper for the Timer id, so it can be stored as custom mutable state
data TidState =
    TID TimerId
    deriving (Typeable)

instance ExtensionClass TidState where
    initialValue = TID 0

-- start the initial timer, store its id
clockStartupHook = startTimer 1 >>= XS.put . TID

clockEventHook e = do
    (TID t) <- XS.get -- get the recent Timer id
    handleTimer t e $ -- run the following if e matches the id
     do
        tid <- startTimer 1
        XS.put . TID $ tid -- restart the timer, store the new id
        state <- ask
        logHook . config $ state -- get the loghook and run it
        return Nothing
    return $ All True

winTitleFudgeFactor :: IO Int
winTitleFudgeFactor = return 190

staloneFudgeFactor :: IO Double
staloneFudgeFactor = return 0.88

substring :: String -> String -> Bool
substring (x:xs) [] = False
substring xs ys
    | prefix xs ys = True
    | substring xs (tail ys) = True
    | otherwise = False

prefix :: String -> String -> Bool
prefix [] ys = True
prefix (x:xs) [] = False
prefix (x:xs) (y:ys) = (x == y) && prefix xs ys

main :: IO ()
main = do
    leftBarString <- myWorkspaceBar
    dzenLeftBar <- spawnPipe leftBarString
    comptonString <- comptonCmd
    staloneString <- staloneCmd
    flashfocusString <- flashfocusCmd
    _ <- spawnPipe comptonString
    _ <- spawnPipe staloneString
    _ <- spawnPipe flashfocusString
    xmonad . ewmh . withNavigation2DConfig myNavigation2DConfig $
        def
            { focusFollowsMouse = False
            , workspaces = myWorkspaces
            , focusedBorderColor = "#ff950e"
            , normalBorderColor = "#ffffff"
            , terminal = "kitty"
            , borderWidth = 2
    -- key bindings
            , keys = myKeys
            , mouseBindings = myMouseBindings
    -- hooks, layouts
            , layoutHook = myLayout
            , logHook = myLogHook dzenLeftBar
            , manageHook = manageDocks <+> myManageHook
            , startupHook = myStartupHook
            , handleEventHook = docksEventHook <+> clockEventHook
      -- mod1Mask is left alt
      -- mod3Mask is right alt
      -- mod4Mask is win key
            , modMask = mod4Mask
            }

staloneCmd :: IO String
staloneCmd = do
    fudge <- staloneFudgeFactor
    (xres, _) <- getResolution
    iconHeight <- ioIconHeight
    let geoX = floor $ fromIntegral xres * fudge :: Int
        geoString = "1x1+" ++ show geoX ++ "+1"
    return $
        "stalonetray -i " ++
        show iconHeight ++
        " --kludges" ++
        " force_icons_size --geometry " ++
        geoString ++
        " -bg '" ++
        col2string lterGrey ++ "' " ++ "--grow-gravity 'E' --window-strut top"

myNavigation2DConfig :: Navigation2DConfig
myNavigation2DConfig =
    def
        { defaultTiledNavigation = centerNavigation
        , floatNavigation = centerNavigation
        }

-- Command to launch statusbar
myWorkspaceBar :: IO String
myWorkspaceBar = do
    intHeight <- ioHeight
    width <- barWidth
    let height = show intHeight
    return $
        "dzen2 -p -ta l -bg '" ++
        col2string ltstGrey ++
        "'" ++
        " -fn \"PragmataPro:Bold:size=10\"" ++
        " -h " ++
        height ++
        " -w " ++ show width ++ " -sa c -x 5 -y 0 -e 'onstart=lower' -dock"

myWorkspaces :: [String]
myWorkspaces =
    [ "1 fire"
    , "2 scien"
    , "3 delg"
    , "4 chrome"
    , "5 game"
    , "6 btc"
    , "7 sec"
    , "8 phone"
    , "9 blank"
    , "10 kpass"
    ]

toggleFloat :: X ()
toggleFloat =
    withFocused $ \w -> do
        floats <- gets (W.floating . windowset)
        if w `M.member` floats
            then withFocused (windows . W.sink)
            else keysResizeWindow (-20, -20) (1 % 2, 1 % 2) w

----------------------------------------------------------------------
-- Status bars and logging
data Triple a =
    Triple (a, a, a)

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
    s' = drop 1 s
    readHex' = fst . head . readHex
    r = readHex' . take 2 $ s'
    g = readHex' . take 2 . drop 2 $ s'
    b = readHex' . take 2 . drop 4 $ s'

col2string :: Color -> String
col2string (Triple (r, g, b)) = "#" ++ showHex' r ++ showHex' g ++ showHex' b
  where
    showHex' n =
        let result = showHex n ""
         in if length result == 1
                then "0" ++ result
                else result

darken :: Color -> Color
darken = shift (-50)

brighten :: Color -> Color
brighten = shift 50

shift :: Int -> Color -> Color
shift amt = fmap colshift
  where
    colshift x =
        if x + amt > 255
            then 255
            else if x + amt < 0
                     then 0
                     else x + amt

gradientStr :: Color -> Color -> String
gradientStr c1 c2 =
    " " ++ bg left ++ " " ++ bg mid ++ " " ++ bg right ++ " " ++ bg c2 ++ " "
  where
    mid = avgColor c1 c2
    left = avgColor c1 mid
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

rAlignCmpnt :: Int -> Logger -> Logger
rAlignCmpnt = fixedWidthL AlignRight " "

batteryCmd :: String
batteryCmd =
    "acpi 2>&1 | sed -r '" ++
    "s/No support (.*)//; " ++
    "s/.* Full, //; " ++
    "s/.*?: (.*%), ([0-9:]*).*/\\1/; " ++
    "s/[dD]ischarging, ([0-9]+%)/\\1-/; " ++
    "s/[cC]harging, ([0-9]+%)/\\1+/; " ++ "s/[cC]arged, //'"

batLog :: Logger
batLog = logCmd batteryCmd

length' :: String -> Int
length' [] = 0
length' (x:xs)
    | x == '—' = 2 + length' xs
    | otherwise = 1 + length' xs

-- ●◉○
myLogHook :: Handle -> X ()
myLogHook h = do
    fadeInactiveLogHook 1.00
    title <- fmap (fromMaybe "") logTitle
    layout <- fmap (fromMaybe "") logLayout
    battery <- fmap (fromMaybe "") batLog
    fudge <- io winTitleFudgeFactor
    let titleLen = length' . shorten maxTitleLen $ title
        layoutLen = length layout
        batLen = length battery
        buffer = replicate (fudge - titleLen - layoutLen - batLen) ' '
    dynamicLogWithPP $
        dzenPP
            { ppCurrent = const $ wrap (fgbg lterGrey ltstGrey ++ " ") "" "●"
            , ppVisible =
                  const $ wrap (fgbg (brighten lterGrey) ltstGrey ++ " ") "" "●"
            , ppHidden = const $ wrap (fgbg lterGrey ltstGrey ++ " ") "" "◉"
            , ppHiddenNoWindows =
                  const $ wrap (fgbg lterGrey ltstGrey ++ " ") "" "◌"
            , ppLayout =
                  wrap
                      (gradientStr ltstGrey lterGrey ++ fg textGrey)
                      (gradientStr lterGrey dkstGrey)
            , ppTitle = wrap (fg textGrey) "" . shorten maxTitleLen
            , ppOutput = hPutStrLn h
            , ppExtras =
                  [ return . Just $ buffer
                  , wrapL " " " " . return . Just $
                    gradientStr dkstGrey dkerGrey ++ fg textGrey
                  , logCmd batteryCmd
                  , wrapL " " " " . return . Just $
                    gradientStr dkerGrey lterGrey
                  , return . Just $ "         " -- tray
                  , wrapL " " " " . return . Just $
                    gradientStr lterGrey ltstGrey
                  , return . Just $ fgbg dkstGrey ltstGrey
                  , rAlignCmpnt 11 $ date "%a, %b %e"
                  , return . Just $ " | " ++ fg orange
                  , rAlignCmpnt 9 $ date "%l:%M %p "
                  ]
            }

----------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to
-- initialize per-workspace layout choices
--
myStartupHook :: X ()
myStartupHook = do
    clockStartupHook
    setWMName "LG3D"

myEventHook = clockEventHook

----------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@XConfig {XMonad.modMask = modm} =
    M.fromList $
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm, xK_apostrophe), spawn $ XMonad.terminal conf)
    , ((modm .|. shiftMask, xK_Return), spawn "GDK_SCALE=2 nvim-gtk")
    , ((modm .|. shiftMask, xK_apostrophe), spawn "GDK_SCALE=2 nvim-gtk")
    , ( (modm, xK_p)
      , spawn "/usr/bin/env rofi -combi-mode run,window -show combi")
    , ((modm, xK_i), spawn "/usr/bin/env rofi-pass")
    , ((modm .|. shiftMask, xK_i), spawn "/usr/bin/env rofi-pass --insert")
    , ((modm, xK_e), spawn "$HOME/bin/vim-anywhere")
    , ((modm .|. shiftMask, xK_c), kill)
    , ((modm, xK_space), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
    , ((modm, xK_f), sendMessage ToggleStruts >> sendMessage (Toggle "Full"))
    -- Resize viewed windows to the correct size
    , ((modm, xK_n), refresh)
    , ((modm, xK_o), windows W.focusDown)
    , ((modm .|. shiftMask, xK_o), windows W.swapMaster)
    , ((modm, xK_l), windowGo R False)
    , ((modm, xK_h), windowGo L False)
    , ((modm, xK_k), windowGo U False)
    , ((modm, xK_j), windowGo D False)
    , ((modm .|. shiftMask, xK_l), windowSwap R False)
    , ((modm .|. shiftMask, xK_h), windowSwap L False)
    , ((modm .|. shiftMask, xK_k), windowSwap U False)
    , ((modm .|. shiftMask, xK_j), windowSwap D False)
    -- -- Shrink the master area
    , ((modm .|. controlMask, xK_h), sendMessage Shrink)
    , ((modm .|. controlMask, xK_l), sendMessage Expand)
    , ((modm .|. controlMask, xK_k), sendMessage (IncMasterN 1))
    , ((modm .|. controlMask, xK_j), sendMessage (IncMasterN (-1)))
    , ((modm, xK_m), windows W.focusMaster)
    , ((modm, xK_t), toggleFloat)
    , ((modm, xK_comma), rotAllUp)
    , ((modm, xK_period), rotAllDown)
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    , ((modm, xK_b), sendMessage ToggleStruts)
    , ((modm .|. shiftMask, xK_q), io exitSuccess)
    , ((modm, xK_q), killSpawns >> spawn "xmonad --recompile; xmonad --restart")
    -- ##   MULTIMEDIA KEYS # --
    -- look these up at /usr/include/X11/XF86keysym.h
    -- Volume
    , ((0, 0x1008FF11), spawn "$HOME/bin/macros/vol-control 1.50dB-")
    , ((0, 0x1008FF12), spawn "$HOME/bin/macros/vol-control m")
    , ((0, 0x1008FF13), spawn "$HOME/bin/macros/vol-control 1.50dB+")
    -- Brightness
    , ( (0, 0x1008FF02)
      , spawn "$HOME/bin/bright $(expr $($HOME/bin/bright) + 100)")
    , ( (0, 0x1008FF03)
      , spawn "$HOME/bin/bright $(expr $($HOME/bin/bright) - 100)")
    -- Touchpad
    , ((0, 0x1008FFB0), spawn "$HOME/bin/macros/touchpad_notify.py on")
    , ((0, 0x1008FFB1), spawn "$HOME/bin/macros/touchpad_notify.py off")
    ] ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [ ((m .|. modm, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) $ [xK_1 .. xK_9] ++ [xK_0]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ] ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_a, xK_s, xK_d] [0 ..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    ]

--------------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings :: XConfig t -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings XConfig {XMonad.modMask = modm} =
    M.fromList
        [ ( (modm, button1)
          , \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
    -- mod-button2, Raise the window to the top of the stack
        , ((modm, button2), \w -> focus w >> windows W.shiftMaster)
        , ( (modm, button3)
          , \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
    -- mouse scroll wheel (button4 and button5)
        ]

--------------------------------------------------------------------------------
-- To Find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
myManageHook :: ManageHook
myManageHook = myWindowManage

myWindowManage :: ManageHook
myWindowManage =
    composeAll . concat $
    [ [resource =? r --> doIgnore | r <- myIgnores]
    , [className =? c --> placeHook' <+> doFloat | c <- myClassFloats]
    , [className =? c --> doShift (head myWorkspaces) | c <- myFirefox]
    , [className =? c --> doShift (myWorkspaces !! 2) | c <- myTorrents]
    , [className =? c --> doShift (myWorkspaces !! 3) | c <- myChrome]
    , [className =? c --> doShift (myWorkspaces !! 4) | c <- myGames]
    , [title =? t --> doShift (myWorkspaces !! 5) | t <- myTor]
    , [className =? c --> doShift (myWorkspaces !! 6) | c <- myTorExtras]
    , [className =? c --> doShift (myWorkspaces !! 7) | c <- myPhones]
    , [title =? t --> doFloat | t <- myTitleFloats]
    , [isFullscreen --> doFullFloat]
    ]
  where
    myIgnores = ["desktop_window", "kdesktop"]
    myFirefox = ["firefox", "Iceweasel", "qutebrowser"]
    myChrome =
        [ "Chromium"
        , "Chromium-browser"
        , "Google-chrome"
        , "Google-chrome-stable"
        , "Google-chrome-unstable"
        , "google-chrome"
        ]
    myTorExtras = ["Vidalia"]
    myTor = ["Tor Browser", "TLINKS"]
    myTorrents = ["Deluge"]
    myGames = ["dosbox", "Steam", "pcsx2"]
    myPhones = []
    myClassFloats = ["feh", "gnuplot", "mpv", "VirtualBox", "UniversalEditor"]
    myTitleFloats = []

placeHook' = placeHook $ withGaps (16, 0, 16, 0) (smart (0.5, 0.5))

--------------------------------------------------------------------------------
-- Layouts:
myLayout =
    (avoidStruts .
     smartBorders .
     toggleLayouts (noBorders Full) . spacing 5 . shapedWindows (roundedRect 15))
        (tiled |||
         reflectHoriz tiled ||| Mirror tiled ||| reflectVert (Mirror tiled))
  where
    tiled = Tall nmaster delta ratio
        -- The default number of windows in the master pane
    nmaster = 1
        -- Default proportion of screen occupied by master pane
    ratio = 1 / 2
        -- Percent of screen to increment by when resizing panes
    delta = 3 / 100
