#!/bin/bash

# Monitor watcher - detects when monitors are plugged/unplugged
# and automatically moves windows back to the main screen

STATE_FILE="/tmp/i3_monitors_state"

# Initialize state file
xrandr | grep " connected" > "$STATE_FILE"

while true; do
	sleep 2
	
	# Get current monitor state
	xrandr | grep " connected" > "${STATE_FILE}.new"
	
	# Compare with previous state
	if ! cmp -s "$STATE_FILE" "${STATE_FILE}.new"; then
		echo "Monitor change detected at $(date)"
		
		# Run the monitor change handler
		~/.config/i3/monitor_change_handler.sh
		
		# Update state
		mv "${STATE_FILE}.new" "$STATE_FILE"
	else
		rm -f "${STATE_FILE}.new"
	fi
done
