#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/../utils.sh"

defaults write NSGlobalDomain com.apple.mouse.scaling -float "3"

defaults write -g com.apple.trackpad.scaling -float "1.5"

# Drag & Drop with three on a trackpad (just better trust me; look it up)
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"

# forgot but i think this enables Mission Control & App Expose gestures with four fingers instead of three
# this is needed because of the `TrackpadThreeFingerDrag` option above
defaults write -g com.apple.trackpad.threeFingerVertSwipeGesture -int "0"
