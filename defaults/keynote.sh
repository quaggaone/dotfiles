#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/utils.sh"

# Domain for Keynote preferences
KEYNOTE_DOMAIN="com.apple.iWork.Keynote"

###########
# KEYNOTE #
###########

# Settings
## Rulers

# Show snapping guides at object edges
set_defaults "$KEYNOTE_DOMAIN" "TSDDisplayEdgeGuides" "bool" "true"

# Restart Keynote to apply changes
echo "Restarting Keynote to apply changes..."
killall Keynote

echo "Keynote settings updated!"

