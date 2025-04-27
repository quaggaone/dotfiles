#!/bin/sh

source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

# needed to define default color for states not setting an override
COLOR="$WHITE"
ICON_DRAWING="on"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="􀛨" ICON_DRAWING="off"
  ;;
  [6-8][0-9]) ICON="􀺸" ICON_DRAWING="off"
  ;;
  [3-5][0-9]) ICON="􀺶"
  ;;
  [1-2][0-9]) ICON="􀛩"
  ;;
  [1-9]|10) ICON="􀛩" COLOR="0xffff3b30" BG="0x50ffffff"
  ;;
  *) ICON="􀛪"
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="􀢋"
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
# sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.drawing="$ICON_DRAWING" \
    label.drawing=off \
    icon.padding_right=10 \
    icon.color="$COLOR" \
    background.color="$BG"
