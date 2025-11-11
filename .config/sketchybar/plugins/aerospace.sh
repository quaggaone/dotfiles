#!/usr/bin/env bash

# ============================================================================
# sketchybar AeroSpace workspace script
# ============================================================================
# this script handles individual workspace updates.
# used for: initial setup when items are created, click handling
# NOTE: event-based updates are now handled by aerospace-coordinator.sh
# ============================================================================

# source shared functions
source "$CONFIG_DIR/utils/aerospace-functions.sh"

# reload workspace icon for the workspace ID passed as argument
reload_workspace_icon "$1"
