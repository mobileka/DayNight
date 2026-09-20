# DayNight

A tiny 1-click macOS menu bar switch for Light/Dark theme.

As macOS's built-in auto mode gives you little control over this, DayNight replaces that with one click whenever you want it.

## Requirements

- macOS 13 or newer
- Xcode command line tools (`xcode-select --install`) for `swiftc`

## Build

```sh
./scripts/build.sh
```

The app is assembled at `build/DayNight.app`.

## Install

```sh
./scripts/install.sh
```

Builds, replaces any running copy, installs to `/Applications/DayNight.app`, and launches it.

## Permissions

DayNight switches appearance by telling System Events to change the system setting. On first click macOS asks for permission to control System Events — approve it once. If it was denied, enable DayNight under System Settings → Privacy & Security → Automation.

## License

MIT — see [LICENSE](LICENSE).
