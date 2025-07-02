#!/usr/bin/env bash

# Screenshot in Datei + Zwischenablage (Bild)
FILE="/tmp/screenshot.png"

grim -g "$(slurp)" "$FILE" && \
    wl-copy --type image/png < "$FILE" && \
    cp "$FILE" ~/Bilder/screenshot-$(date +%s).png
