# Adding a model

Most Nitro and Predator models with a 4-zone keyboard should work once the facer module loads.
What changes between models is usually the N (or Predator) key code.

## 1. Check the driver

```sh
lsmod | grep facer
ls -l /dev/acer-gkbbl-0 /dev/acer-gkbbl-static-0
```

Both devices must exist. If the colors do not change, reload the module with
`sudo modprobe facer rgb_ec_enable=1` and try again.

## 2. Find the key code

```sh
sudo evtest
```

Pick the keyboard (usually "AT Translated Set 2 keyboard"), press the N key, and note the
`code` value of the `EV_KEY` line. Add 8 to get the compositor keycode: on the AN515-56 the key
is code 425 (`KEY_PRESENTATION`), so the bind uses keycode 433.

If `evtest` shows only an `MSC_SCAN` line with no `EV_KEY`, the key has no Linux key yet. A udev
hwdb entry can map it; include the scancode in your report.

## 3. Test the effects

Open gn-sense and try Static with four different colors, then Breath, Shifting (both directions)
and Off. Note anything that does not match the preview.

## 4. Report

Open an issue with:

- the model name (from `cat /sys/class/dmi/id/product_name`),
- the output of step 1,
- the key code from step 2,
- which effects work.

Confirmed models are added to the "Tested on" table in the README.
