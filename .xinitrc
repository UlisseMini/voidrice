#!/bin/sh

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

xset r rate 300 50

# Remap caps lock to escape (makes vimcraft much easier!)
setxkbmap -option caps:escape

# set the background
feh --bg-center ~/.config/wall.png

# Unclutter makes the mouse invisible after a brief period
unclutter &

# Start dunst for notifications:
dunst &

# start the Simple X Hotkey Daemon
sxhkd &

# run the window manager
# exec i3
# make -C /home/peep/system/dwm
# exec /home/peep/system/dwm/dwm
exec xmonad
