#!/bin/sh
#
# ~/.xsession
#
# Executed by init runlevel 5
export NO_AT_BRIDGE=1
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
export QT_QPA_PLATFORMTHEME=gtk2
export NVIM_GTK_NO_HEADERBAR=1

OS_PREFIX='/usr'
[ -e /etc/nixos/configuration.nix  ] && OS_PREFIX=/run/current-system/sw
export OS_PREFIX

xsetroot -cursor_name left_ptr &

autocutsel -fork &
autocutsel -selection PRIMARY -fork &
volnoti &
numlockx &
nm-applet &
unclutter --ignore-scrolling --exclude-root &
dunst &
udiskie -s &
xmodmap "$HOME/.Xmodmap" &
(sleep 10 && xcape -t=0 -e 'Control_L=Escape') &
xrdb ~/.Xdefaults &
eval "$(cat ~/.fehbg)" &
"$HOME/bin/screensaver/autolock.sh" &
