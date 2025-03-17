#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/utils.sh"

# Domain for Dock preferences
FINDER_DOMAIN="com.apple.finder"

##########
# FINDER #
##########

# Expanded Save Panel defaults
set_defaults "-g" "NSNavPanelExpandedStateForSaveMode" "bool" "true"                   # Use expanded save panel by default
set_defaults "-g" "NSNavPanelExpandedStateForSaveMode2" "bool" "true"                  # Use expanded save panel by default

# Expanded Print Panel defaults
# set_defaults "-g" "PMPrintingExpandedStateForPrint" "bool" "true"                    # Use expanded print panel by default
# set_defaults "-g" "PMPrintingExpandedStateForPrint2" "bool" "true"                   # Use expanded print panel by default

# set_defaults "-g" "AppleShowAllExtensions" "bool" ""                                 # Show all Extensions
set_defaults "$FINDER_DOMAIN" "FXPreferredViewStyle" "string" "clmv"                   # Column view
set_defaults "$FINDER_DOMAIN" "_FXSortFoldersFirst" "bool" "true"                      # Keep folder on top
set_defaults "$FINDER_DOMAIN" "FXDefaultSearchScope" "string" "SCcf"                   # Default search scope (-> current folder)
set_defaults "$FINDER_DOMAIN" "NewWindowTarget" "string" "PfLo"                        # Default shown folder for new windows (PfLo -> other: sets a custom target path)
[ ! -d "$HOME/Spawn" ] && mkdir ~/Spawn/                                               # Create folder; skip if found
set_defaults "$FINDER_DOMAIN" "NewWindowTargetPath" "string" "file://${HOME}/Spawn"    # Sets custom path for new window location
set_defaults "$FINDER_DOMAIN" "ShowExternalHardDrivesOnDesktop" "bool" "true"          # Show external disks on desktop
set_defaults "$FINDER_DOMAIN" "ShowHardDrivesOnDesktop" "bool" "false"                 # Show hard disks on desktop
set_defaults "$FINDER_DOMAIN" "ShowMountedServersOnDesktop" "bool" "true"              # Show connected servers on desktop
set_defaults "$FINDER_DOMAIN" "ShowPathbar" "bool" "false"                             # Show pathbar
set_defaults "$FINDER_DOMAIN" "ShowRemovableMediaOnDesktop" "bool" "true"              # Show removable media
set_defaults "$FINDER_DOMAIN" "ShowStatusBar" "bool" "true"                            # Show status bar at the bottom of a window

chflags nohidden ~/Library                                                             # Show the ~/Library folder

## Expand following File Info panes:
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	MetaData -bool true \
	OpenWith -bool true \
	Preview -bool true \
	Privileges -bool true

# Restart Finder to apply changes
echo "Restarting Finder to apply changes..."
killall Finder

echo "Finder settings updated!"

