#!/usr/bin/sh

RX=$(cat /sys/class/net/wlan0/statistics/rx_bytes)
TX=$(cat /sys/class/net/wlan0/statistics/tx_bytes)
echo "↓${RX%${RX: -6}}M ↑${TX%${TX: -6}}M"
echo "↓${RX%${RX: -6}}M ↑${TX%${TX: -6}}M"
if ping -c1 -W1 1.1.1.1 > /dev/null 2>&1; then
    if ping -c1 -w1 10.2.0.2 > /dev/null 2>&1; then
        echo "#a6cf88";
        exit 0;
    fi
    exit 0;
else echo "#586048"
fi
exit 0
