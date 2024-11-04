#!/usr/bin/env sh

MENU="tofi"
TOOLS=('matrix codes' 'color picker' 'ocr' 'emoji picker' 'calculator' 'copy to ~/tmp' 'password manager')
TOOL="$(( IFS=$'\n'; echo "${TOOLS[*]}" ) | $MENU --prompt-text "tools:" | tr -d '[:blank:]' | tr '[:upper:]' '[:lower:]')"
exec "$HOME/.config/scripts/tools.$TOOL.sh"

# maybe just use conditional statements

# song identifier?
# tmp wl-paste screenshot
