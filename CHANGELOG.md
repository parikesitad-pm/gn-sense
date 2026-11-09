# Changelog

All notable changes follow [Semantic Versioning](https://semver.org).

## 0.3.1 — 2026-11-09

- Fixed: an embedded card never reached the keyboard (every effect, Off included). `rgb.sh` was
  looked up in the host shell's folder; it is now resolved next to `Sense.qml`.
- The footer shows in the embedded card too.

## 0.3.0 — 2026-11-09

- `SenseCard.qml`: the controls as one component another Quickshell shell can load, for example as
  a sheet in a top island. `embedded: true` leaves out the title, caution tape and footer.
- Settings file renamed to `gn-sense.json`; an existing `settings.json` is moved once on start.

## 0.2.0 — 2026-11-09

- Placement setting: `"top"` hangs the panel just under a top bar or island and slides it down out
  of it; `"center"` (default) keeps it in the middle of the screen.
- The overlay keeps out of other panels' reserved space, so it centers on the same axis as a bar or
  island and does not cover them.

## 0.1.1 — 2026-11-09

- Fixed: footer credit overlapped the "tested on" line; it now uses two lines.
- Swatches and the hex field share one row; the settings for the chosen effect sit in one panel.
- Docs: keyboard protocol and adding a model.

## 0.1.0 — 2026-11-09

First release.

- Panel with power profile (Standby, Cruise, Trans-Am) through power-profiles-daemon.
- Keyboard lighting for 4-zone Acer keyboards: Static, Breath, Shifting, Zoom, Wave, Neon, Off.
- Per-zone colors for Static; one color for Breath, Shifting and Zoom; hex input.
- Brightness, speed and direction (Wave, Shifting); live keyboard preview that only redraws four zones per frame.
- Lighting linked to each power profile (default: Cruise = Wave, Trans-Am = red Breath).
- Saved lighting is restored when the panel starts, since the keyboard forgets it on boot.
- `gn-sense` launcher and installer. Tested on Acer Nitro AN515-56 (N key = keycode 433).
