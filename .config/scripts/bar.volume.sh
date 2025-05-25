#!/usr/bin/sh

if [ $BLOCK_BUTTON -eq 1 ]; then
    wpctl set-mute @DEFAULT_SINK@ toggle
elif [ $BLOCK_BUTTON -eq 4 ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
elif [ $BLOCK_BUTTON -eq 5 ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
fi
VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -c 9-)
echo " $VOL" | cut -c -8
echo " $VOL" | cut -c -8
echo "$VOL" | awk '{if (NF >=2) exit 0; else exit 1}' && echo "#586048"
exit 0
