#!/bin/sh
CLASS="FloatingVim"
FILE="/tmp/clip.md"

EXISTING="$(hyprctl clients -j | jq -r '.[] | select(.class=="'"$CLASS"'") | .address' | head -n1)"

if [ -n "$EXISTING" ]; then
  hyprctl dispatch focuswindow "address:$EXISTING"
else
  kitty --class "$CLASS" nvim "$FILE"
fi

if [[ -e "$FILE" ]]; then
    head -c -1 "$FILE" | wl-copy
    notify-send -t 1000 copied
    rm -f "$FILE"
fi
