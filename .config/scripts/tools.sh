#!/usr/bin/env sh

TOOLS=('calculate' 'save' 'ocr' 'matrix codes' 'color picker' 'pastebin' 'passwords' 'wifi')
TOOL="$(( IFS=$'\n'; echo "${TOOLS[*]}" ) | tofi --prompt-text "tools:" | tr -d '[:blank:]' | tr '[:upper:]' '[:lower:]')"

exec "$HOME/.config/scripts/tools.$TOOL.sh"
