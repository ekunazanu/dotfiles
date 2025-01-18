#!/usr/bin/sh

VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -c 9-)
echo " $VOL" | cut -c -8
echo " $VOL" | cut -c -8
echo "$VOL" | awk '{if (NF >=2) exit 0; else exit 1}' && echo "#586048"
exit 0
