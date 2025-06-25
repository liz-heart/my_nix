#!/bin/sh

# Statusleiste
waybar &

# Hintergrundbild setzen (swww)
swww init &
sleep 1
swww img ~/wallpapers/w1.png &

# Netzwerk-GUI (damit WLAN geht)
nm-applet &

# Clipboard-Manager (optional)
wl-paste --watch clipman store &

# Audiosteuerung (optional, z.B. Lautstärke-Icon)
# pavucontrol &
