#!/bin/bash
set -euo pipefail

APP="/Applications/DayNight.app"

pkill -x DayNight 2>/dev/null || true
sleep 1

if osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null \
    | tr ',' '\n' | sed 's/^ *//;s/ *$//' | grep -qx 'DayNight'; then
    osascript -e 'tell application "System Events" to delete login item "DayNight"' >/dev/null
    echo "Removed login item"
fi

if [ -d "$APP" ]; then
    rm -rf "$APP"
    echo "Removed $APP"
else
    echo "Nothing to remove at $APP"
fi
