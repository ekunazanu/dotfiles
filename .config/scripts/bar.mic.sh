#!/usr/bin/sh

if [ $BLOCK_BUTTON -eq 1 ]; then
    wpctl set-mute @DEFAULT_SOURCE@ toggle
elif [ $BLOCK_BUTTON -eq 4 ]; then
    wpctl set-volume @DEFAULT_SOURCE@ 5%+
elif [ $BLOCK_BUTTON -eq 5 ]; then
    wpctl set-volume @DEFAULT_SOURCE@ 5%-
fi
MIC=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | cut -c 9-)
echo " $MIC" | cut -c -8
echo " $MIC" | cut -c -8
echo "$MIC" | awk '{if (NF >=2) exit 0; else exit 1}' && echo "#586048"
exit 0
