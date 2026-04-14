#!/bin/bash

# heavily inspired by: https://github.com/forteleaf/sketkchybar-with-aerospace
# specifically this file: https://github.com/forteleaf/sketkchybar-with-aerospace/blob/main/sketchybar/items/spaces.sh

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/padding.sh"
source "$CONFIG_DIR/utils/aerospace-functions.sh"

# iterate over each monitor and register its workspaces as sketchybar space items.
# items are structural only; labels, icons, and visibility are set after creation
# by reload_workspace_icon, which queries aerospace and fires a single batched update.
for m in $(aerospace list-monitors | awk '{print $1}'); do
  monitor_workspace_ids=()
  sketchybar_cmd=(sketchybar)

  for i in $(aerospace list-workspaces --monitor $m --format "%{workspace}-%{monitor-appkit-nsscreen-screens-id}"); do
    # custom aerospace list-workspaces format is required to make sketchybar monitor ids match up
    # sid is space-id and mid is monitor-id seperated from aerospace output
    sid=$(echo $i | awk -F'-' '{gsub(/^ *| *$/, "", $1); print $1}')
    mid=$(echo $i | awk -F'-' '{gsub(/^ *| *$/, "", $2); print $2}')

    monitor_workspace_ids+=("$sid")

    space=(
      space="$sid"
      icon="$sid"
      icon.color=$WHITE
      icon.font="SF Pro:Expanded Medium:14.0"
      icon.padding_left=$PADDING_OUTER
      icon.padding_right=$PADDING_INNER
      display=$mid
      icon.drawing=off   # specific drawing props used intentionally (see resolve_workspace_state)
      label.drawing=off
      padding_left=$MARGIN
      padding_right=$MARGIN
      label.padding_left=0
      label.padding_right=10
      label.color=$WHITE
      label.font="sketchybar-app-font:Regular:16.0"
      label.y_offset=-1
      background.color=$COLOR_80_TRANSPARENT
      background.border_color=$COLOR_60
      background.drawing=on
      script="$CONFIG_DIR/plugins/aerospace.sh $sid"
      click_script="aerospace workspace $sid"
    )

    sketchybar_cmd+=(--add space "space.$sid" left --set "space.$sid" "${space[@]}")
  done

  # register all workspace items for this monitor in one batched call
  "${sketchybar_cmd[@]}"

  # set initial display state for all workspaces on this monitor in one call
  reload_workspace_icon "${monitor_workspace_ids[@]}"

done
