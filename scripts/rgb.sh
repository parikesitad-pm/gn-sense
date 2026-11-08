#!/usr/bin/env bash
# Keyboard RGB for Acer Nitro/Predator laptops through the facer module.
# usage: rgb.sh off
#        rgb.sh zones RRGGBB RRGGBB RRGGBB RRGGBB BRIGHTNESS        (zones left to right)
#        rgb.sh effect MODE SPEED BRIGHTNESS [RRGGBB] [DIRECTION]  (1 breath, 2 neon, 3 wave, 4 shifting, 5 zoom)
# Exits quietly when the module is not loaded.
DEV=/dev/acer-gkbbl-0
STATIC=/dev/acer-gkbbl-static-0
[ -w "$DEV" ] || exit 0

bytes() { local out=""; for b in "$@"; do out+=$(printf '\\%03o' "$b"); done; printf "$out"; }
rgb() { echo $((16#${1:0:2})) $((16#${1:2:2})) $((16#${1:4:2})); }

case "$1" in
  off)
    bytes 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 > "$DEV" ;;
  zones)
    colors=("$2" "$3" "$4" "$5")
    for z in 0 1 2 3; do bytes $((1 << z)) $(rgb "${colors[$z]}") > "$STATIC"; done
    bytes 0 0 "$6" 0 0 0 0 0 0 1 0 0 0 0 0 0 > "$DEV" ;;
  effect)
    read -r r g b <<< "$(rgb "${5:-000000}")"
    wave=0; [ "$2" = 3 ] && wave=8
    bytes "$2" "$3" "$4" "$wave" "${6:-1}" "$r" "$g" "$b" 0 1 0 0 0 0 0 0 > "$DEV" ;;
  *) echo "usage: rgb.sh off | zones C1 C2 C3 C4 BRIGHT | effect MODE SPEED BRIGHT [RRGGBB] [DIR]" >&2; exit 1 ;;
esac
