#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/../utils.sh"

sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "This Mac is attached to an iCloud Account and valueless if lost.\\nDo the right thing. Reward included.\\n$DOTFILES_CONTACT_EMAIL // $DOTFILES_CONTACT_TEL"

