#!/usr/bin/env sh

set -o pipefail

COLOR=$(slurp -p | grim -g - - | convert - txt: | tail -n 1 | cut -d ' ' -f 4)

if [ $? -eq 0 ]; then
    wl-copy "$COLOR" && notify-send -u normal -t 5000 -a "Color Picker" "$COLOR" "Copied to clipboard"
else
    notify-send -u normal -t 5000 -a "Color Picker" "Unable to find color information" "There was an error parsing the data"
fi
