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
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP"
fi

open "$APP"
echo "Installed $APP"
