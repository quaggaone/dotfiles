#!/bin/bash

# get icon map function
source "$CONFIG_DIR/lib/icon_map.sh"

# execute icon map function
__icon_map "$1"

# return result
echo "$icon_result"
