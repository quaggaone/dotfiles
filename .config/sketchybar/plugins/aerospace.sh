#!/usr/bin/env bash

if [ "$1" = "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on
else
    sketchybar --set $NAME background.drawing=off
fi

reload_workspace_icon() {
  apps=$(aerospace list-windows --workspace "$1" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      icon_strip+="$($CONFIG_DIR/plugins/map_app_icon.sh "$app")"
    done <<< "${apps}"
  else
    icon_strip=""
  fi

  # check icon_strip to determine if the workspace is empty
  # if it is not empty: animate item, set icon_strip and display the space indicator
  # if it is empty: hide the space indicator and don’t bother about the rest
  if [ "${icon_strip}" != "" ]; then
    sketchybar --animate sin 10 \
               --set space.$1 label="$icon_strip" \
                              display=1
  else
    sketchybar --set space.$1 display=0
  fi
}

if [ "$SENDER" = "aerospace_workspace_change" ]; then

  reload_workspace_icon "$AEROSPACE_PREV_WORKSPACE"
  reload_workspace_icon "$AEROSPACE_FOCUSED_WORKSPACE"

fi
