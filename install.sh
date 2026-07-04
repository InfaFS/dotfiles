#!/usr/bin/env bash
# Reproduce esta instalación de CachyOS en una máquina nueva.
# Uso: bash install.sh
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/packages"

echo "==> 1. Paquetes nativos del repo (pacman)"
sudo pacman -S --needed --noconfirm - < "$DIR/pacman-native.txt"

echo "==> 2. Asegurar un helper del AUR (yay)"
if ! command -v yay >/dev/null; then
  sudo pacman -S --needed --noconfirm git base-devel
  tmp="$(mktemp -d)"; git clone https://aur.archlinux.org/yay.git "$tmp/yay"
  (cd "$tmp/yay" && makepkg -si --noconfirm)
fi

echo "==> 3. Paquetes del AUR"
yay -S --needed --noconfirm - < "$DIR/aur.txt"

echo "==> 4. Flatpaks (si hay)"
if [ -s "$DIR/flatpak.txt" ]; then
  xargs -a "$DIR/flatpak.txt" -r flatpak install -y flathub
fi

echo "==> 5. npm globales (si hay)"
if [ -s "$DIR/npm-global.txt" ]; then
  # se saltea npm/node-gyp/etc que ya vienen con nodejs
  grep -vE '^(npm|node-gyp|nopt|semver)$' "$DIR/npm-global.txt" | xargs -r sudo npm install -g
fi

echo "==> 6. Servicios systemd (system)"
while read -r unit; do
  [ -z "$unit" ] && continue
  sudo systemctl enable "$unit" 2>/dev/null || echo "   (omitido: $unit)"
done < "$DIR/systemd-system-enabled.txt"

echo "==> Listo. Revisá los servicios de usuario a mano en systemd-user-enabled.txt"
echo "==> Los dotfiles (~/.config, fish, hypr, etc.) se restauran aparte con tu gestor de dotfiles."
