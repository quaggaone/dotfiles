#!/bin/bash

sketchybar --add alias "Control Center,Battery" right \
           --set "Control Center,Battery" update_freq=120 script="$PLUGIN_DIR/battery.sh" \
           --subscribe "Control Center,Battery" system_woke power_source_change
