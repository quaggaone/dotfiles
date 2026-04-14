#!/usr/bin/env bash

# ============================================================================
# sketchybar AeroSpace shared functions
# ============================================================================
# this file contains reusable functions for the AeroSpace integration.
# sourced by both the event handler and individual workspace scripts.
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
# build_icon_strip
# ============================================================================
# queries aerospace for all windows in a workspace and builds a space-prefixed
# string of app font ligatures, rendered as icons by sketchybar-app-font
# (e.g. " :safari::ghostty:" where each :name: is rendered as an icon glyph).
#
# arguments:
#   $1 - workspace ID
#
# returns:
#   space-prefixed ligature string, or "" if no windows

build_icon_strip() {
  local apps icon_strip

  apps=$(aerospace list-windows --workspace "$1" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  if [ "${apps}" != "" ]; then
    icon_strip=" "
    while read -r app; do
      icon_strip+="$($CONFIG_DIR/plugins/map_app_icon.sh "$app")"
    done <<< "${apps}"
  else
    icon_strip=""
  fi

  echo "$icon_strip"
}

# ============================================================================
# build_workspace_label
# ============================================================================
# converts a raw icon strip into a display-ready label.
# returns the icon strip unchanged if non-empty, or a dash indicator if empty.
#
# arguments:
#   $1 - icon strip (output of build_icon_strip, may be empty)
#
# returns:
#   icon strip if non-empty, or " —" if empty

build_workspace_label() {
  if [ -n "$1" ]; then
    echo "$1"
  else
    echo " —"
  fi
}

# ============================================================================
# resolve_workspace_state
# ============================================================================
# determines the display state for a workspace and sets LABEL and PROPERTIES.
# called once per workspace inside reload_workspace_icon.
#
# arguments:
#   $1 - workspace ID
#   $2 - display label (output of build_workspace_label)
#   $3 - icon strip (output of build_icon_strip; empty string means no windows)
#   $4 - currently focused workspace ID
#
# sets (accessible to caller):
#   LABEL      - passed through from $2 unchanged
#   PROPERTIES - sketchybar property array to apply
#
# resolves one of two states:
#   show: workspace has apps (non-empty icon strip), or is empty but focused
#   hide: workspace is empty and not focused (dash label set but item invisible)

resolve_workspace_state() {
  local workspace_id="$1"
  local label="$2"
  local icon_strip="$3"
  local focused_workspace="$4"

  local background_color
  if [ "$workspace_id" = "$focused_workspace" ]; then
    background_color=$COLOR_80
  else
    background_color=$COLOR_80_TRANSPARENT
  fi

  # icon.drawing and label.drawing are set explicitly rather than using the top-level
  # drawing property; the global one bypasses animation, making transitions abrupt.
  # specific properties animate correctly, resulting in smoother show/hide transitions.
  local properties_show=(
    background.color=$background_color
    icon.drawing=on
    label.drawing=on
    icon.padding_left=$PADDING_OUTER
    icon.padding_right=$PADDING_INNER
    label.padding_left=0
    label.padding_right=10
    padding_left=$MARGIN
    padding_right=$MARGIN
  )

  local properties_hide=(
    background.color=$background_color
    icon.drawing=off
    label.drawing=off
    icon.padding_left=0
    icon.padding_right=0
    label.padding_left=0
    label.padding_right=0
    padding_left=0
    padding_right=0
  )

  LABEL="$label"

  if [ -n "$icon_strip" ] || [ "$workspace_id" = "$focused_workspace" ]; then
    PROPERTIES=("${properties_show[@]}")
  else
    PROPERTIES=("${properties_hide[@]}")
  fi
}

# ============================================================================
# reload_workspace_icon
# ============================================================================
# updates the sketchybar display for one or more workspaces in a single call.
# acts as the orchestrator: calls each function independently, stores results
# in local vars, and passes everything explicitly to the next step.
#
# arguments:
#   "$@" - one or more workspace IDs (e.g. "1", or $AEROSPACE_WORKSPACES)
#
# behavior:
#   - queries the focused workspace once before iterating
#   - for each workspace: builds icon strip and label, resolves display state
#   - batches all --set commands into a single sketchybar call
#
# usage:
#   reload_workspace_icon "1"
#   reload_workspace_icon $AEROSPACE_WORKSPACES

reload_workspace_icon() {
  # query focused workspace once, reused across all iterations by resolve_workspace_state.
  # falls back to querying aerospace directly if AEROSPACE_FOCUSED_WORKSPACE is not set.
  local focused_workspace="${AEROSPACE_FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

  # accumulate --set flags for all workspaces into one batched sketchybar call
  local sketchybar_cmd=(sketchybar --animate sin 5)

  for workspace_id in "$@"; do
    local icon_strip workspace_label
    icon_strip=$(build_icon_strip "$workspace_id")
    workspace_label=$(build_workspace_label "$icon_strip")

    resolve_workspace_state "$workspace_id" "$workspace_label" "$icon_strip" "$focused_workspace"
    # resolve_workspace_state sets LABEL and PROPERTIES

    sketchybar_cmd+=(--set "space.$workspace_id" label="$LABEL" "${PROPERTIES[@]}")
  done

  "${sketchybar_cmd[@]}"
}
