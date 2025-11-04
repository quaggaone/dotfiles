#!/bin/sh

source "$CONFIG_DIR/colors.sh"

TIME_REMAINING="$(pmset -g batt | grep -Eo "\d+:\d+ remaining" | cut -d' ' -f1)"


sketchybar --set "$NAME" icon.drawing=off \
                         drawing=on \
                         label="${TIME_REMAINING}" \
                         label.drawing=on
