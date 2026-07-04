# Snapshot de mi instalación CachyOS

Manifiesto reproducible del sistema. Recrea la parte de **paquetes/servicios**.
Los **dotfiles** (configs de `~/.config`) van aparte con chezmoi/stow.

## Contenido

| Archivo | Qué es | Cómo se generó |
|---|---|---|
| `packages/pacman-native.txt` | Paquetes del repo instalados explícitamente | `pacman -Qqen` |
| `packages/aur.txt` | Paquetes del AUR | `pacman -Qqem` |
| `packages/flatpak.txt` | Apps flatpak | `flatpak list --app` |
| `packages/npm-global.txt` | Binarios npm globales | `npm ls -g` |
| `packages/systemd-system-enabled.txt` | Servicios de sistema activados | `systemctl list-unit-files --state=enabled` |
| `packages/systemd-user-enabled.txt` | Servicios de usuario activados | `systemctl --user ...` |

## Restaurar en una máquina nueva

Partiendo de una CachyOS recién instalada:

```bash
git clone <este-repo> ~/dotfiles && cd ~/dotfiles
bash install.sh
```

## Refrescar el snapshot (correr cada tanto)

```bash
bash snapshot.sh
git add packages && git commit -m "snapshot $(date +%F)"
```

## Notas

- Solo se guardan paquetes **explícitos**; las dependencias las resuelve pacman sola.
- El driver Nvidia (`nvidia-open`), kernel CachyOS y `nvidia-utils` están en `pacman-native.txt`.
- Revisá `systemd-user-enabled.txt` a mano: varios servicios de usuario los activa el propio entorno.
