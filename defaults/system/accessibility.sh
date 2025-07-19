#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/../utils.sh"


defaults write com.apple.universalaccess axShortcutExposedFeatures "{"feature.displayFilters" = 1;
                                                                    "feature.fullKeyboardAccess" = 0;
                                                                    "feature.headMouse" = 0;
                                                                    "feature.hoverText" = 0;
                                                                    "feature.hoverTyping" = 0;
                                                                    "feature.increaseContrast" = 0;
                                                                    "feature.invertDisplayColor" = 0;
                                                                    "feature.liveSpeech" = 0;
                                                                    "feature.mouseKeys" = 0;
                                                                    "feature.reduceTransparency" = 0;
                                                                    "feature.slowKeys" = 0;
                                                                    "feature.stickyKeys" = 0;
                                                                    "feature.systemTranscriptions" = 0;
                                                                    "feature.virtualKeyboard" = 0;
                                                                    "feature.voiceControl" = 0;
                                                                    "feature.voiceOver" = 0;
                                                                    "feature.zoom" = 0;}"
