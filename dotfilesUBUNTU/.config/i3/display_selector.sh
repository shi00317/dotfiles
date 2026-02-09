#!/bin/bash
options="auto\n$(autorandr --list)"
selected=$(echo -e "$options" | rofi -dmenu -i -p " 🖥️ Display Profile ")

if [ -n "$selected" ]; then
  if [ "$selected" == "auto" ]; then
    autorandr --change
  else
    autorandr --load "$selected"
  fi

  # Update monitor variables for i3
  ~/.config/i3/detect_monitors.sh

  # Reload configs
  xrdb -merge ~/.Xresources
  i3-msg restart
  ~/.config/polybar/launch.sh
  feh --bg-scale /usr/share/backgrounds/warty-final-ubuntu.png
  notify-send "Display Profile" "Switched to: $selected"
fi
