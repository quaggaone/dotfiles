#!/usr/bin/env bash

source "$CONFIG_DIR/padding.sh"

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
    BACKGROUND_DRAWING="on"
  else
    BACKGROUND_DRAWING="off"
  fi

  # define property sets for showing and hiding workspaces
  PROPERTIES_SHOW=(
    background.drawing=$BACKGROUND_DRAWING
    icon.drawing=on
    label.drawing=on
    icon.padding_left=$PADDING_OUTER
    icon.padding_right=$PADDING_INNER
    label.padding_left=0
    label.padding_right=10
    padding_left=$MARGIN
    padding_right=$MARGIN
  )

  PROPERTIES_HIDE=(
    background.drawing=$BACKGROUND_DRAWING
    icon.drawing=off
    label.drawing=off
    icon.padding_left=0
    icon.padding_right=0
    label.padding_left=0
    label.padding_right=0
    padding_left=0
    padding_right=0
  )

  # determine label and properties based on workspace state
  if [ "${icon_strip}" != "" ]; then
    LABEL="$icon_strip"
    PROPERTIES=("${PROPERTIES_SHOW[@]}")
  elif [ "$1" = "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
    LABEL=" —"
    PROPERTIES=("${PROPERTIES_SHOW[@]}")
  else
    LABEL=""
    PROPERTIES=("${PROPERTIES_HIDE[@]}")
  fi

  # apply properties with animation
  sketchybar --animate sin 10 --set space.$1 label="$LABEL" "${PROPERTIES[@]}"
}

if [ "$SENDER" = "aerospace_workspace_change" ]; then

  reload_workspace_icon "$AEROSPACE_PREV_WORKSPACE"
  reload_workspace_icon "$AEROSPACE_FOCUSED_WORKSPACE"

fi
