#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/build/DayNight.app"

if [ ! -f "$ROOT/AppIcon.icns" ]; then
    echo "error: $ROOT/AppIcon.icns not found" >&2
    exit 1
fi

rm -rf "$ROOT/build"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$ROOT/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"

swiftc -O -target arm64-apple-macos13.0 "$ROOT/main.swift" -o "$APP/Contents/MacOS/DayNight"
cp "$ROOT/Info.plist" "$APP/Contents/Info.plist"
codesign --force --sign - "$APP"

echo "Built $APP"
