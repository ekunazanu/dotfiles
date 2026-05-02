#!/usr/bin/env sh

PLATFORM=$(tofi </dev/null --prompt-text "platform:"); if [ -z "$PLATFORM" ]; then exit; fi
ACCOUNT=$(tofi </dev/null --prompt-text "account:");  if [ -z "$ACCOUNT" ]; then exit; fi
SEED=$(echo -e "0\n1\n2\n3\n4" | tofi --prompt-text "seed:"); if [ -z "$SEED" ]; then exit; fi
LENGTH=$(echo -e "24\n20\n12" | tofi --prompt-text "length:"); if [ -z "$LENGTH" ]; then exit; fi
PASSPHRASE=$(tofi </dev/null --hide-input true --hidden-character "*" --prompt-text "passphrase:"); if [ -z "$PASSPHRASE" ]; then exit; fi

PASSWORD=$(echo -n "$ACCOUNT$PLATFORM$SEED$PASSPHRASE" | sha256sum | awk '{print $1}' | xxd -r -p | base64 | cut -c -$LENGTH)

if [ -n "$PASSWORD" ]; then
    wl-copy "$PASSWORD" && notify-send -u normal -t 5000 -a "Passwords" "$PLATFORM" "Copied password connected to clipboard"
else
    notify-send -u normal -t 5000 -a "Passwords" "Error" "Failed to connect to get password"
fi
