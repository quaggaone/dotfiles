#!/bin/bash

# heavily inspired by: https://github.com/forteleaf/sketkchybar-with-aerospace
# specifically this file: https://github.com/forteleaf/sketkchybar-with-aerospace/blob/main/sketchybar/items/spaces.sh

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/padding.sh"
source "$CONFIG_DIR/utils/aerospace-functions.sh"

# get currently focused workspace on startup
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

for m in $(aerospace list-monitors | awk '{print $1}'); do
  for i in $(aerospace list-workspaces --monitor $m --format "%{workspace}-%{monitor-appkit-nsscreen-screens-id}"); do
    # custom aerospace list-workspaces format is required to make sketchybar monitor ids match up
    # sid is space-id and mid is monitor-id seperated from aerospace output
    sid=$(echo $i | awk -F'-' '{gsub(/^ *| *$/, "", $1); print $1}')
    mid=$(echo $i | awk -F'-' '{gsub(/^ *| *$/, "", $2); print $2}')

    # set background color based on if this is the focused workspace
    if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
      BG_COLOR=$COLOR_80
    else
      BG_COLOR=$COLOR_80_TRANSPARENT
    fi

    space=(
      space="$sid"
      icon="$sid"
      icon.color=$WHITE
      icon.font="SF Pro:Expanded Medium:14.0"
      icon.padding_left=$PADDING_OUTER
      icon.padding_right=$PADDING_INNER
      display=$mid
      padding_left=$MARGIN
      padding_right=$MARGIN
      label.padding_left=0
      label.padding_right=10
      label.color=$WHITE
      label.font="sketchybar-app-font:Regular:16.0"
      label.y_offset=-1
      background.color=$BG_COLOR
      background.border_color=$COLOR_60
      background.drawing=on
      script="$CONFIG_DIR/plugins/aerospace.sh $sid"
      click_script="aerospace workspace $sid" \
    )

    # build icon strip from workspace apps
    # this uses a utils helper function
    icon_strip=$(build_icon_strip "$sid")

    # show dash for empty workspaces during initial setup
    if [ "${icon_strip}" = "" ]; then
      label=" —"
    else
      label="$icon_strip"
    fi


    sketchybar --add space space.$sid left \
               --set space.$sid "${space[@]}" \
               --set space.$sid label="$label"
  done

# added flag `--empty no` to first list-workspaces command to reduce lines of code
  for i in $(aerospace list-workspaces --monitor $m --empty); do
    sketchybar --animate sin 10 --set space.$i icon.padding_left=0 \
                                      icon.padding_right=0 \
                                      label.padding_left=0 \
                                      label.padding_right=0 \
                                      padding_left=0 \
                                      padding_right=0 \
                                      icon.drawing=off \
                                      label.drawing=off
  done

done
