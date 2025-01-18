#!/bin/sh

windows=$(swaymsg -t get_tree | jq -r 'recurse(.nodes[]?)|recurse(.floating_nodes[]?)|select(.type=="con"),select(.type=="floating_con")|(.id|tostring)+" "+.app_id+" "+.name')
selected=$(echo "$windows" | tofi | awk '{print $1}')
swaymsg [con_id="$selected"] focus
