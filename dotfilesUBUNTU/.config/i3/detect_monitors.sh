#!/bin/bash

# 1. Get list of connected monitors
connected_monitors=$(xrandr --query | grep " connected" | cut -d" " -f1)
primary_monitor=$(xrandr --query | grep " connected primary" | cut -d" " -f1)

# Default fallback
MAIN=$primary_monitor
SIDE=$primary_monitor

# 2. Logic: If we have 2 monitors, assign the non-primary to SIDE
# (Assumes you set the 4K screen as Primary in ARandR)
count=$(echo "$connected_monitors" | wc -l)

if [ "$count" -gt 1 ]; then
	# Find the monitor that ISN'T the primary one
	for m in $connected_monitors; do
		if [ "$m" != "$primary_monitor" ]; then
			SIDE=$m
		fi
	done
fi

# 3. Write to the config file
echo "set \$main $MAIN" >~/.config/i3/monitors.conf
echo "set \$side $SIDE" >>~/.config/i3/monitors.conf

# 4. Reload i3 to apply changes (only if called manually, to avoid loops)
if [ "$1" == "reload" ]; then
	i3-msg reload
fi
