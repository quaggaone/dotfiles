#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/../utils.sh"

# silence the startup sound
echo "Setting Startup sound to muted (sudo required)"
sudo nvram StartupMute=%01

# enabling acustic feedback for volume adjustments
set_defaults "-g" "com.apple.sound.beep.feedback" "bool" "true"

