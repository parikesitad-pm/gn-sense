# gn-sense

Power profile and keyboard RGB panel for Acer Nitro and Predator laptops on Linux, opened from
the keyboard's **N** key. An unofficial, NitroSense-style tool; not affiliated with Acer.

Built with the [Celestial Being theme](https://github.com/parikesitad-pm/celestial-being).

- **Power:** Standby, Cruise, Trans-Am (power-saver, balanced, performance).
- **Keyboard:** Static per-zone colors, Breath, Shifting, Zoom, Wave, Neon, Off, with brightness,
  speed, direction and a live preview.
- **Profile links:** each power profile can carry its own lighting, so switching to Trans-Am
  also switches the keyboard.

## Supported hardware

| Brand | What works | How |
|---|---|---|
| Acer Nitro (4-zone RGB) | Power + keyboard RGB | facer kernel module |
| Acer Predator (4-zone RGB) | Power + keyboard RGB | facer kernel module |
| Acer Predator (per-key RGB) | Power only | per-key keyboards use a different interface |
| ASUS ROG / TUF | Power only | use [asusctl and ROG Control Center](https://asus-linux.org) for Aura lighting |
| Any laptop with power-profiles-daemon | Power only | |

Tested on:

| Model | Power | RGB | N key |
|---|---|---|---|
| Nitro 5 AN515-56 | yes | yes | keycode 433 |

The [facer compatibility table](https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module)
lists the Nitro and Predator models known to work with the driver. To add your model here, open an
issue with the model name, the output of `ls /dev/acer-gkbbl*`, and what the N key prints in
`sudo evtest`.

## Requirements

| Need | Arch package | Why |
|---|---|---|
| [Quickshell](https://quickshell.org) 0.3 or newer | `quickshell` | The panel |
| power-profiles-daemon | `power-profiles-daemon` | Power profiles |
| dbus | `dbus` | Follows profile changes made elsewhere |
| JetBrainsMono Nerd Font | `ttf-jetbrains-mono-nerd` | Icons |
| facer kernel module | [acer-predator-turbo-and-rgb-keyboard-linux-module](https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module) | Keyboard RGB |

A Wayland compositor with layer-shell support is required: Hyprland, Sway, niri, KDE Plasma and
others. GNOME does not support layer-shell, so gn-sense does not run there.

On other distributions, install the same software from your package manager. Quickshell is in the
Arch repos, Fedora COPR and nixpkgs; on Debian and Ubuntu it has to be built from source.

## Install

```sh
git clone https://github.com/parikesitad-pm/gn-sense
cd gn-sense
./install.sh
```

For keyboard RGB, install the facer module with its systemd service so it loads on every boot:

```sh
git clone https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module
cd acer-predator-turbo-and-rgb-keyboard-linux-module
sudo bash install_service.sh   # needs rsync, make and your kernel headers
```

Then start gn-sense with your session and bind the N key.

**Hyprland** (Lua config):

```lua
hl.exec_cmd("qs -c gn-sense -n -d")
hl.bind("code:433", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.local/bin/gn-sense"))
```

**Hyprland** (hyprlang config):

```ini
exec-once = qs -c gn-sense -n -d
bind = , code:433, exec, ~/.local/bin/gn-sense
```

**Sway:**

```ini
exec qs -c gn-sense -n -d
bindcode 433 exec ~/.local/bin/gn-sense
```

**KDE Plasma:** add `qs -c gn-sense -n -d` to Autostart, then create a custom shortcut in System
Settings that runs `~/.local/bin/gn-sense` and press the N key to record it.

On the AN515-56 the N key sends scancode `0xf5`, Linux key 425 (`KEY_PRESENTATION`), which is
keycode 433 for compositors. Other models may differ; check with `sudo evtest`.

## Manual

**Open and close.** Press N or run `gn-sense`. Esc, the × button or a click outside closes it.

**Power.** Pick Standby (quiet, longest battery), Cruise (balanced) or Trans-Am (full CPU power).
This sets the power-profiles-daemon profile, so other tools see the same change.

**Keyboard effects.**

| Effect | Color | Speed | Direction |
|---|---|---|---|
| Static | one per zone | | |
| Breath | one | yes | |
| Shifting | one | yes | yes |
| Zoom | one | yes | |
| Wave | the keyboard's own cycle | yes | yes |
| Neon | the keyboard's own cycle | yes | |
| Off | | | |

**Colors.** In Static, tap a zone to edit it alone, or All to paint all four. Pick a swatch or type
a hex color and press Enter. Breath, Shifting and Zoom use one color.

**Brightness, speed, direction.** Sliders apply as you drag. Direction appears for Wave and
Shifting: right to left, or left to right.

**Profile links.** With "Lighting follows the power profile" on, each profile can keep its own
lighting. Set the lighting you want, then press "Save to <profile>". Defaults: Cruise = Wave,
Trans-Am = red Breath. The × next to it removes the link for the current profile.

**Command line.**

| Command | Does |
|---|---|
| `gn-sense` | Open or close the panel, starting it if needed |
| `qs -c gn-sense ipc call sense open` | Open |
| `qs -c gn-sense ipc call sense close` | Close |
| `scripts/rgb.sh zones 3b82f6 2ee6a8 ff9f1c a855f7 100` | Four zone colors, left to right, brightness 100 |
| `scripts/rgb.sh effect 1 4 100 ff2e63` | Red breathing at speed 4 |
| `scripts/rgb.sh off` | Lights off |

## FAQ

**The keyboard section says "driver not loaded".** `/dev/acer-gkbbl-0` is missing. Install the
facer module (above) and check `lsmod | grep facer`. If the kernel refused it with "Key was
rejected by service", Secure Boot is on and the module has to be signed.

**The keyboard does not change color.** Some models need the module loaded with
`sudo modprobe facer rgb_ec_enable=1`.

**The lighting resets after a reboot.** The keyboard forgets its effect on power-off. gn-sense
restores the saved lighting when it starts, so start it with your session.

**Why can't I pick a color for Wave and Neon?** The keyboard runs those cycles itself and takes no
color for them. Use Shifting for a moving effect in one color.

**The N key does nothing.** Run `sudo evtest`, pick the keyboard, press N and use the code it
prints plus 8 in your compositor's bind.

**Fan control?** Not included. Fan writes go through firmware interfaces that differ per model,
and a wrong value can overheat the laptop.

**ASUS laptops?** The power section works. For Aura lighting use asusctl and ROG Control Center,
which already cover ASUS hardware.

**Where are the settings?** In Quickshell's state directory for this config:
`~/.local/state/quickshell/by-shell/<id>/settings.json`.

**How heavy is it?** Measured on the AN515-56: 0% CPU while closed, about 5% of one core while
the panel is open, about 140 MiB of memory.

## Uninstall

```sh
qs -c gn-sense kill
rm -rf ~/.config/quickshell/gn-sense ~/.local/bin/gn-sense
```

## License

MIT, copyright Dausan Adam Parikesit (dap_). See [LICENSE](LICENSE).
