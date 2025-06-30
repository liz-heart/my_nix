#!/usr/bin/env bash

# WLAN-Applet (GUI)
nm-applet &

# Clipboard-Manager
wl-paste --watch clipman store &

# Notification-Dienst
dunst &
