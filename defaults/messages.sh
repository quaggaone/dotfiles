#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/utils.sh"

# Domain for Messages preferences
MESSAGES_DOMAIN="com.apple.MobileSMS"

############
# MESSAGES #
############

# Settings
## General
set_defaults "$MESSAGES_DOMAIN" "PlaySoundsKey" "bool" "false"

# Restart Messages to apply changes
echo "Restarting Messages to apply changes..."
killall Messages

echo "Messages settings updated!"
