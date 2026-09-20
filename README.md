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
./scripts/install.sh
```

Builds, replaces any running copy, installs to `/Applications/DayNight.app`, and launches it.

Pass `--autoload` (or `-a`) to also re-register the bundle with Launch Services, which helps when Finder keeps showing a stale icon:

```sh
./scripts/install.sh --autoload
```

## License

MIT — see [LICENSE](LICENSE).
