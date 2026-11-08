# PILOT BRIEFING — gn-sense

Pilot: dap_. Every agent in this repo is a copilot; decisions belong to the pilot.

## Mission
A NitroSense-style panel that Acer Nitro and Predator owners on Linux can install in one step:
power profile and keyboard RGB, opened from the N key, with a Gundam (GN) look.

## Flight plan
0.1: AN515-56 on Arch + Hyprland, the pilot's daily machine. Next: confirm other models through
issues before adding model-specific code.

## Pilot decisions (log)
| Date | Decision | Why |
|---|---|---|
| 2026-11-09 | Standalone Quickshell config, not GTK or Tauri | Same stack as the pilot's shell, small RAM use on a 7.5 GB machine |
| 2026-11-09 | Name `gn-sense`, README says unofficial | NitroSense is Acer's trademark |
| 2026-11-09 | Gundam/GN look by default, no rainbow anywhere in the UI | The app's identity; the pilot dislikes rainbow styling |
| 2026-11-09 | Defaults: Cruise = Wave, Trans-Am = red Breath | Pilot's spec |
| 2026-11-09 | No fan control | Pilot's machine uses an external cooler; fan drivers are banned on it |

## No-fly zone
- Fan control or fan drivers (Linuwu-Sense, NBFC).
- Shipping or bundling the facer kernel module; link to it instead.

## Ask the pilot first if
- Adding a dependency, a second UI toolkit, or a background service.
- Changing the default effects or the profile names.
