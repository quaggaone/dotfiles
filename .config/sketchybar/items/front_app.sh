#!/bin/bash

sketchybar --add item front_app q \
           --set front_app icon.drawing=off \
           label.padding_left=$PADDING_OUTER \
           script="$PLUGIN_DIR/front_app.sh" \
           background.color=$COLOR_80 \
           label.color=$COLOR_10 \
           --subscribe front_app front_app_switched
