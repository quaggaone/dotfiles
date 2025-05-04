#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

# sketchybar --set "$NAME" label="$(date '+%Y-%m-%d – %H:%M %z')"

if [ "$NAME" = "date" ]; then
    # sketchybar --set "$NAME" label="$(date '+%a, %d %b %Y')"
    sketchybar --set "$NAME" label="$(date '+%Y-%m-%d %a')"
elif [ "$NAME" = "time" ]; then
    sketchybar --set "$NAME" label="$(date '+%H:%M')"
elif [ "$NAME" = "timezone" ]; then
    sketchybar --set "$NAME" label="$(date '+%z')"
fi

# sketchybar --set "$NAME" label="$(date '+%a, %d %b %Y %H:%M %z')"
