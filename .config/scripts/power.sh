swaynag -t message -m "Power Menu Options" -Z "Lock" "swaylock" -Z "Suspend" "systemctl suspend -i" -Z "Logout" "swaymsg exit" -Z "Reboot" "systemctl reboot -i" -Z "Shutdown" "systemctl poweroff -i"
