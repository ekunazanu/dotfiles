#!/usr/bin/env sh

AVAILABLE_NETWORKS=$(iwctl station wlan0 scan && iwctl station wlan0 get-networks | awk '{print $1}' | tail -n +6)

if [ -z "$AVAILABLE_NETWORKS" ]; then
    notify-send -u normal -a "Wifi" "No networks found"
    exit 1
fi

SELECTED_NETWORK=$(echo "$AVAILABLE_NETWORKS" | tofi --prompt-text "wifi network:")

if [ "$SELECTED_NETWORK" = "disconnect" ]; then
    iwctl station wlan0 disconnect
    notify-send -u normal -a "Wifi" "Disconnected" "Disconnected from current network"
    exit 0
fi

if [ -z "$SELECTED_NETWORK" ]; then
    notify-send -u normal -a "Wifi" "No network selected" "No network was selected"
    exit 1
fi

NETWORK_SECURITY=$(iwctl station wlan0 get-networks | grep "$SELECTED_NETWORK" | awk '{print $2}')
IS_KNOWN=$(iwctl known-networks list | grep -q "$SELECTED_NETWORK")

if [ "$NETWORK_SECURITY" = "psk" ] && [ -z "$IS_KNOWN" ]; then
    PASSWORD=$(tofi </dev/null --prompt-text "password:")
    iwctl --passphrase="$PASSWORD" station wlan0 connect "$SELECTED_NETWORK"
else
    iwctl station wlan0 connect "$SELECTED_NETWORK"
fi

CONNECTED_NETWORK=$(iwctl station wlan0 show | grep -i "connected network" | awk '{print $3}')

if [ -n "$CONNECTED_NETWORK" ]; then
    notify-send -u normal -t 5000 -a "Wifi" "Connected" "Successfully connected to $CONNECTED_NETWORK"
else
    notify-send -u normal -t 5000 -a "Wifi" "Error" "Failed to connect to $SELECTED_NETWORK"
fi
