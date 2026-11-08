# Keyboard protocol

gn-sense does not talk to the firmware itself. The facer kernel module exposes two character
devices, and `scripts/rgb.sh` writes fixed-size byte payloads to them.

## `/dev/acer-gkbbl-static-0` — one zone color (4 bytes)

| Byte | Meaning |
|---|---|
| 0 | Zone bit mask: `1` zone 1 (left), `2` zone 2, `4` zone 3, `8` zone 4 (right) |
| 1 | Red, 0–255 |
| 2 | Green, 0–255 |
| 3 | Blue, 0–255 |

Static lighting writes this once per zone, then a mode payload with mode 0 to apply it.

## `/dev/acer-gkbbl-0` — mode (16 bytes)

| Byte | Meaning |
|---|---|
| 0 | Mode: `0` static, `1` breath, `2` neon, `3` wave, `4` shifting, `5` zoom |
| 1 | Speed, `0`–`9` (`0` = no motion) |
| 2 | Brightness, `0`–`100` |
| 3 | `8` for wave, `0` otherwise |
| 4 | Direction: `1` right to left, `2` left to right |
| 5–7 | Red, green, blue (breath, shifting, zoom) |
| 8 | `0` |
| 9 | `1` |
| 10–15 | `0` |

"Off" is mode 0 with brightness 0.

## Examples

```sh
scripts/rgb.sh zones ff2e63 2ee6a8 f2b705 ff2e63 100   # four static zones
scripts/rgb.sh effect 1 4 100 ff2e63                   # red breathing, speed 4
scripts/rgb.sh effect 4 5 80 2ee6a8 2                  # green shifting, left to right
scripts/rgb.sh off
```

`rgb.sh` exits without doing anything when `/dev/acer-gkbbl-0` is not writable, so it is safe to
call on machines without the module.

Source of the format: `facer_rgb.py` in
[acer-predator-turbo-and-rgb-keyboard-linux-module](https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module).
