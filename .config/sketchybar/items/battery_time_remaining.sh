#!/bin/bash

sketchybar --add item battery-time-remaining right \
           --set battery-time-remaining update_freq=60 script="$PLUGIN_DIR/battery_time_remaining.sh" \
           --subscribe battery-time-remaining system_woke power_source_change
