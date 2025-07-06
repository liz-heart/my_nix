#!/usr/bin/env bash

# WLAN-Applet (GUI)
nm-applet &

# Clipboard-Manager
wl-paste --watch clipman store &

# Notification-Dienst (nur wenn nicht aktiv)
pgrep -x dunst > /dev/null || dunst &

# Kurzes Delay für stabile Monitor-Erkennung
sleep 0.5

# XDG_DATA_DIRS für Desktop-Integration (z. B. "Öffnen mit..." in Dolphin)
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-${HOME}/.nix-profile/share:/etc/profiles/per-user/$USER/share:/run/current-system/sw/share:/usr/share}"
