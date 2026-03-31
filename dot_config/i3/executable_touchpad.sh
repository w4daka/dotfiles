#!/usr/bin/env bash
set -euo pipefail

DEVICE_NAME='VEN_04F3:00 04F3:32EB Touchpad'
MODE="${1:-off}"   # off | on | toggle | status
DEBUG="${DEBUG:-0}"

# 1つ目のIDだけ使う（複数返る環境対策）
DEVICE_ID="$(xinput list --id-only "$DEVICE_NAME" 2>/dev/null | head -n1 || true)"
if [ -z "$DEVICE_ID" ]; then
  echo "touchpad not found: $DEVICE_NAME" >&2
  exit 1
fi

props="$(xinput list-props "$DEVICE_ID" 2>/dev/null || true)"
if [ "$DEBUG" = "1" ]; then
  echo "[debug] id=$DEVICE_ID" >&2
  echo "[debug] props(head):" >&2
  printf '%s\n' "$props" | head -n 20 >&2
fi

# "Device Enabled (180):  1" の末尾の 0/1 だけ取る
enabled="$(
  printf '%s\n' "$props" \
    | grep -m1 -E '^[[:space:]]*Device Enabled \(' \
    | sed -E 's/.*:[[:space:]]*([01])[[:space:]]*$/\1/'
)"

# 行が取れなかった or 変換できなかったケースを明確化
if [ -z "${enabled:-}" ] || { [ "$enabled" != "0" ] && [ "$enabled" != "1" ]; }; then
  echo "Device Enabled property not found or unparsable for id=$DEVICE_ID" >&2
  if [ "$DEBUG" = "1" ]; then
    echo "[debug] raw Device Enabled line:" >&2
    printf '%s\n' "$props" | grep -n -E 'Device Enabled|libinput Send Events' >&2 || true
  fi
  exit 1
fi

case "$MODE" in
  off)
    xinput set-prop "$DEVICE_ID" "Device Enabled" 0
    ;;
  on)
    xinput set-prop "$DEVICE_ID" "Device Enabled" 1
    ;;
  toggle)
    if [ "$enabled" = "1" ]; then
      xinput set-prop "$DEVICE_ID" "Device Enabled" 0
    else
      xinput set-prop "$DEVICE_ID" "Device Enabled" 1
    fi
    ;;
  status)
    if [ "$enabled" = "1" ]; then
      echo "on"
    else
      echo "off"
    fi
    ;;
  *)
    echo "usage: $0 [off|on|toggle|status]" >&2
    exit 2
    ;;
esac
