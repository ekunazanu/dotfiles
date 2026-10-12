#!/usr/bin/env sh

declare -A keys

CODES="$HOME/Downloads/auth/codes.totp.txt"
SELECTED=$(
    while read -r KEY REST; do
        printf '%s\n' "$REST"
    done < $CODES |
    tofi --require-match "true" --prompt-text "platform:"
)

if [ -z "$SELECTED" ]; then exit; fi

while read -r KEY REST; do
    if [[ "$REST" == "$SELECTED" ]]; then
        SELECTED_KEY="$KEY"
        break
    fi
done < $CODES

CODE="$(oathtool --totp --base32 $SELECTED_KEY)"

if [ -n "$CODE" ]; then
    wl-copy "$CODE" && notify-send -u normal -t 5000 -a "TOTP" "$CODE" "$SELECTED\nCopied code to clipboard"
else
    notify-send -u normal -t 5000 -a "TOTP" "Error" "Failed to connect to get code"
fi
