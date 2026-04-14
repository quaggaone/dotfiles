#!/bin/bash

# invisible item that runs once per aerospace_workspace_change event.
# see aerospace-event-handler.sh for why this needs to be a dedicated item.
sketchybar --add event aerospace_workspace_change \
           --add item aerospace.event-handler popup \
           --set aerospace.event-handler script="$PLUGIN_DIR/aerospace-event-handler.sh" \
           --subscribe aerospace.event-handler aerospace_workspace_change
