#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/utils.sh"

# Domain for Mail preferences
MAIL_DOMAIN="com.apple.mail"

########
# MAIL #
########

# Settings
## Viewing

# Show most recent message of a thread at the top
set_defaults "$MAIL_DOMAIN" "ConversationViewSortDescending" "bool" "true"

# Restart Mail to apply changes
echo "Restarting Mail to apply changes..."
killall Mail

echo "Mail settings updated!"

