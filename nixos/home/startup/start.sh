#!/usr/bin/env bash

# Wallpaper-Dienst (nur einmalig initialisieren)
swww init &

# WLAN-Applet (GUI)
nm-applet &

# Clipboard-Manager
wl-paste --watch clipman store &

# Notification-Dienst
dunst &
