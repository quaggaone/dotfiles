#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/../utils.sh"

# Domain for Dock preferences
DOCK_DOMAIN="com.apple.dock"

set_defaults "$DOCK_DOMAIN" "autohide" "bool" "true"
set_defaults "$DOCK_DOMAIN" "autohide-delay" "float" "0"
set_defaults "$DOCK_DOMAIN" "tilesize" "int" "40"
set_defaults "$DOCK_DOMAIN" "magnification" "bool" "false"
set_defaults "$DOCK_DOMAIN" "show-recents" "bool" "false"
set_defaults "$DOCK_DOMAIN" "showAppExposeGestureEnabled" "bool" "true"
set_defaults "$DOCK_DOMAIN" "showhidden" "bool" "true"
set_defaults "$DOCK_DOMAIN" "launchanim" "bool" "true"
set_defaults "$DOCK_DOMAIN" "show-process-indicators" "bool" "true"
defaults write com.apple.dock persistent-apps -array ""

# define function to easily set all apps for the dock
set_persistent_apps() {
    local label="$1"
    local location="$2"

    defaults write com.apple.dock persistent-apps -array-add "\
    <dict>
        <key>tile-data</key>
        <dict>
            <key>file-data</key>
            <dict>
                <key>_CFURLString</key>
                <string>file://${location}</string>
                <key>_CFURLStringType</key>
                <integer>15</integer>
            </dict>
            <key>file-label</key>
            <string>${label}</string>
            <key>showas</key>
            <integer>2</integer>
        </dict>
        <key>tile-type</key>
        <string>file-tile</string>
    </dict>"
}

# idk why safari has this weird path. i just copied it from the default macos config.
set_persistent_apps "Safari"    "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app/"
set_persistent_apps "Calendar"  "/System/Applications/Calendar.app/"
set_persistent_apps "Mail"      "/System/Applications/Mail.app/"
set_persistent_apps "WhatsApp"  "/Applications/WhatsApp.app/"
set_persistent_apps "Messages"  "/System/Applications/Messages.app/"
set_persistent_apps "Obsidian"  "/Applications/Obsidian.app/"
set_persistent_apps "Le Chat"   "${HOME}/Applications/Le%20Chat.app/"
set_persistent_apps "Ghostty"   "/Applications/Ghostty.app/"
set_persistent_apps "Zed"       "/Applications/Zed.app/"

defaults write com.apple.dock persistent-others -array ""
## add Downloads and Screenshots folder to dock
## arragement: sort by; displayas: display as; showas: view content as
defaults write com.apple.dock persistent-others -array-add "<dict>
<key>tile-data</key>
                <dict>
                    <key>arrangement</key>
                    <integer>2</integer>
                    <key>displayas</key>
                    <integer>0</integer>
                    <key>file-data</key>
                    <dict>
                        <key>_CFURLString</key>
                        <string>file://${HOME}/Downloads/</string>
                        <key>_CFURLStringType</key>
                        <integer>15</integer>
                    </dict>
                    <key>file-type</key>
                    <integer>2</integer>
                    <key>showas</key>
                    <integer>2</integer>
                </dict>
                <key>tile-type</key>
                <string>directory-tile</string>
</dict>"
## add hidden Screenshots folder to dock with adjusted label
defaults write com.apple.dock persistent-others -array-add "<dict>
<key>tile-data</key>
                <dict>
                    <key>arrangement</key>
                    <integer>1</integer>
                    <key>displayas</key>
                    <integer>0</integer>
                    <key>file-data</key>
                    <dict>
                        <key>_CFURLString</key>
                        <string>file://${HOME}/Desktop/.Screenshots/</string>
                        <key>_CFURLStringType</key>
                        <integer>15</integer>
                    </dict>
                    <key>file-label</key>
                    <string>Screenshots</string>
                    <key>file-type</key>
                    <integer>2</integer>
                    <key>showas</key>
                    <integer>2</integer>
                </dict>
                <key>tile-type</key>
                <string>directory-tile</string>
            </dict>"

# Define an associative array (dictionary) for Dock settings
# typeset -A DOCK_SETTINGS

# Populate the associative array
# DOCK_SETTINGS=(
#     "autohide" "true"                 # Automatically hide and show the Dock
#     "autohide-delay" "0"              # Remove delay when showing the Dock
#     "tilesize" "40"                   # Set the size of Dock icons
#     "magnification" "false"           # Enable magnification of icons
#     "show-recents" "false"            # Disable recent apps
#     "showhidden" "true"               # Make icons of hidden applications translucent
# )

# Apply all settings from the associative array
# for key value in ${(kv)DOCK_SETTINGS}; do
#     set_defaults "$DOCK_DOMAIN" "$key" "$value"
# done


# Desktop and Stage Manager section
set_defaults "com.apple.WindowManager" "EnableStandardClickToShowDesktop" "bool" "false"
set_defaults "com.apple.WindowManager" "StandardHideDesktopIcons" "bool" "false"

# Window section
set_defaults "-g" "NSCloseAlwaysConfirmsChanges" "bool" "true"
set_defaults "-g" "NSQuitAlwaysKeepsWindows" "bool" "true"

# Mission Control section
set_defaults "com.apple.dock" "mru-spaces" "bool" "false"              # Rearrange Spaces based on most recent use
set_defaults "-g" "AppleSpacesSwitchOnActivate" "bool" "true"          # Switch to Space with open window for selected app
set_defaults "com.apple.dock" "expose-group-apps" "bool" "true"        # Group windows by application
set_defaults "com.apple.spaces" "spans-displays" "bool" "false"        # Displays have separate Spaces (AeroSpace recommends it off; SketchyBar only works with it on)

# Hot Corners section
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Application Windows
#  4: Desktop
#  5: Start Screen Saver
#  6: Disable Screen Saver
#  7: Dashboard
# 10: Put Display to Sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen

# Top-left -> Put Display to Sleep
set_defaults "com.apple.dock" "wvous-tl-corner" "int" "10"
# Top-right -> Notification Center
set_defaults "com.apple.dock" "wvous-tr-corner" "int" "12"
# Bottom-left -> no option
set_defaults "com.apple.dock" "wvous-bl-corner" "int" "0"
# Bottom-right -> no option
set_defaults "com.apple.dock" "wvous-br-corner" "int" "0"


# Appearance section
set_defaults "-g" "AppleReduceDesktopTinting" "bool" "true"            # Disallow wallpaper tinting in windows


# Restart Dock to apply changes
echo "Restarting Dock to apply changes..."
killall Dock

echo "Dock settings updated!"
