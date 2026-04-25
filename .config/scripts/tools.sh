#!/usr/bin/env sh

TOOLS=('calculate' 'paste' 'ocr' 'matrix codes' 'color picker' 'passwords' 'wifi')
TOOL="$(( IFS=$'\n'; echo "${TOOLS[*]}" ) | tofi --prompt-text "tools:" | tr -d '[:blank:]' | tr '[:upper:]' '[:lower:]')"

exec "$HOME/.config/scripts/tools.$TOOL.sh"
