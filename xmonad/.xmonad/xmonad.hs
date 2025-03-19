-- Use /usr/share/xmonad-2.9/ghc-6.12.3/man/xmonad.hs as a reference
-- A good resource for dzen config: http://thinkingeek.com/2011/11/21/simple-guide-configure-xmonad-dzen2-conky/
-- http://lynnard.me/blog/2013/11/05/building-a-vim-like-xmonad-prompt-task-groups-topical-workspaces-float-styles-and-more/
import           Bar.Colors                     ( brighten
                                                , col2string
                                                , dkerGrey
                                                , dkstGrey
                                                , fg
                                                , fgbg
                                                , gradientStr
                                                , lterGrey
                                                , ltstGrey
                                                , orange
                                                , textGrey
                                                )
import qualified Data.Map                      as M
import           Data.Maybe                     ( fromMaybe )
import           Data.Monoid                    ( All(All) )
import           Data.Ratio                     ( (%) )
import           Data.Time                      ( LocalTime
                                                , defaultTimeLocale
                                                , formatTime
                                                , getCurrentTime
                                                , getCurrentTimeZone
                                                , utcToLocalTime
                                                )

import           System.Exit                    ( exitSuccess )
import           System.IO                      ( Handle
                                                , hPutStrLn
                                                )
import           XMonad                  hiding ( Color )
import           XMonad.Actions.FloatKeys       ( keysResizeWindow )
import           XMonad.Actions.Navigation2D    ( Direction2D(D, L, R, U)
                                                , Navigation2DConfig
                                                , centerNavigation
                                                , defaultTiledNavigation
                                                , floatNavigation
                                                , windowGo
                                                , windowSwap
                                                , withNavigation2DConfig
                                                )
import           XMonad.Actions.RotSlaves       ( rotAllDown
                                                , rotAllUp
                                                )
import           XMonad.Actions.Warp            ( warpToWindow )
import           XMonad.Hooks.EwmhDesktops      ( ewmh )
import           XMonad.Hooks.FadeInactive      ( fadeInactiveLogHook )
import           XMonad.Hooks.ManageDocks       ( SetStruts(SetStruts)
                                                , ToggleStruts(ToggleStruts)
                                                , avoidStrutsOn
                                                , docks
                                                , manageDocks
                                                )
import           XMonad.Hooks.ManageHelpers     ( doFullFloat
                                                , isFullscreen
                                                )
import           XMonad.Hooks.Place             ( placeHook
                                                , smart
                                                , withGaps
                                                )
import           XMonad.Hooks.SetWMName         ( setWMName )
import           XMonad.Hooks.StatusBar         ( defToggleStrutsKey
                                                , statusBarPipe
                                                , withEasySB
                                                )
