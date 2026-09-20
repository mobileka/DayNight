#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="/Applications/DayNight.app"

"$ROOT/scripts/build.sh"

pkill -x DayNight 2>/dev/null || true
sleep 1

rm -rf "$APP"
ditto "$ROOT/build/DayNight.app" "$APP"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP"

open "$APP"
echo "Installed $APP"
