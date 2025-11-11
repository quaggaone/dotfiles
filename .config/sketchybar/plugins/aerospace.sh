#!/usr/bin/env bash

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

  # determine if this workspace is focused
  if [ "$1" = "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
    BG_DRAWING="on"
  else
    BG_DRAWING="off"
  fi

  # check icon_strip to determine if the workspace is empty
  # if it is not empty: animate item, set icon_strip and display the space indicator
  # if it is empty but focused: show with dash
  # if it is empty and not focused: hide the space indicator
  if [ "${icon_strip}" != "" ]; then
    sketchybar --animate sin 10 \
               --set space.$1 label="$icon_strip" \
                              background.drawing=$BG_DRAWING \
                              display=1
  elif [ "$1" = "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
    sketchybar --animate sin 10 \
               --set space.$1 label=" —" \
                              background.drawing=$BG_DRAWING \
                              display=1
  else
    sketchybar --animate sin 10 \
               --set space.$1 background.drawing=$BG_DRAWING \
                              display=0
  fi
}

if [ "$SENDER" = "aerospace_workspace_change" ]; then

  reload_workspace_icon "$AEROSPACE_PREV_WORKSPACE"
  reload_workspace_icon "$AEROSPACE_FOCUSED_WORKSPACE"

fi
