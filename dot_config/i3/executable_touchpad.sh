#!/usr/bin/env bash

DEVICE="VEN_04F3:00 04F3:32EB Touchpad"

state=$(xinput list-props "$DEVICE" | grep "libinput Send Events Mode Enabled" | awk '{print $5}')

if [ "$state" = "1," ]; then
    xinput set-prop "$DEVICE" "libinput Send Events Mode Enabled" 0 0
else
    xinput set-prop "$DEVICE" "libinput Send Events Mode Enabled" 0 1
fi
