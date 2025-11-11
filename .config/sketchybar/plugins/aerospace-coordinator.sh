#!/usr/bin/env bash

# ============================================================================
# sketchybar AeroSpace coordinator
# ============================================================================
# this script coordinates AeroSpace workspace change events.
# it runs ONCE per event and updates only the affected workspaces.
#
# WHY A COORDINATOR:
# - without coordinator: sketchybar calls the script once per subscribed item
#   (10 workspaces = 10 executions, even with early exit optimization)
# - with coordinator: runs exactly once, updates only PREV and FOCUSED
#   (2 workspace updates per event)
#
# ADDING NEW EVENTS:
# to handle additional AeroSpace events (window moved, workspace created, etc.):
# 1. add the event in sketchybarrc: sketchybar --add event <event_name>
# 2. subscribe coordinator: --subscribe aerospace.coordinator <event_name>
# 3. add elif clause below with appropriate workspace IDs to reload
# 4. ensure AeroSpace config passes required env vars to the event trigger
# ============================================================================

# source shared functions
source "$CONFIG_DIR/utils/aerospace-functions.sh"

# ============================================================================
# event handler
# ============================================================================

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  # requires AeroSpace config to pass AEROSPACE_FOCUSED_WORKSPACE and AEROSPACE_PREV_WORKSPACE
  # example in aerospace.toml:
  #   exec-on-workspace-change = [
  #     '/bin/bash', '-c',
  #     'sketchybar --trigger aerospace_workspace_change AEROSPACE_FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE AEROSPACE_PREV_WORKSPACE=$AEROSPACE_PREV_WORKSPACE'
  #   ]

  reload_workspace_icon "$AEROSPACE_PREV_WORKSPACE"
  reload_workspace_icon "$AEROSPACE_FOCUSED_WORKSPACE"
fi

# future event handlers can be added here as elif clauses
# example:
# elif [ "$SENDER" = "aerospace_window_moved" ]; then
#   reload_workspace_icon "$AEROSPACE_MOVED_FROM_WORKSPACE"
#   reload_workspace_icon "$AEROSPACE_MOVED_TO_WORKSPACE"
# fi
