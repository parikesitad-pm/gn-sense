#!/usr/bin/env bash
# Install gn-sense for the current user: Quickshell config + `gn-sense` launcher.
#   ./install.sh          copy into ~/.config/quickshell/gn-sense
#   ./install.sh --link   symlink this checkout instead (for development)
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/gn-sense"
bin="$HOME/.local/bin"

missing=()
for cmd in qs powerprofilesctl dbus-monitor; do command -v "$cmd" >/dev/null || missing+=("$cmd"); done
if [ ${#missing[@]} -gt 0 ]; then
  echo "Missing: ${missing[*]}"
  echo "Install Quickshell, power-profiles-daemon and dbus, then run this again."
  exit 1
fi
fc-list | grep -qi "JetBrainsMono Nerd" || echo "Note: icons need JetBrainsMono Nerd Font."

mkdir -p "$(dirname "$dest")" "$bin"
if [ "${1:-}" = "--link" ]; then
  ln -sfn "$here" "$dest"
else
  rm -rf "$dest"
  mkdir -p "$dest"
  cp -r "$here"/*.qml "$here"/qmldir "$here"/scripts "$dest"/
fi
install -m 755 "$here/bin/gn-sense" "$bin/gn-sense"

echo "Installed to $dest"
if [ -w /dev/acer-gkbbl-0 ]; then
  echo "Keyboard RGB: driver found."
else
  echo "Keyboard RGB: /dev/acer-gkbbl-0 not found. Power profiles work; for lighting install"
  echo "  https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module"
fi
echo
echo "Start it with your session:   qs -c gn-sense -n -d"
echo "Open or close the panel:      gn-sense"
echo "Bind the N key (Hyprland):    bind = , code:433, exec, gn-sense"
