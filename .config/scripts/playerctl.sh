#!/usr/bin/env sh

echo '{"text": "'$(playerctl metadata --format "{{ title }}")'", "alt": "'$(playerctl status)'", "class": "'$(playerctl status)'"}'
