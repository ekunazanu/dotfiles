#!/usr/bin/env sh

FILENAME=$(tofi < /dev/null --prompt-text "filename:")

if [-n "$FILENAME"]; then
    wl-paste > $FILENAME && notify-send -u normal -a "Clipboard" "Pasted file" "Pasted clipboard contents to ~/$FILENAME"
else
   notify-send -u normal -a "Clipboard" "Error" "No file name provided" 
fi
