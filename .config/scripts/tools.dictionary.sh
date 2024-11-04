#!/usr/bin/env sh

MENUTOOL="tofi"
WORD="$(cat "$HOME/.config/scripts/tools.dictionary.wordlist.txt" | $MENUTOOL --prompt-text 'dictionary:'"
DEFINITION="$({ dict 2>&3 -f -C -d wn "$WORD" | tail -n +4 | cut -c 7-; } 3>&1)"
notify-send -u normal -t 0 -a "Dictionary" "$WORD" "$DEFINITION"
