#!/bin/bash

sketchybar --add item time right \
    --set time update_freq=1 script="$PLUGIN_DIR/clock.sh" \
        background.color=$COLOR_80 \
        label.color=$COLOR_10 \
        label.padding_left=$PADDING_OUTER \
        icon.drawing=off \
    --add item date right \
    --set date update_freq=30 script="$PLUGIN_DIR/clock.sh" \
        icon.drawing=off \
        label.padding_left=$PADDING_OUTER

# --add item timezone right \
#     --set timezone update_freq=600 script="$PLUGIN_DIR/clock.sh" \
#         icon.drawing=off \
#         label.padding_left=10 \
