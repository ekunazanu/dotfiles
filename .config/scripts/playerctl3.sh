#!/usr/bin/env bash

playerctl metadata --format '{{ title }}{{ status }}' --follow | ad | kill -s 38 "$(pgrep waybar)"
