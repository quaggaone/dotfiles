#!/usr/bin/env bash

# ============================================================================
# sketchybar AeroSpace event handler
# ============================================================================
# runs once per event and reloads all workspaces listed in AEROSPACE_WORKSPACES.
# callers pass whatever workspaces need refreshing as a space-separated list.
#
# WHY A DEDICATED EVENT HANDLER:
# - without event handler: sketchybar calls the script once per subscribed item
#   (10 workspaces = 10 executions, even with early exit optimization)
# - with event handler: runs exactly once, updates only affected workspaces
#
# ADDING NEW EVENTS:
# to handle additional AeroSpace events (window moved, workspace created, etc.):
# 1. add the event in sketchybarrc: sketchybar --add event <event_name>
# 2. subscribe event handler: --subscribe aerospace.event-handler <event_name>
# 3. add elif clause below with AEROSPACE_WORKSPACES set to affected workspaces
# 4. ensure AeroSpace config passes AEROSPACE_WORKSPACES to the event trigger
# ============================================================================

# source shared functions
source "$CONFIG_DIR/utils/aerospace-functions.sh"

# ============================================================================
# event handler
# ============================================================================

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  # AEROSPACE_WORKSPACES is a space-separated list of workspace IDs passed by the caller.
  # reload_workspace_icon loops internally and fires all updates in one sketchybar call.
  reload_workspace_icon $AEROSPACE_WORKSPACES
fi

# future event handlers can be added here as elif clauses
# example:
# elif [ "$SENDER" = "aerospace_window_moved" ]; then
#   reload_workspace_icon $AEROSPACE_WORKSPACES
# fi
