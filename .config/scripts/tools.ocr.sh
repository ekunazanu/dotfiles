#!/usr/bin/env sh

CONTENT="$(slurp | grim -g - - | tesseract - -)"
[ $? -eq 0 ] && wl-copy "$CONTENT" && notify-send -u normal -t 5000 -a "OCR" "Content copied to clipboard" "$CONTENT" || notify-send -u normal -t 5000 -a "OCR" "No text was found" "Unable to parse data"
