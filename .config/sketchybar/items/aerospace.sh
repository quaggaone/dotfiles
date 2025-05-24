#!/bin/bash

# heavily inspired by: https://github.com/forteleaf/sketkchybar-with-aerospace
# specifically this file: https://github.com/forteleaf/sketkchybar-with-aerospace/blob/main/sketchybar/items/spaces.sh

for m in $(aerospace list-monitors | awk '{print $1}'); do
  for i in $(aerospace list-workspaces --monitor $m); do
    sid=$i
    space=(
      space="$sid"
      icon="$sid"
      icon.font="SF Pro:Expanded Medium:14.0"
      icon.padding_left=$PADDING_OUTER
      icon.padding_right=$PADDING_OUTER
      display=$m
      padding_left=$MARGIN
      padding_right=$MARGIN
      label.padding_right=$PADDING_OUTER
      label.color=$WHITE
      label.font="sketchybar-app-font:Regular:16.0"
      label.y_offset=-1
      background.color=$COLOR_80
      background.border_color=$COLOR_60
      script="$PLUGIN_DIR/aerospace.sh $sid"
    )

    sketchybar --add space space.$sid left \
               --set space.$sid "${space[@]}" \
               --subscribe space.$sid aerospace_workspace_change

    apps=$(aerospace list-windows --workspace $sid | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

    icon_strip=" "
    if [ "${apps}" != "" ]; then
      while read -r app
      do
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
      done <<< "${apps}"
    else
      icon_strip=" —"
    fi

    sketchybar --set space.$sid label="$icon_strip"
  done

# added flag `--empty no` to first list-workspaces command to reduce lines of code
  for i in $(aerospace list-workspaces --monitor $m --empty); do
    sketchybar --set space.$i display=0
  done

done
