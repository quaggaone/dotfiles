#!/usr/bin/env bash

# ============================================================================
# Sketchybar AeroSpace Integration Plugin
# ============================================================================
# This script is called by sketchybar when workspace changes occur.
#
# HOW IT WORKS:
# 1. Each workspace item subscribes to "aerospace_workspace_change" event
# 2. When AeroSpace triggers the event, sketchybar calls this script ONCE per
#    subscribed workspace item, passing the workspace ID as $1
# 3. AeroSpace also passes AEROSPACE_FOCUSED_WORKSPACE and AEROSPACE_PREV_WORKSPACE
#    as environment variables in the event trigger
# 4. We use early exit optimization: only process if this workspace is involved
#    in the change (either the previously focused or newly focused workspace)
#
# PERFORMANCE:
# - Without early exit: ~10 full executions per workspace change (~100ms)
# - With early exit: 8 instant exits + 2 full executions (~21ms)
# ============================================================================

# Error handling and logging
LOG_FILE="$HOME/.config/sketchybar/aerospace-error.log"

log_error() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR: $1" >> "$LOG_FILE"
}

# ============================================================================
# Dependency Checks
# ============================================================================

# Check if CONFIG_DIR is set
if [ -z "$CONFIG_DIR" ]; then
  log_error "CONFIG_DIR is not set"
  exit 1
fi

# Source required files with error handling
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
# Early Exit Optimization
# ============================================================================
# This workspace ($1) is only involved in the change if it's either:
# - The previously focused workspace (needs to remove highlight)
# - The newly focused workspace (needs to add highlight)
# Exit early if this workspace isn't involved to avoid unnecessary processing

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  # Check if this workspace is involved in the change
  if [ "$1" != "$AEROSPACE_FOCUSED_WORKSPACE" ] && [ "$1" != "$AEROSPACE_PREV_WORKSPACE" ]; then
    # Not involved in this change - exit immediately
    exit 0
  fi
fi

# ============================================================================
# Workspace Icon Reload Function
# ============================================================================
# Updates a single workspace's display based on its current state
# Arguments:
#   $1 - Workspace ID to reload
# Behavior:
#   - Queries aerospace for windows in the workspace
#   - Builds icon strip from app names (or shows dash if empty)
#   - Applies appropriate styling (highlight if focused, hide if empty+unfocused)

reload_workspace_icon() {
  # Get list of app names in this workspace
  apps=$(aerospace list-windows --workspace "$1" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  # Build icon strip from app names
  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      icon_strip+="$($CONFIG_DIR/plugins/map_app_icon.sh "$app")"
    done <<< "${apps}"
  else
    icon_strip=""  # Empty workspace
  fi

  # Determine background color based on focus state
  # Focused workspace gets visible background, others get transparent
  if [ "$1" = "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
    BACKGROUND_COLOR=$COLOR_80
  else
    BACKGROUND_COLOR=$COLOR_80_TRANSPARENT
  fi

  # Define property sets for showing and hiding workspaces
  # PROPERTIES_SHOW: Normal padding, drawings on (visible workspace)
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

  # PROPERTIES_HIDE: Zero padding, drawings off (collapsed to invisible)
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

  # Determine label and properties based on workspace state:
  # 1. Has apps: Show app icons
  # 2. Empty + focused: Show dash indicator
  # 3. Empty + unfocused: Collapse to invisible
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

  # Apply properties with animation (5 frames @ 60Hz = ~83ms)
  sketchybar --animate sin 5 --set space.$1 label="$LABEL" "${PROPERTIES[@]}"
}

# ============================================================================
# Main Event Handler
# ============================================================================
# When aerospace_workspace_change event fires:
# - Sketchybar calls this script for each subscribed workspace
# - We already filtered with early exit (only FOCUSED and PREV run)
# - Now we just need to reload THIS workspace ($1)

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  # Reload this workspace's display
  reload_workspace_icon "$1"
fi
