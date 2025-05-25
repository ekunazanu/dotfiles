#!/usr/bin/sh

if [ $BLOCK_BUTTON -eq 1 ]; then
    playerctl play-pause
elif [ $BLOCK_BUTTON -eq 3 ]; then
    playerctl next
elif [ $BLOCK_BUTTON -eq 2 ]; then
    playerctl previous
elif [ $BLOCK_BUTTON -eq 4 ]; then
    playerctl position 5+
elif [ $BLOCK_BUTTON -eq 5 ]; then
    playerctl position 5-
else
    playerctl status > /dev/null 2>&1 || exit 0
fi
LABEL=$(playerctl metadata --format "{{ title }}")
echo "▶  $LABEL"
echo "▶  $LABEL"
if [ "$(playerctl status)" = "Paused" ]; then
    echo "#586048"
fi
exit 0
