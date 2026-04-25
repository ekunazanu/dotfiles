#!/usr/bin/env sh

set -o pipefail

CONTENT=$(slurp | grim -g - - | zbarimg --raw -)

if [ $? -eq 0 ]; then
    wl-copy "$CONTENT" && notify-send -u normal -t 5000 -a "Matrix Code" "Barcode(s) copied to clipboard" "$CONTENT"
else
    notify-send -u normal -t 5000 -a "Matrix Code" "No barcodes were found" "Unable to parse barcode data"
fi
