#!/usr/bin/env sh

OPERATION=$(echo -e "post\nget" | tofi --prompt-text "operation:")
PLATFORM="https://paste.rs/"

case "$OPERATION" in
    post)
        CONTENT=$(wl-paste)
        RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$PLATFORM" --data-binary "$CONTENT")
        CODE=$(printf "%s" "$RESPONSE" | tail -n1)
        LINK=$(printf "%s" "$RESPONSE" | head -n1)
        case "$CODE" in
        201)
            wl-copy "$LINK" && notify-send -u normal -a "Pastebin" "$LINK" "Link copied to clipboard"
            ;;
        206)
            wl-copy "$LINK" && notify-send -u critical -a "Pastebin" "$LINK" "Content partially uploaded"
            ;;
        *)
            notify-send -u normal -a "Pastebin" "Upload failed" "Server returned $CODE"
            exit 1
            ;;
        esac
        ;;
    get)
        LINK=$(cliphist list | grep -E $'\thttps://' | tofi --prompt-text "link:" | cliphist decode | tr -d '\n')
        if CONTENT=$(curl -s --fail --proto https "$LINK"); then
            wl-copy "$CONTENT" && notify-send -u normal -a "Pastebin" "Copied" "Content copied to clipboard"
        else
            notify-send -u normal -a "Pastebin" "Error" "Failed to fetch content"
            exit 1
        fi
        ;;
    *)
        notify-send -u normal -a "Pastebin" "Invalid operation" "Invalid operation chosen"
        exit 1
        ;;
esac
