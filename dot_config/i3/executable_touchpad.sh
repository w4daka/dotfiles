#!/usr/bin/env bash

DEVICE="VEN_04F3:00 04F3:32EB Touchpad"

state=$(xinput list-props "$DEVICE" | grep "Device Enabled" | awk '{print $4}')

# 初期状態は無効にしたい → ONならOFFに、OFFならONにしない
if [ "$state" = "1" ]; then
    xinput disable "$DEVICE"
else
    xinput enable "$DEVICE"
fi
