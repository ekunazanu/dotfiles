#!/usr/bin/env sh

CONTENT="$(slurp | grim -g - - | zbarimg --raw -)"
[ $? -eq 0 ] && wl-copy "$CONTENT" && notify-send -u normal -t 5000 -a "Matrix Code" "Barcode(s) copied to clipboard" "$CONTENT" || notify-send -u normal -t 5000 -a "Matrix Code" "No barcodes were found" "Unable to parse barcode data"
