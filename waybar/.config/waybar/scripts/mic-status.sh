#!/bin/bash

SOURCE=$(/usr/bin/pamixer --list-sources | grep -v monitor | grep -o '^[0-9]\+' | head -n1)

if [ -z "$SOURCE" ]; then
  echo "󰍭 --%"
  exit 0
fi

ACTION=$1
case "$ACTION" in
  toggle)
    /usr/bin/pamixer --source "$SOURCE" -t
    ;;
  up)
    /usr/bin/pamixer --source "$SOURCE" --increase 5
    ;;
  down)
    /usr/bin/pamixer --source "$SOURCE" --decrease 5
    ;;
  *)
    if ! /usr/bin/pamixer --get-volume --source "$SOURCE" &>/dev/null; then
      echo "󰍭 --%"
      exit 0
    fi

    MUTE=$(/usr/bin/pamixer --source "$SOURCE" --get-mute)
    VOLUME=$(/usr/bin/pamixer --source "$SOURCE" --get-volume)

    if [[ "$MUTE" == "true" ]]; then
      echo "󰍭 $VOLUME%"
    else
      echo "󰍬 $VOLUME%"
    fi
    ;;
esac
