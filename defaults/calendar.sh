#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/utils.sh"

# Domain for Calendar preferences
CAL_DOMAIN="com.apple.iCal"

############
# Calendar #
############

# Settings
## General
set_defaults "$CAL_DOMAIN" "number of hours displayed" "int" "16"

# Restart Calendar to apply changes
echo "Quitting Calendar to apply changes..."
killall Calendar

echo "Calendar settings updated!"

