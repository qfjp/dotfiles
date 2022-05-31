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
import           Data.Maybe
import           Data.Ratio                     ( (%) )
import           Data.Word

import           XMonad                  hiding ( Color )

import           XMonad.Actions.FloatKeys       ( keysResizeWindow )
import           XMonad.Actions.RotSlaves       ( rotAllDown
                                                , rotAllUp
                                                )
import           XMonad.Hooks.Place             ( placeHook
                                                , smart
                                                , withGaps
                                                )

import           XMonad.Hooks.DynamicLog        ( dynamicLogWithPP
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
import           XMonad.Hooks.EwmhDesktops      ( ewmh )
import           XMonad.Hooks.ManageDocks       ( ToggleStruts(ToggleStruts)
                                                , avoidStrutsOn
                                                , docks
                                                , manageDocks
                                                )
import           XMonad.Hooks.ManageHelpers     ( doFullFloat
                                                , isFullscreen
                                                )
import           XMonad.Hooks.SetWMName         ( setWMName )

import           XMonad.Layout.NoBorders        ( noBorders
                                                , smartBorders
                                                )
import           XMonad.Layout.Reflect          ( reflectHoriz
                                                , reflectVert
                                                )
import           XMonad.Layout.Spacing          ( spacingRaw, Border(Border) )
import           XMonad.Layout.ToggleLayouts
import qualified XMonad.StackSet               as W
import           XMonad.Util.Font               ( Align
                                                  ( AlignCenter
                                                  , AlignLeft
                                                  , AlignRight
                                                  )
                                                )
import           XMonad.Util.Loggers            ( Logger
                                                , date
                                                , fixedWidthL
                                                , logCmd
                                                , logLayout
                                                , logTitle
                                                , wrapL
                                                )
import           XMonad.Util.Run                ( spawnPipe )

import           System.Exit                    ( exitSuccess )
import           System.IO                      ( Handle
                                                , hPutStrLn
                                                )

import           XMonad.Actions.Navigation2D
import           XMonad.Layout.WindowNavigation

import           XMonad.Hooks.FadeInactive

import qualified XMonad.Util.ExtensibleState   as XS
import           Utils                          ( getOffset
                                                , getResolution
                                                , ioIconHeight
                                                , ioLineHeight
                                                )

import           Startup.Apps

desktopHost, laptopHost :: String
desktopHost = "franky"
laptopHost = "krang"

maxTitleLen :: Int
maxTitleLen = 100

substring :: String -> String -> Bool
substring (x : xs) [] = False
substring xs ys | prefix xs ys           = True
                | substring xs (tail ys) = True
                | otherwise              = False

prefix :: String -> String -> Bool
prefix []       ys       = True
prefix (x : xs) []       = False
prefix (x : xs) (y : ys) = (x == y) && prefix xs ys

main :: IO ()
main = do
  dzenCommand      <- myWorkspaceBar
  dzenProcess      <- spawnPipe dzenCommand
  staloneString    <- staloneCmd
  comptonString    <- comptonCmd
  flashfocusString <- flashfocusCmd
  _                <- spawnPipe staloneString
  _                <- spawnPipe comptonString
  _                <- spawnPipe flashfocusString
  xmonad $ ewmh . withNavigation2DConfig myNavigation2DConfig . docks $ def
    { focusFollowsMouse  = False
    , workspaces         = myWorkspaces
    , focusedBorderColor = "#ff950e"
    , normalBorderColor  = "#ffffff"
    , terminal           = "kitty"
    , borderWidth        = 2
    , keys               = myKeys
    , mouseBindings      = myMouseBindings
    , layoutHook         = myLayout
    , logHook            = myLogHook dzenProcess
    , manageHook         = manageDocks <+> myManageHook
    , startupHook        = myStartupHook
    , modMask            = mod1Mask
    }

-- mod1Mask is left alt
-- mod3Mask is right alt
-- mod4Mask is win key
--comptonString <- comptonCmd
--_ <- spawnPipe comptonString
-- key bindings
-- hooks, layouts
staloneCmd :: IO String
staloneCmd = do
  (xres, _   ) <- getResolution
  (xoff, yoff) <- getOffset
  iconHeight   <- ioIconHeight
  let geoX      = (floor . (* 0.8) $ fromIntegral xres) + xoff :: Int
      geoString = "1x1+" ++ show geoX ++ "+" ++ (show $ yoff + 5)
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
    ++ " -fn \"PragmataPro:Bold:size=10\""
    ++ " -h "
    ++ height
    ++ " -w "
    ++ show width
    ++ " -sa c -x 5 -y 5 -e 'onstart=lower' -dock"

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
myLogHook :: Handle -> X ()
myLogHook h = do
  fadeInactiveLogHook 1.00
  title   <- fmap (fromMaybe "") logTitle
  layout  <- fmap (fromMaybe "") logLayout
  battery <- fmap (fromMaybe "") batLog
  maxChars <- io maxBarChars
  let titleLen  = length' . shorten maxTitleLen $ title
      layoutLen = length layout
      batLen    = length battery
      buffer    = replicate (maxChars - titleLen - layoutLen - batLen) ' '
  dynamicLogWithPP $ dzenPP
    { ppCurrent         = const $ wrap (fgbg lterGrey ltstGrey ++ " ") "" "●"
    , ppVisible = const $ wrap (fgbg (brighten lterGrey) ltstGrey ++ " ") "" "●"
    , ppHidden          = const $ wrap (fgbg lterGrey ltstGrey ++ " ") "" "◉"
    , ppHiddenNoWindows = const $ wrap (fgbg lterGrey ltstGrey ++ " ") "" "◌"
    , ppLayout          = wrap (gradientStr ltstGrey lterGrey ++ fg textGrey)
                               (gradientStr lterGrey dkstGrey)
    , ppTitle           = wrap (fg textGrey) "" . shorten maxTitleLen
    , ppOutput          = hPutStrLn h
    , ppExtras = [ return . Just $ buffer
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
                 , rAlignCmpnt 6 $ date "%a, %b %e"
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
  setWMName "LG3D"
  --clockStartupHook

----------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@XConfig { XMonad.modMask = modm } =
  M.fromList
    $  [ ((modm, xK_Return)                  , spawn $ XMonad.terminal conf)
       , ((modm, xK_apostrophe)              , spawn $ XMonad.terminal conf)
       , ((modm .|. shiftMask, xK_Return)    , spawn "GDK_SCALE=2 nvim-gtk")
       , ((modm .|. shiftMask, xK_apostrophe), spawn "GDK_SCALE=2 nvim-gtk")
       , ((modm, xK_i)                  , spawn "/usr/bin/env rofi-pass")
       , ((modm, xK_p), spawn "/usr/bin/env rofi -show combi")
       , ((modm .|. shiftMask, xK_i), spawn "/usr/bin/env rofi-pass --insert")
       , ((modm, xK_e)                  , spawn "$HOME/bin/vim-anywhere")
       , ((modm .|. shiftMask, xK_c)    , kill)
       , ((modm, xK_space)              , sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
       , ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
       , ((modm, xK_f), sendMessage ToggleStruts >> sendMessage (Toggle "Full"))
    -- Resize viewed windows to the correct size
       , ((modm, xK_n)                  , refresh)
       , ((modm, xK_o)                  , windows W.focusDown)
       , ((modm .|. shiftMask, xK_o)    , windows W.swapMaster)
       , ((modm, xK_l)                  , windowGo R False)
       , ((modm, xK_h)                  , windowGo L False)
       , ((modm, xK_k)                  , windowGo U False)
       , ((modm, xK_j)                  , windowGo D False)
       , ((modm .|. shiftMask, xK_l)    , windowSwap R False)
       , ((modm .|. shiftMask, xK_h)    , windowSwap L False)
       , ((modm .|. shiftMask, xK_k)    , windowSwap U False)
       , ((modm .|. shiftMask, xK_j)    , windowSwap D False)
       , ((modm .|. controlMask, xK_h)  , sendMessage Shrink)
       , ((modm .|. controlMask, xK_l)  , sendMessage Expand)
       , ((modm .|. controlMask, xK_k)  , sendMessage (IncMasterN 1))
       , ((modm .|. controlMask, xK_j)  , sendMessage (IncMasterN (-1)))
       , ((modm, xK_m)                  , windows W.focusMaster)
       , ((modm, xK_t)                  , toggleFloat)
       , ((modm, xK_comma)              , rotAllUp)
       , ((modm, xK_period)             , rotAllDown)
       , ((modm, xK_b)                  , sendMessage ToggleStruts)
       , ((modm .|. shiftMask, xK_q)    , io exitSuccess)
       , ( (modm, xK_q)
         , killSpawns >> spawn "xmonad --recompile; xmonad --restart"
         )
    -- ##   Macros # --
    -- find multimedia key codes at  /usr/include/X11/XF86keysym.h
       , ((0, 0x1008FF11), spawn "$HOME/bin/macros/vol-control 1.50dB-")
       , ((0, 0x1008FF12), spawn "$HOME/bin/macros/vol-control m")
       , ((0, 0x1008FF13), spawn "$HOME/bin/macros/vol-control 1.50dB+")
       , ((0, 0x1008FF14), spawn "$HOME/bin/macros/toggle-mic-mute") -- XF86AudioPlay
       , ((0, 0x1008FF31), spawn "$HOME/bin/macros/toggle-mic-mute") -- XF86AudioPause
       , ( (0, 0x1008FF02)
         , spawn "$HOME/bin/bright $(expr $($HOME/bin/bright) + 100)"
         )
       , ( (0, 0x1008FF03)
         , spawn "$HOME/bin/bright $(expr $($HOME/bin/bright) - 100)"
         )
       , ((0, 0x1008FFB0), spawn "$HOME/bin/macros/touchpad_notify.py on")
       , ((0, 0x1008FFB1), spawn "$HOME/bin/macros/touchpad_notify.py off")
       ]
    ++ [ ((m .|. modm, k), windows $ f i)
       | (i, k) <- zip (XMonad.workspaces conf) $ [xK_1 .. xK_9] ++ [xK_0]
       , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
       ] -- Switch workspaces
    ++ [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
       | (key, sc) <- zip [xK_a, xK_s, xK_d] [0 ..]
       , (f  , m ) <- [(W.view, 0), (W.shift, shiftMask)]
       ] -- Switch physical screens

--------------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
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
      , [ className =? c --> doShift (myWorkspaces !! 0) | c <- myFirefox ]
      , [ className =? c --> doShift (myWorkspaces !! 2) | c <- myTorrents ]
      , [ className =? c --> doShift (myWorkspaces !! 3) | c <- myChrome ]
      , [ className =? c --> doShift (myWorkspaces !! 4) | c <- myGames ]
      , [ className =? c --> doShift (myWorkspaces !! 5) | c <- myChats ]
      , [ className =? t --> doShift (myWorkspaces !! 6)
        | t <- ["VirtualBox Machine"]
        ]
      , [ className =? c --> doShift (myWorkspaces !! 8)
        | c <- ["VirtualBox Manager"]
        ]
      , [ title =? t --> doFloat | t <- myTitleFloats ]
      , [isFullscreen --> doFullFloat]
      ]
 where
  myIgnores = ["desktop_window", "kdesktop"]
  myFirefox = ["firefox", "Iceweasel", "qutebrowser", "Navigator"]
  myChrome =
    [ "Chromium"
    , "Chromium-browser"
    , "Google-chrome"
    , "Google-chrome-stable"
    , "Google-chrome-unstable"
    , "google-chrome"
    ]
  myTorrents    = ["Deluge"]
  myChats       = ["Microsoft Teams - Preview", "Slack"]
  myGames       = ["dosbox", "Steam", "pcsx2", "zenity"]
  myClassFloats = ["feh", "gnuplot", "mpv", "UniversalEditor"]
  myTitleFloats = ["Microsoft Teams Notification"]

placeHook' = placeHook $ withGaps (16, 0, 16, 0) (smart (0.5, 0.5))

--------------------------------------------------------------------------------
layoutModifiers =
  avoidStrutsOn [U]
    . smartBorders
    . toggleLayouts (noBorders Full)
    . spacingRaw False
                 (Border gapSize gapSize gapSize gapSize)
                 True
                 (Border gapSize gapSize gapSize gapSize)
                 True

-- Layouts:
myLayout =
  layoutModifiers
    $ (tiled ||| reflectHoriz tiled ||| Mirror tiled ||| reflectVert
        (Mirror tiled)
      )
 where
  tiled   = Tall nmaster delta ratio
  nmaster = 1 -- The default number of windows in the master pane
  ratio   = 1 / 2 -- Default proportion of screen occupied by master pane
  delta   = 3 / 100 -- Percent of screen to increment by when resizing panes
