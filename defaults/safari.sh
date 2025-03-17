#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/utils.sh"

# Domain for Dock preferences
SAFARI_DOMAIN="com.apple.Safari"

##########
# SAFARI #
##########

## View options
set_defaults "$SAFARI_DOMAIN" "ShowOverlayStatusBar" "bool" "true"        # Show Status Bar to see URLs at the bottom


## Settings
### General
set_defaults "$SAFARI_DOMAIN" "ExcludePrivateWindowWhenRestoringSessionAtLaunch" "bool" "false"    # Restore all windows when restarting

### Advanced
set_defaults "$SAFARI_DOMAIN" "IncludeDevelopMenu" "bool" "true"           # Show Developer options

# Restart Safari to apply changes
echo "Restarting Safari to apply changes..."
killall Safari

echo "Safari settings updated!"

