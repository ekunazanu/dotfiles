if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] ; then
    sway
fi
