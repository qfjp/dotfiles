{-# LANGUAGE DeriveDataTypeable, FlexibleContexts, FlexibleInstances #-}
{-# LANGUAGE InstanceSigs, MultiParamTypeClasses, RankNTypes         #-}
{-# LANGUAGE TypeSynonymInstances                                    #-}

module ShapedWindow
    ( ShapeDrawer
    , roundedRect
    , shapedWindows
    ) where

import           XMonad
import           XMonad.Layout.LayoutModifier

import           Graphics.X11.Xshape

makePoint ::
       forall a b. (Integral a, Integral b)
    => (a, b)
    -> Point
makePoint (x, y) =
    let x_pos = fromIntegral x :: Position
        y_pos = fromIntegral y :: Position
     in Point {pt_x = x_pos, pt_y = y_pos}

type ShapeDrawer = Dimension -> Dimension -> Display -> Drawable -> GC -> IO ()

data ShapeModifier a =
    ShapeModifier
        { drawShape :: ShapeDrawer
        }
    deriving (Show, Read)

instance Show (ShapeDrawer) where
    show sm = ""

instance Read (ShapeDrawer) where
    readsPrec _ s = [(roundedRect 0, s)]

instance LayoutModifier ShapeModifier Window where
    handleMess :: ShapeModifier a -> SomeMessage -> X (Maybe (ShapeModifier a))
    handleMess (sm@ShapeModifier {drawShape = ds}) msg =
        case fromMessage msg of
            Just m ->
                case m of
                    MappingNotifyEvent {ev_window = win, ev_event_display = dpy} -> do
                        io $ setShape dpy win ds
                        return $ Nothing
                    PropertyEvent {ev_window = win, ev_event_display = dpy} -> do
                        io $ setShape dpy win ds
                        return $ Nothing
            Nothing -> return Nothing

setShape :: Display -> Drawable -> ShapeDrawer -> IO ()
setShape dpy drw ds = do
    rootw <- rootWindow dpy (defaultScreen dpy)
    if drw == rootw
        then return ()
        else do
            wa <- getWindowAttributes dpy drw
            let w = fromIntegral $ wa_width wa :: Dimension
            let h = fromIntegral $ wa_height wa :: Dimension
            mask <- createPixmap dpy drw w h 1
            gc <- createGC dpy mask
            ds w h dpy mask gc
            xshapeCombineMask dpy drw shapeBounding 0 0 mask shapeSet
            freePixmap dpy mask
            freeGC dpy gc

roundedRect :: Dimension -> ShapeDrawer
roundedRect r w h dpy drw gc = do
    let d = 2 * r
    setForeground dpy gc 0
    fillRectangle dpy drw gc 0 0 w h
    setForeground dpy gc 1
    fillArc dpy drw gc 0 0 d d 0 23040
    fillArc dpy drw gc (fromIntegral $ w - d) 0 d d 0 23040
    fillArc dpy drw gc 0 (fromIntegral $ h - d) d d 0 23040
    fillArc dpy drw gc (fromIntegral $ w - d) (fromIntegral $ h - d) d d 0 23040
    fillRectangle dpy drw gc (fromIntegral r) 0 (w - d) h
    fillRectangle dpy drw gc 0 (fromIntegral r) w (h - d)

roundedBorder :: Dimension -> ShapeDrawer
roundedBorder r w h dpy drw gc = return ()

shapedWindows :: ShapeDrawer -> l a -> ModifiedLayout ShapeModifier l a
shapedWindows shapeMod = ModifiedLayout (ShapeModifier {drawShape = shapeMod})
