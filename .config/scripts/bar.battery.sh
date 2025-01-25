#!/usr/bin/sh

BAT=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status)
echo "$BAT%"
echo "$BAT%"
[ "$STATUS" = "Charging" ] && [ $BAT -ge 80 ] && exit 33
[ "$STATUS" = "Charging" ] && echo "#a6cf88" && exit 0
[ $BAT -le 25 ] && exit 33
[ $BAT -le 40 ] && echo "#f18e91"
exit 0
