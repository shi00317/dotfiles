#!/bin/bash

# This script handles monitor hotplug events
# It moves all windows from disconnected monitors back to the main screen

# Get current connected monitors
connected_monitors=$(xrandr --query | grep " connected" | cut -d" " -f1)
primary_monitor=$(xrandr --query | grep " connected primary" | cut -d" " -f1)

# Get all workspaces and their current outputs
workspaces=$(i3-msg -t get_workspaces | jq -r '.[] | "\(.name):\(.output)"')

# Check each workspace
echo "$workspaces" | while IFS=: read -r ws_name ws_output; do
	# If workspace is on a monitor that's no longer connected
	if ! echo "$connected_monitors" | grep -q "^${ws_output}$"; then
		echo "Moving workspace $ws_name from disconnected monitor $ws_output to $primary_monitor"
		i3-msg "workspace $ws_name; move workspace to output $primary_monitor" 2>/dev/null
	fi
done

# Run the detect_monitors script to update config
~/.config/i3/detect_monitors.sh
