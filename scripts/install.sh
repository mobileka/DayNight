#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="/Applications/DayNight.app"

"$ROOT/scripts/build.sh"

pkill -x DayNight 2>/dev/null || true
sleep 1

rm -rf "$APP"
ditto "$ROOT/build/DayNight.app" "$APP"

if [ "${1:-}" = "--autoload" ] || [ "${1:-}" = "-a" ]; then
    if osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null \
        | tr ',' '\n' | sed 's/^ *//;s/ *$//' | grep -qx 'DayNight'; then
        echo "Already in Login Items"
    else
        osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$APP\", hidden:true}" >/dev/null
        echo "Added to Login Items"
    fi
fi

open "$APP"
echo "Installed $APP"
