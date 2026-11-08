# Changelog

All notable changes follow [Semantic Versioning](https://semver.org).

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
