# DayNight

A tiny 1-click macOS menu bar switch for Light/Dark theme.

As macOS's built-in auto mode gives you little control over this, DayNight replaces that with one click whenever you want it.

## Requirements

- macOS 13 or newer
- Xcode command line tools (`xcode-select --install`) for `swiftc`
- Permission to control System Events

## Build

```sh
./scripts/build.sh
```

The app is assembled at `build/DayNight.app`.

## Install

```sh
# build, install to `/Applications/DayNight.app` and launch the app
./scripts/install.sh
```

Pass `--autoload` (or `-a`) if you want it to launch automatically:

```sh
./scripts/install.sh --autoload
```

## Uninstall

```sh
./scripts/uninstall.sh
```

Quits DayNight, removes it from Login Items if present, and deletes `/Applications/DayNight.app`.

## License

MIT — see [LICENSE](LICENSE).
