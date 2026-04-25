#!/usr/bin/env sh

set -o pipefail

CONTENT="$(slurp | grim -g - - | tesseract - -)"

if [ $? -eq 0 ]; then
    wl-copy "$CONTENT" && notify-send -u normal -t 5000 -a "OCR" "Content copied to clipboard" "$CONTENT"
else
    notify-send -u normal -t 5000 -a "OCR" "No text was found" "Unable to parse data"
fi
