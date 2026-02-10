#!/bin/bash

# 1. Get list of connected monitors
connected_monitors=$(xrandr --query | grep " connected" | cut -d" " -f1)
primary_monitor=$(xrandr --query | grep " connected primary" | cut -d" " -f1)

# Read previous monitor config if it exists
PREV_SIDE=""
if [ -f ~/.config/i3/monitors.conf ]; then
	PREV_SIDE=$(grep "set \$side" ~/.config/i3/monitors.conf | awk '{print $3}')
fi

# Default: both use primary (single monitor setup)
MAIN=$primary_monitor
SIDE=$primary_monitor

# 2. Logic: If we have 2 monitors, assign the non-primary to SIDE
count=$(echo "$connected_monitors" | wc -l)

if [ "$count" -gt 1 ]; then
	# Find the monitor that ISN'T the primary one
	for m in $connected_monitors; do
		if [ "$m" != "$primary_monitor" ]; then
			SIDE=$m
			break
		fi
	done
else
	# Single monitor mode: Move all windows from disconnected monitor to main
	if [ -n "$PREV_SIDE" ] && [ "$PREV_SIDE" != "$primary_monitor" ]; then
		# External monitor was disconnected, move all workspaces to main screen
		i3-msg "[workspace=__focused__]" move workspace to output $primary_monitor 2>/dev/null
		# Move all workspaces that were on the side monitor
		for ws in 6 7 8 9; do
			i3-msg "workspace $ws; move workspace to output $primary_monitor" 2>/dev/null
		done
	fi
fi

# 3. Write to the config file
echo "set \$main $MAIN" >~/.config/i3/monitors.conf
echo "set \$side $SIDE" >>~/.config/i3/monitors.conf

# 4. Reload i3 to apply changes (only if called manually, to avoid loops)
if [ "$1" == "reload" ]; then
	i3-msg reload
fi
