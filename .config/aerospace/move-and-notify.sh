#!/usr/bin/env bash

DEST=$1
SOURCE=$(aerospace list-workspaces --focused)

aerospace move-node-to-workspace "$DEST"

sketchybar --trigger aerospace_workspace_change AEROSPACE_WORKSPACES="$SOURCE $DEST"
