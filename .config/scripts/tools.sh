#!/usr/bin/env sh

TOOLS=('ocr' 'matrix codes' 'passwords' 'totp' 'pastebin' 'wifi' 'color picker' 'calculate' 'save')
TOOL="$(( IFS=$'\n'; echo "${TOOLS[*]}" ) | tofi | tr -d '[:blank:]' | tr '[:upper:]' '[:lower:]')"

exec "$HOME/.config/scripts/tools.$TOOL.sh"
