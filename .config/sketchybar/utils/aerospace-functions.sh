#!/usr/bin/env bash

# ============================================================================
# sketchybar AeroSpace shared functions
# ============================================================================
# this file contains reusable functions for the AeroSpace integration.
# sourced by both the coordinator and individual workspace scripts.
# ============================================================================

# error handling and logging
LOG_FILE="$HOME/.config/sketchybar/aerospace-error.log"

log_error() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR: $1" >> "$LOG_FILE"
}

# ============================================================================
# dependency loading
# ============================================================================

# check if CONFIG_DIR is set
if [ -z "$CONFIG_DIR" ]; then
  log_error "CONFIG_DIR is not set"
  exit 1
fi

# source required configuration files
if [ -f "$CONFIG_DIR/colors.sh" ]; then
  source "$CONFIG_DIR/colors.sh"
else
  log_error "colors.sh not found at $CONFIG_DIR/colors.sh"
  exit 1
fi

if [ -f "$CONFIG_DIR/padding.sh" ]; then
  source "$CONFIG_DIR/padding.sh"
else
  log_error "padding.sh not found at $CONFIG_DIR/padding.sh"
  exit 1
fi

# ============================================================================
# workspace icon reload function
# ============================================================================
# updates a single workspace's display based on its current state
# arguments:
#   $1 - workspace ID to reload
# behavior:
#   - queries aerospace for windows in the workspace
#   - builds icon strip from app names (or shows dash if empty)
#   - applies appropriate styling (highlight if focused, hide if empty+unfocused)

reload_workspace_icon() {
  # get list of app names in this workspace
  apps=$(aerospace list-windows --workspace "$1" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  # build icon strip from app names
  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      icon_strip+="$($CONFIG_DIR/plugins/map_app_icon.sh "$app")"
    done <<< "${apps}"
  else
    icon_strip=""  # empty workspace
  fi

  # determine background color based on focus state
  # focused workspace gets visible background, others get transparent
  if [ "$1" = "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
    BACKGROUND_COLOR=$COLOR_80
  else
    BACKGROUND_COLOR=$COLOR_80_TRANSPARENT
  fi

  # define property sets for showing and hiding workspaces
  # PROPERTIES_SHOW: normal padding, drawings on (visible workspace)
  PROPERTIES_SHOW=(
    background.color=$BACKGROUND_COLOR
    icon.drawing=on
    label.drawing=on
    icon.padding_left=$PADDING_OUTER
    icon.padding_right=$PADDING_INNER
    label.padding_left=0
    label.padding_right=10
    padding_left=$MARGIN
    padding_right=$MARGIN
  )

  # PROPERTIES_HIDE: zero padding, drawings off (collapsed to invisible)
  PROPERTIES_HIDE=(
    background.color=$BACKGROUND_COLOR
    icon.drawing=off
    label.drawing=off
    icon.padding_left=0
    icon.padding_right=0
    label.padding_left=0
    label.padding_right=0
    padding_left=0
    padding_right=0
  )

  # determine label and properties based on workspace state:
  # 1. has apps: show app icons
  # 2. empty + focused: show dash indicator
  # 3. empty + unfocused: collapse to invisible
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

  # apply properties with animation (5 frames @ 60Hz = ~83ms)
  sketchybar --animate sin 5 --set space.$1 label="$LABEL" "${PROPERTIES[@]}"
}
