#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/utils.sh"

# Domain for Mail preferences
MAIL_DOMAIN="com.apple.mail"

# Group container prefs live outside the standard domain and must be addressed by
# their full plist path (a bare `group.com.apple.mail` domain resolves elsewhere).
MAIL_GROUP_DOMAIN="$HOME/Library/Group Containers/group.com.apple.mail/Library/Preferences/group.com.apple.mail"

########
# MAIL #
########

# Menubar Settings
## View
set_defaults "$MAIL_DOMAIN" "ColumnLayoutMessageList" "bool" "true"
set_defaults "$MAIL_DOMAIN" "BottomPreview" "bool" "false"
# which colums are displayed can't be configured this way (assumption)

# Settings
## Viewing

# Show most recent message of a thread at the top
set_defaults "$MAIL_DOMAIN" "ConversationViewSortDescending" "bool" "true"

# Disable "Follow Up" suggestions (Settings > General). Lives in the group container.
set_defaults "$MAIL_GROUP_DOMAIN" "DisableFollowUp" "bool" "true"

# Restart Mail to apply changes
echo "Restarting Mail to apply changes..."
killall Mail

echo "Mail settings updated!"
