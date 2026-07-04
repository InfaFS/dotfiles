#!/usr/bin/env bash
# Regenera los manifiestos de paquetes/servicios. Correr cada tanto.
set -euo pipefail
out="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/packages"
mkdir -p "$out"
pacman -Qqen  > "$out/pacman-native.txt"
pacman -Qqem  > "$out/aur.txt"
flatpak list --app --columns=application 2>/dev/null > "$out/flatpak.txt"
npm ls -g --depth=0 --parseable 2>/dev/null | tail -n +2 | xargs -n1 basename 2>/dev/null > "$out/npm-global.txt"
systemctl list-unit-files --state=enabled --no-legend 2>/dev/null | awk '{print $1}' > "$out/systemd-system-enabled.txt"
systemctl --user list-unit-files --state=enabled --no-legend 2>/dev/null | awk '{print $1}' > "$out/systemd-user-enabled.txt"
echo "Snapshot actualizado en $out"
wc -l "$out"/*.txt
