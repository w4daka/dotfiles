#!/bin/bash -u

FLOAT_CLASS="Floaterm"
CLIP_FILE="/tmp/clip"

# wezterm 内の PATH を通す (mise / local bin)
export MISE_DATA_DIR="$HOME/.local/share/mise"
export PATH="$HOME/.local/bin:$MISE_DATA_DIR/bin:$MISE_DATA_DIR/shims:$PATH"
eval "$($HOME/.local/bin/mise activate bash)"

# i3 で既存 Floaterm を検索
FloatingVim=$(i3-msg -t get_tree \
  | jq -c '.. | objects | select(.window_properties? != null) | select(.window_properties.class=="'"$FLOAT_CLASS"'")')

if [ -z "$FloatingVim" ]; then
  # 起動していなければ wezterm + nvim で /tmp/clip を開く
  wezterm start --class "$FLOAT_CLASS" nvim "$CLIP_FILE"
else
  # 起動済みなら scratchpad に送る or フォーカス
  FOCUSED=$(echo "$FloatingVim" | jq '.[0].focused')
  if [ "$FOCUSED" = "true" ]; then
    i3-msg "[class=\"$FLOAT_CLASS\"] move scratchpad"
  else
    i3-msg "[class=\"$FLOAT_CLASS\"] focus"
  fi
fi

# コピー処理
if [[ -e "$CLIP_FILE" ]]; then
  head -c -1 "$CLIP_FILE" | xclip -selection clipboard
  notify-send -t 1000 copied
  rm -f "$CLIP_FILE"
fi
