#!/usr/bin/sh

TEMP=$(cat /sys/class/thermal/thermal_zone0/temp | cut -c -2)
echo "$TEMP°C"
echo "$TEMP°C"
[ $TEMP -ge 60 ] && exit 33
[ $TEMP -ge 50 ] && echo "#f18e91"
exit 0
