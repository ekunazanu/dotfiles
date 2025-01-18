#!/usr/bin/sh

playerctl status > /dev/null 2>&1 || exit 0
LABEL=$(playerctl metadata --format "{{ title }}")
echo "▶  $LABEL"
echo "▶  $LABEL"
if [ "$(playerctl status)" = "Paused" ]; then
    echo "#586048"
fi
exit 0
