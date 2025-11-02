#!/bin/bash

# Check if the version number is supplied as an argument
if [ -z "$1" ]; then
  echo "Error: Version number not supplied. Please provide a semantic version number like x.y.z."
  exit 1
fi

# Get the version number from the first argument
VERSION="$1"

# Validate the version number format (x.y.z)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: Invalid version number format. Please provide a semantic version number like x.y.z."
  exit 1
fi

# Download the file using curl with the provided version number
curl -L "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v${VERSION}/icon_map.sh" -o ~/.config/sketchybar/lib/icon_map.sh

echo "Download complete!"
