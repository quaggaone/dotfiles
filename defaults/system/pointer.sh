#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/../utils.sh"

defaults write NSGlobalDomain com.apple.mouse.scaling -float "3"

defaults write -g com.apple.trackpad.scaling -float "1.5"

defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"
