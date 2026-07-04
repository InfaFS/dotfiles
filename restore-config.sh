#!/usr/bin/env bash
# Restaura las configs de ~/.config desde el repo.
# Uso: bash restore-config.sh
# Hace backup de lo que ya exista antes de sobrescribir.
set -euo pipefail
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/config"
DST="$HOME/.config"
mkdir -p "$DST"

# Backup de lo actual (por si estás restaurando sobre un sistema con configs)
if [ -d "$DST" ] && [ -n "$(ls -A "$DST" 2>/dev/null)" ]; then
  bak="$HOME/.config.backup-$(date +%Y%m%d-%H%M%S)"
  echo "==> Backup de ~/.config actual en: $bak"
  cp -a "$DST" "$bak"
fi

echo "==> Copiando configs del repo a ~/.config"
cp -a "$SRC/." "$DST/"

echo "==> Listo. Reiniciá la sesión (o 'hyprctl reload') para aplicar."
