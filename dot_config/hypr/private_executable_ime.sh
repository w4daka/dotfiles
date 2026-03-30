#!/bin/bash -u

FLOAT_CLASS="Floaterm"
CLIP_FILE="/tmp/clip"

# neovim: nix管理 → PATH追加不要
# wezterm: pacman管理 → PATH追加不要

EXISTING=$(hyprctl clients -j | jq -r '.[] | select(.class=="'$FLOAT_CLASS'") | .address')

if [ -z "$EXISTING" ]; then
    wezterm start --class "$FLOAT_CLASS" nvim "$CLIP_FILE"
else
    hyprctl dispatch focuswindow "class:$FLOAT_CLASS"
fi

if [[ -e "$CLIP_FILE" ]]; then
    head -c -1 "$CLIP_FILE" | wl-copy
    notify-send -t 1000 copied
    rm -f "$CLIP_FILE"
fi
