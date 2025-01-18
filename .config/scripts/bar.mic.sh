#!/usr/bin/sh

MIC=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | cut -c 9-)
echo " $MIC" | cut -c -8
echo " $MIC" | cut -c -8
echo "$MIC" | awk '{if (NF >=2) exit 0; else exit 1}' && echo "#586048"
exit 0