import           XMonad.Hooks.StatusBar.PP      ( PP(PP)
                                                , dynamicLogWithPP
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
import           XMonad.Layout.Accordion
import           XMonad.Layout.BinarySpacePartition
                                                ( ResizeDirectional
                                                    ( ExpandTowards
                                                    )
                                                , SplitShiftDirectional
                                                    ( SplitShift
                                                    )
                                                , emptyBSP
                                                )
import           XMonad.Layout.Gaps             ( GapMessage(ToggleGaps)
                                                , GapSpec
                                                , gaps
                                                , setGaps
                                                )
import           XMonad.Layout.LayoutScreens    ( layoutScreens )
import           XMonad.Layout.MultiColumns     ( multiCol )
import           XMonad.Layout.MultiToggle      ( (??)
                                                , EOT(EOT)
                                                , Toggle(Toggle)
                                                , mkToggle
                                                )
import           XMonad.Layout.MultiToggle.Instances
                                                ( StdTransformers
                                                    ( FULL
                                                    , MIRROR
                                                    , NBFULL
                                                    , NOBORDERS
                                                    , SMARTBORDERS
                                                    )
                                                )
import           XMonad.Layout.Reflect          ( reflectHoriz
                                                , reflectVert
                                                )
import           XMonad.Layout.Renamed          ( Rename(CutLeft, Replace)
                                                , renamed
                                                )
import           XMonad.Layout.Spacing          ( Border(Border)
                                                , spacingRaw
                                                )
import           XMonad.Layout.ThreeColumns     ( ThreeCol(ThreeColMid) )
import           XMonad.Layout.TwoPane          ( TwoPane(TwoPane) )
import qualified XMonad.StackSet               as W
import           XMonad.Util.EZConfig           ( checkKeymap
                                                , mkKeymap
                                                )
import qualified XMonad.Util.ExtensibleState   as XS
import           XMonad.Util.Font               ( Align(AlignRight) )
import           XMonad.Util.Loggers            ( Logger
                                                , fixedWidthL
                                                , logCmd
                                                , logLayout
                                                , logTitle
                                                , wrapL
                                                )
import           XMonad.Util.Run                ( spawnPipe )
import           XMonad.Util.Timer              ( TimerId
                                                , handleTimer
                                                , startTimer
                                                )
import           XMonad.Util.Types              ( Direction1D(Next, Prev) )


import           Startup.Apps                   ( comptonCmd
                                                , flashfocusCmd
                                                , killSpawns
                                                )
import           Utils                          ( getOffset
                                                , getResolution
                                                , ioIconHeight
                                                , ioLineHeight
                                                )


desktopHost, laptopHost :: String
desktopHost = "franky"
laptopHost = "krang"

maxTitleLen :: Int
maxTitleLen = 100

getCurrentTime' :: IO LocalTime
getCurrentTime' = getCurrentTimeZone
    >>= \tz -> getCurrentTime >>= \t -> return $ utcToLocalTime tz t

date' :: String -> Logger
date' fmt = io $ Just . formatTime defaultTimeLocale fmt <$> getCurrentTime'

newtype TidState = TID TimerId
    deriving Typeable

instance ExtensionClass TidState where
    initialValue = TID 0

clockStartupHook = startTimer 1 >>= XS.put . TID

clockEventHook e = do
    (TID t) <- XS.get
    handleTimer t e $ do
        tid <- startTimer 1
        XS.put . TID $ tid
        state <- ask
        logHook . config $ state
        return Nothing
    return $ All True

substring :: String -> String -> Bool
substring (x : xs) [] = False
substring xs ys | prefix xs ys           = True
                | substring xs (tail ys) = True
                | otherwise              = False

prefix :: String -> String -> Bool
prefix []       ys       = True
prefix (x : xs) []       = False
prefix (x : xs) (y : ys) = (x == y) && prefix xs ys

modm = super

modmEmacsKey :: String
modmEmacsKey | modm == super       = "M4-"
             | modm == altMask     = "M1-"
             | modm == controlMask = "C-"
             | modm == shiftMask   = "S-"
             | otherwise           = ""

main :: IO ()
main = do
    dzenCommand   <- myWorkspaceBar
    mySB          <- statusBarPipe dzenCommand myPP
    staloneString <- staloneCmd
    _             <- spawnPipe staloneString
    xmonad $ withEasySB mySB defToggleStrutsKey myConfig

myConfig = ewmh . withNavigation2DConfig myNavigation2DConfig . docks $ def
    { focusFollowsMouse  = False
    , workspaces         = myWorkspaces
    , focusedBorderColor = "#ff950e"
    , normalBorderColor  = "#ffffff"
    , terminal           = myTerminal
    , borderWidth        = 2
    , keys               = (`mkKeymap` myKeys)
    , mouseBindings      = myMouseBindings
    , layoutHook         = myLayout
    , manageHook         = manageDocks <+> myManageHook
    , startupHook        = myStartupHook >> checkKeymap myConfig myKeys
    , modMask            = modm
    }

myTerminal :: String
myTerminal = "kitty"

-- mod1Mask is left alt
-- mod3Mask is right alt
-- mod4Mask is win key
altMask, rAlt, super :: ButtonMask
altMask = mod1Mask
rAlt = mod3Mask
super = mod4Mask

-- key bindings
-- hooks, layouts
staloneCmd :: IO String
staloneCmd = do
    (xres, _   ) <- getResolution
    (xoff, yoff) <- getOffset
    iconHeight   <- ioIconHeight
    let geoX      = (floor . (* 0.8) $ fromIntegral xres) + xoff :: Int
        geoString = "1x1+" ++ show geoX ++ "+" ++ show (yoff + 5)
    return
        $  "stalonetray -i "
        ++ show iconHeight
        ++ " --kludges"
        ++ " force_icons_size --geometry "
        ++ geoString
        ++ " -bg '"
        ++ col2string lterGrey
        ++ "' "
        ++ "--grow-gravity 'W' --window-strut top"

myNavigation2DConfig :: Navigation2DConfig
myNavigation2DConfig = def { defaultTiledNavigation = centerNavigation
                           , floatNavigation        = centerNavigation
                           }

showStrutGapSpec :: GapSpec
showStrutGapSpec = []

hideStrutGapSpec :: GapSpec
hideStrutGapSpec = [(U, 20)]

gapSize :: Integral a => a
gapSize = 5

fontSize :: Integral a => a
fontSize = 10

fontString :: String
fontString = "PragmataPro:Bold:size=" ++ show fontSize

maxBarChars :: (Integral a, Read a) => IO a
maxBarChars = do
    xres <- ((-2 * gapSize) +) . fst <$> getResolution
    return $ xres `div` fontSize

-- Command to launch statusbar
myWorkspaceBar :: IO String
myWorkspaceBar = do
    intLineHeight <- ioLineHeight
    barWidth      <- ((-2 * gapSize) +) . fst <$> getResolution
    (xoff, yoff)  <- getOffset
    let height = show intLineHeight
    return
        $  "dzen2 -p -ta l -bg '"
        ++ col2string ltstGrey
        ++ "'"
        ++ " -fn \""
        ++ fontString
        ++ "\" "
        ++ " -h "
        ++ height
        ++ " -w "
        ++ show barWidth
        ++ " -sa c "
        ++ " -x "
        ++ show (xoff + gapSize)
        ++ " -y "
        ++ show (yoff + gapSize)
        ++ " -e 'onstart=lower' -dock"

myWorkspaces :: [String]
myWorkspaces =
    [ "1 fire"
    , "2 scien"
    , "3 delg"
    , "4 chrome"
    , "5 game"
    , "6 virt"
    , "7 sec"
    , "8 phone"
    , "9 blank"
    , "10 hviz"
    ]

toggleFloat :: X ()
toggleFloat = withFocused $ \w -> do
    floats <- gets (W.floating . windowset)
    if w `M.member` floats
        then withFocused (windows . W.sink)
        else keysResizeWindow (-20, -20) (1 % 2, 1 % 2) w

----------------------------------------------------------------------
-- Status bars and logging
rAlignCmpnt :: Int -> Logger -> Logger
rAlignCmpnt = fixedWidthL AlignRight " "

batteryCmd :: String
batteryCmd =
    "acpi 2>&1 | sed -r '"
        ++ "s/No support (.*)//; "
        ++ "s/.* Full, //; "
        ++ "s/.*?: (.*%), ([0-9:]*).*/\\1/; "
        ++ "s/[dD]ischarging, ([0-9]+%)/\\1-/; "
        ++ "s/[cC]harging, ([0-9]+%)/\\1+/; "
        ++ "s/[cC]arged, //'"

batLog :: Logger
batLog = logCmd batteryCmd

length' :: String -> Int
length' [] = 0
length' (x : xs) | x == '—'  = 2 + length' xs
                 | otherwise = 1 + length' xs

-- ●◉○
myPP :: X PP
myPP = do
    fadeInactiveLogHook 1.00
    title    <- fmap (fromMaybe "") logTitle
    layout   <- fmap (fromMaybe "") logLayout
    battery  <- fmap (fromMaybe "") batLog
    maxChars <- io maxBarChars
    let titleLen  = length' . shorten maxTitleLen $ title
        layoutLen = length layout
        batLen    = length battery
        buffer    = replicate (maxChars - titleLen - layoutLen - batLen) ' '
    return $ dzenPP
        { ppCurrent = const $ wrap (fgbg lterGrey ltstGrey ++ " ") "" "●"
        , ppVisible = const $ wrap
                          (fgbg (brighten lterGrey) ltstGrey ++ " ")
                          ""
                          "●"
        , ppHidden = const $ wrap (fgbg lterGrey ltstGrey ++ " ") "" "◉"
        , ppHiddenNoWindows = const
                                  $ wrap (fgbg lterGrey ltstGrey ++ " ") "" "◌"
        , ppLayout = wrap (gradientStr ltstGrey lterGrey ++ fg textGrey)
                          (gradientStr lterGrey dkstGrey)
        , ppTitle = wrap (fg textGrey) "" . shorten maxTitleLen
        , ppExtras =
            [ return . Just $ buffer
            , wrapL " " " "
            .  return
            .  Just
            $  gradientStr dkstGrey dkerGrey
            ++ fg textGrey
            , logCmd batteryCmd
            , wrapL " " " " . return . Just $ gradientStr dkerGrey lterGrey
            , return . Just $ "             " -- tray
            , wrapL " " " " . return . Just $ gradientStr lterGrey ltstGrey
            , return . Just $ fgbg dkstGrey ltstGrey
            , rAlignCmpnt 6 $ date' "%a, %b %e"
            , return . Just $ " | " ++ fg orange
            , rAlignCmpnt 9 $ date' "%l:%M %p"
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
    setWMName "LG3D"
    fake2Monitors
    clockStartupHook

fake2Monitors :: X ()
fake2Monitors = do
    -- hide all strut-gaps
    sendMessage (SetStruts [] [minBound .. maxBound])
    sendMessage (setGaps hideStrutGapSpec)
    layoutScreens 2 (TwoPane 0.5 0.5)

real1Monitor :: X ()
real1Monitor = do
    -- show all strut-gaps
    sendMessage (SetStruts [minBound .. maxBound] [])
    sendMessage (setGaps showStrutGapSpec)
    rescreen

----------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.

myKeys :: [(String, X ())]
myKeys =
    [ (modmEmacsKey ++ "<Return>"  , spawn myTerminal)
      --  Reset the layouts on the current workspace to default
        --, (modmEmacsKey ++ "C-<Space>" , setLayout $ XMonad.layoutHook conf)
        , (modmEmacsKey ++ "'"         , spawn myTerminal)
        , (modmEmacsKey ++ "S-<Return>", spawn "GDK_SCALE=2 nvim-gtk")
        , (modmEmacsKey ++ "S-'"       , spawn "GDK_SCALE=2 nvim-gtk")
        , (modmEmacsKey ++ "S-'"       , spawn "GDK_SCALE=2 nvim-gtk")
        , (modmEmacsKey ++ "i"         , spawn "/usr/bin/env rofi-pass")
        , (modmEmacsKey ++ "p", spawn "/usr/bin/env rofi -show combi")
        , (modmEmacsKey ++ "S-i", spawn "/usr/bin/env rofi-pass --insert")
        , (modmEmacsKey ++ "e"         , spawn "$HOME/bin/vim-anywhere")
        , (modmEmacsKey ++ "n"         , spawn "ibus engine shin")
        , (modmEmacsKey ++ "S-c"       , kill)
        , (modmEmacsKey ++ ";"         , warpToWindow 1 1)
        , (modmEmacsKey ++ "S-;"       , warpToWindow (1 % 2) (1 % 2))
        , (modmEmacsKey ++ "<Space>"   , sendMessage NextLayout)
        , ( modmEmacsKey ++ "f"
          , sendMessage ToggleStruts >> sendMessage (Toggle NBFULL)
          )
            -- Resize viewed windows to the correct size
        , (modmEmacsKey ++ "w"   , fake2Monitors)
        , (modmEmacsKey ++ "C-w" , real1Monitor)
        , (modmEmacsKey ++ "o"   , windows W.focusDown)
        , (modmEmacsKey ++ "S-o" , windows W.focusUp)
        , (modmEmacsKey ++ "l"   , windowGo R False)
        , (modmEmacsKey ++ "h"   , windowGo L False)
        , (modmEmacsKey ++ "k"   , windowGo U False)
        , (modmEmacsKey ++ "j"   , windowGo D False)
        , (modmEmacsKey ++ "S-l" , windowSwap R False)
        , (modmEmacsKey ++ "S-h" , windowSwap L False)
        , (modmEmacsKey ++ "S-k" , windowSwap U False)
        , (modmEmacsKey ++ "S-j" , windowSwap D False)
        , (modmEmacsKey ++ "C-l" , sendMessage Expand)
        , (modmEmacsKey ++ "C-h" , sendMessage Shrink)
        , (modmEmacsKey ++ "C-k" , sendMessage (IncMasterN 1))
        , (modmEmacsKey ++ "C-j" , sendMessage (IncMasterN (-1)))
        , (modmEmacsKey ++ "C-m" , windows W.focusMaster)
        , (modmEmacsKey ++ "M1-l", sendMessage $ ExpandTowards R)
        , (modmEmacsKey ++ "M1-h", sendMessage $ ExpandTowards L)
        , (modmEmacsKey ++ "M1-k", sendMessage $ ExpandTowards U)
        , (modmEmacsKey ++ "M1-j", sendMessage $ ExpandTowards D)
        , (modmEmacsKey ++ "r"   , sendMessage (SplitShift Prev))
        , (modmEmacsKey ++ "C-r" , sendMessage (SplitShift Next))
        , (modmEmacsKey ++ "m"   , sendMessage (Toggle MIRROR))
        , (modmEmacsKey ++ "t"   , toggleFloat)
        , (modmEmacsKey ++ ","   , rotAllUp)
        , (modmEmacsKey ++ "."   , rotAllDown)
        , (modmEmacsKey ++ "g"   , sendMessage ToggleGaps)
        , (modmEmacsKey ++ "S-q" , io exitSuccess)
        , ( modmEmacsKey ++ "q"
          , killSpawns >> spawn "xmonad --recompile; xmonad --restart"
          )
    -- find multimedia key codes at  /usr/include/X11/XF86keysym.h
        , ("<XF86AudioLowerVolume>", spawn "$HOME/bin/vol-control 1.50dB-"),
        , ("<XF86AudioMute>", spawn "$HOME/bin/vol-control m"),
        , ("<XF86AudioRaiseVolume>", spawn "$HOME/bin/vol-control 1.50dB+"),
        , ("<XF86AudioMicMute>", spawn "$HOME/bin/toggle-mic-mute"),
        , ( "<XF86MonBrightnessUp>"
          , spawn "$HOME/bin/bright $(expr $($HOME/bin/bright) + 100)"
          )
        , ( "<XF86MonBrightnessDown>"
          , spawn "$HOME/bin/bright $(expr $($HOME/bin/bright) - 100)"
          )
        , ("<XF86TouchpadOn>" , spawn "$HOME/bin/macros/touchpad_notify.py on")
        , ("<XF86TouchpadOff>", spawn "$HOME/bin/macros/touchpad_notify.py off")
        ]
        ++ [ (modmEmacsKey ++ m ++ k, windows $ f i)
           | (i, k) <- zip myWorkspaces $ show <$> ([1 .. 9] ++ [0])
           , (f, m) <- [(W.greedyView, ""), (W.shift, "S-")]
           ]
        ++ [ ( modmEmacsKey ++ m ++ key
             , screenWorkspace sc >>= flip whenJust (windows . f)
             )
           | (key, sc) <- zip ["a", "s", "d"] [0 ..]
           , (f  , m ) <- [(W.view, ""), (W.shift, "S-")]
           ]



--------------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
myMouseBindings :: XConfig t -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings XConfig { XMonad.modMask = modm } = M.fromList
    [ ( (modm, button1)
      , \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster
      )
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)
    , ( (modm, button3)
      , \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster
      )
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
    composeAll
        . concat
        $ [ [ resource =? r --> doIgnore | r <- myIgnores ]
          , [ className =? c --> placeHook' <+> doFloat | c <- myClassFloats ]
          , [ className =? c --> doShift (head myWorkspaces) | c <- myBrowsers ]
          , [ className =? c --> doShift (myWorkspaces !! 1) | c <- myChats ]
          , [ className =? c --> doShift (myWorkspaces !! 2) | c <- myTorrents ]
          , [ className =? c --> doShift (myWorkspaces !! 3) | c <- myOpSec ]
          , [ className =? c --> doShift (myWorkspaces !! 4)
            | c <- myVirtualMachines
            ]
          , [ className =? c --> doShift (myWorkspaces !! 5) | c <- myGames ]
          , [ title =? t --> doFloat | t <- myTitleFloats ]
          , [isFullscreen --> doFullFloat]
          ]
  where
    myIgnores = ["desktop_window", "kdesktop"]
    myFirefox = ["firefox", "Iceweasel", "qutebrowser", "Navigator", "floorp"]
    myChrome =
        [ "Chromium"
        , "Chromium-browser"
        , "Google-chrome"
        , "Google-chrome-stable"
        , "Google-chrome-unstable"
        , "google-chrome"
        ]
    myBrowsers = myFirefox ++ myChrome
    myTorrents = ["deluge", "Deluge-gtk", "Deluge"]
    myChats =
        ["Microsoft Teams - Preview", "Slack", "Signal", "TelegramDesktop"]
    myGames = ["dosbox", "Steam", "steam", "pcsx2", "zenity"]
    myOpSec = ["Claws-mail", "Balsa", "Tor Browser"]
    myClassFloats =
        [ "feh"
        , "gnuplot"
        , "mpv"
        , "UniversalEditor"
        , "sxiv"
        , "Sxiv"
        , "virt-manager"
        ]
    myTitleFloats     = ["Microsoft Teams Notification"]
    myVirtualMachines = ["VirtualBox Machine", "VirtualBox Manager"]

placeHook' = placeHook $ withGaps (16, 0, 16, 0) (smart (0.5, 0.5))

--------------------------------------------------------------------------------
layoutModifiers =
    avoidStrutsOn [U]
        . mkToggle (NBFULL ?? NOBORDERS ?? MIRROR ?? SMARTBORDERS ?? EOT)
        . renamed [CutLeft (length "Spacing ")]
        . gaps hideStrutGapSpec
        . spacingRaw False
                     (Border gapSize gapSize gapSize gapSize)
                     True
                     (Border gapSize gapSize gapSize gapSize)
                     True

-- Layouts:
myLayout = layoutModifiers
    (   reflectHoriz tiled
    ||| tiled
    ||| emptyBSP
    ||| mid3
    ||| equicol
    ||| Mirror Accordion
    )
  where
    equicol = renamed [Replace "Equipartition"] $ multiCol [1] 1 delta (-ratio)
    tiled   = renamed [Replace "tiled"] $ Tall nmaster delta ratio
    mid3    = renamed [Replace "3Col"] (ThreeColMid 1 delta ratio)
    nmaster = 1 -- The default number of windows in the master pane
    ratio   = 1 / 2 -- Default proportion of screen occupied by master pane
    delta   = 3 / 100 -- Percent of screen to increment by when resizing panes
