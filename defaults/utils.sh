#!/bin/zsh

# Source the secrets script
source "$(dirname "$0")/../secrets.sh"

# Generic function to set macOS preferences using `defaults`
set_defaults() {
    local domain="$1"
    local key="$2"
    local type="$3"
    local value="$4"

    # Construct verbose output
    echo "Setting [$domain] $key to $type $value..."

    # Set the value based on its type
    case "$type" in
        bool)
            defaults write "$domain" "$key" -bool "$value"
            ;;
        int)
            defaults write "$domain" "$key" -int "$value"
            ;;
        float)
            defaults write "$domain" "$key" -float "$value"
            ;;
        string)
            defaults write "$domain" "$key" "$value"
            ;;
        *)
            echo "Unknown type ("$type") for [$domain] $key. Skipping..."
            ;;
    esac
}
