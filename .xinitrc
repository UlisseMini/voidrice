#!/bin/sh

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

xset r rate 300 50

# Remap caps lock to escape (makes vimcraft much easier!)
setxkbmap -option caps:escape

# set the background
feh --bg-scale ~/.config/wall.png

# Unclutter makes the mouse invisible after a brief period
unclutter &

# Start dunst for notifications:
dunst &

# run the window manager
# exec i3
# exec dwm
exec xmonad
