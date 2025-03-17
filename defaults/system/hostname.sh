#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/../utils.sh"

# Set HostName, LocalHostName and ComputerName

scutil --set ComputerName "$DOTFILES_HOSTNAME"
scutil --set HostName "$DOTFILES_HOSTNAME"
scutil --set LocalHostName "$DOTFILES_HOSTNAME"
# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$DOTFILES_HOSTNAME"
