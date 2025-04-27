#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/../utils.sh"

##########################
# Control Center Modules #
##########################

# (2: Show when active; 18: show; 24: hide)
# numbering seems to start at 24 for this section. "Show in Menu Bar" seems to subtract 6.

defaults -currentHost write com.apple.controlcenter AirDrop -int 24
defaults -currentHost write com.apple.controlcenter Bluetooth -int 24
defaults -currentHost write com.apple.controlcenter Display -int 2
defaults -currentHost write com.apple.controlcenter FocusModes -int 2
defaults -currentHost write com.apple.controlcenter NowPlaying -int 2
defaults -currentHost write com.apple.controlcenter ScreenMirroring -int 2
defaults -currentHost write com.apple.controlcenter Sound -int 2
defaults -currentHost write com.apple.controlcenter WiFi -int 2



#################
# Other Modules #
#################

# numbering in this section seems to start at 12 for not showing at all.
# "Show in Menu Bar" seems to subtract 6.
# "Show in Control Center" seems to subtract 3.

defaults -currentHost write com.apple.controlcenter AccessibilityShortcuts -int 12
defaults -currentHost write com.apple.controlcenter Battery -int 6
defaults -currentHost write com.apple.controlcenter BatteryShowEnergyMode -int 1       # is an int with value 1 for "Show Always" (checked)
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool false
defaults -currentHost write com.apple.controlcenter Hearing -int 12
defaults -currentHost write com.apple.controlcenter KeyboardBrightness -int 12
defaults -currentHost write com.apple.controlcenter MusicRecognition -int 9
defaults -currentHost write com.apple.controlcenter UserSwitcher -int 28               # has a different numbering system (presumably because of the additional options



#################
# Menu Bar Only #
#################

set_defaults "com.apple.menuextra.clock" "FlashDateSeparators" "bool" "true"
set_defaults "com.apple.menuextra.clock" "IsAnalog" "bool" "false"
set_defaults "com.apple.menuextra.clock" "Show24Hour" "bool" "true"
set_defaults "com.apple.menuextra.clock" "ShowDate" "int" "0"
set_defaults "com.apple.menuextra.clock" "ShowDayOfMonth" "bool" "true"
set_defaults "com.apple.menuextra.clock" "ShowDayOfWeek" "bool" "true"
set_defaults "com.apple.menuextra.clock" "ShowSeconds" "bool" "false"
defaults -currentHost write com.apple.Spotlight MenuItemHidden -bool true              # hides Spotlight from Menu Bar
set_defaults "com.apple.Siri" "StatusMenuVisible" "bool" "false"
set_defaults "-g" "_HIHideMenuBar" "int" "1"


# Restart service to apply changes
echo "Restarting SystemUIServer to apply changes..."
killall SystemUIServer

echo "Updated Menu Bar and Control Center!"
