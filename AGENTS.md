# AGENTS.md — gn-sense

> Read `PILOT.md` first: the pilot's briefing, current phase, and decisions already made.

Public repo. Power profile + keyboard RGB panel for Acer Nitro/Predator laptops, as a standalone
Quickshell config. Unofficial; not affiliated with Acer.

## Commands
| Goal | Command |
|---|---|
| Install (copy) | `./install.sh` |
| Install (dev symlink) | `./install.sh --link` |
| Run | `qs -c gn-sense -n -d` |
| Open / close | `gn-sense` or `qs -c gn-sense ipc call sense toggle` |
| Logs | `qs -c gn-sense log` |
| Check scripts | `bash -n scripts/rgb.sh bin/gn-sense install.sh` |

## Stack
- Quickshell 0.3 (QML, Qt 6), Wayland layer-shell window.
- power-profiles-daemon (`powerprofilesctl`), changes followed with `dbus-monitor`.
- Keyboard RGB through the out-of-tree facer module: `/dev/acer-gkbbl-0` (mode packet, 16 bytes)
  and `/dev/acer-gkbbl-static-0` (zone color, 4 bytes), written by `scripts/rgb.sh`.

## Structure
| Path | Purpose |
|---|---|
| `shell.qml` | Root: the panel and the `sense` IPC target |
| `Sense.qml` | Singleton: profile, lighting state, profile links, settings file, device writes |
| `Theme.qml` | Singleton: colors and font |
| `Panel.qml` | The overlay window and card layout |
| `KeyboardPreview.qml`, `ColorPanel.qml`, `DirectionToggle.qml`, `ProfileLink.qml` | Card sections |
| `Chip.qml`, `ValueSlider.qml`, `SectionLabel.qml`, `HazardStripe.qml`, `Footer.qml` | Small building blocks |
| `scripts/rgb.sh` | Writes payloads to the facer devices |
| `bin/gn-sense` | Launcher: toggles the panel, starts Quickshell if needed |
| `docs/` | Keyboard protocol, adding a model |

## Conventions
- Every QML type must be listed in `qmldir`; once it exists, unlisted files are not found.
- Effects and their capabilities (color, speed, direction) live in `Sense.effects`; the UI reads them.
- Settings are a `JsonAdapter` in `Sense.qml`; nested values (zones, links) are stored as strings.
- Wave and Neon use the keyboard's own color cycle and take no color; the preview shows their motion only.
- Version and changes go in `CHANGELOG.md` (semver) in the same change.

## Definition of done
- `bash -n` passes on the three scripts.
- `qs -c gn-sense log` shows "Configuration Loaded" and no QML errors after a change.
- Open the panel and look at it; with the driver loaded, the keyboard changes when an effect is picked.

## Don't
- No fan control: out of scope.
- No laptop-specific paths, model serials or personal data in the repo.
