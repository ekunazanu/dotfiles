#!/usr/bin/env bash

app="$(playerctl metadata --format {{playerName}})"
artist="$(playerctl metadata --format {{artist}})"
album="$(playerctl metadata --format {{album}})"
title="$(playerctl metadata --format {{title}})"

notify-send --urgency=normal --expire-time=5000 --app-name="$app" "$title" "$artist\n$album"
