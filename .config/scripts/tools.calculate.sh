#!/usr/bin/env sh

EXPRESSION=$(tofi < /dev/null --prompt-text "calculate:")

if [ -z "$EXPRESSION" ]; then
    notify-send -u normal -a "Calculator" "Invalid Expression" "No expression provided"
    exit
fi

RESULT=$(echo "$EXPRESSION" | bc 2>/dev/null)

if [ $? -eq 0 ]; then
    wl-copy "$RESULT" && notify-send -u normal -a "Calculator" "$RESULT" "Copied $RESULT to clipboard\n$EXPRESSION"
else
    notify-send -u normal -a "Calculator" "Invalid Expression" "Failed to parse $EXPRESSION"
fi
