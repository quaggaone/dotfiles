#!/bin/sh

source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

# needed to define default color for states not setting an override
COLOR="$WHITE"
ICON_DRAWING="on"
LABEL_DRAWING="off"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="􀛨" ICON_DRAWING="off"
  ;;
  [6-8][0-9]) ICON="􀺸"
  ;;
  [3-5][0-9]) ICON="􀺶"
  ;;
  [1-2][0-9]) ICON="􀛩" COLOR="$COLOR_80" BG="$COLOR_10" LABEL_DRAWING="on"
  ;;
  [1-9]|10) ICON="􀛩" COLOR="$COLOR_50" BG="$COLOR_10" LABEL_DRAWING="on"
  ;;
  *) ICON="􀛪"
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="􀢋"
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
# sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
# sketchybar --set "$NAME" \
#     icon="$ICON" \
#     icon.drawing="$ICON_DRAWING" \
#     label.drawing=off \
#     icon.padding_right=$PADDING_OUTER \
#     icon.color="$COLOR" \
#     background.color="$BG"


sketchybar --set "$NAME" icon.drawing=off \
    drawing=$ICON_DRAWING \
    alias.color=$COLOR \
    label="${PERCENTAGE}%" \
    label.drawing=$LABEL_DRAWING \
    label.color=$COLOR \
    label.padding_left=0 \
    background.color=$BG
