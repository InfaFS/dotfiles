# Guía: setear los monitores en Hyprland (config Lua + caelestia)

> Estado de referencia: **2026-07-03**
> Hyprland 0.55.4 · driver Nvidia 610.43.02 (nvidia-open) · RTX 5070 Ti

Esta config usa Hyprland **en Lua** (no `.conf`). Los monitores se definen con
`hl.monitor({...})` en `~/.config/hypr/monitors.lua`.

---

## Hardware actual (referencia)

| Salida | Monitor | Resolución / Refresh | Posición | Rol |
|---|---|---|---|---|
| `DP-1`     | MSI **MPG271QX OLED** (610x340mm) | **2560x1440 @ 360Hz** | `0x0`      | Primario |
| `HDMI-A-1` | ASUS **VA24E** (530x300mm)        | 1920x1080 @ 75Hz      | `-1920x0`  | Secundario (izquierda) |

Modos máximos disponibles por salida:
- **DP-1 (OLED):** 2560x1440 @ 360 / 240 / 120 / 60 Hz
- **HDMI-A-1 (ASUS):** 1920x1080 @ 75 / 60 / 50 Hz (tope 75Hz)

---

## Cadena de carga (cómo llega monitors.lua a Hyprland)

```
hyprland.lua
  └─ require("hypr-user")            → ~/.config/caelestia/hypr-user.lua
       └─ require("monitors")        → ~/.config/hypr/monitors.lua   ← ACÁ se editan los monitores
```

---

## Pasos para configurar

### 1. Identificar las salidas reales de la máquina
```bash
hyprctl monitors
```
Anotá el **nombre de cada salida** (`DP-1`, `HDMI-A-1`, `DP-2`, etc.) y los
**modos disponibles** (`availableModes`). En otra PC / otros puertos los nombres
CAMBIAN — no asumas que son iguales que acá.

### 2. Editar `~/.config/hypr/monitors.lua`

Formato: `hl.monitor({ output, mode = "ANCHOxALTO@HZ", position = "XxY", scale })`

```lua
-- OLED principal (360Hz) en el origen 0x0 = primario
hl.monitor({
    output = "DP-1",
    mode = "2560x1440@360.0",
    position = "0x0",
    scale = 1.0,
})

-- Secundario, a la izquierda del OLED
hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@75.0",
    position = "-1920x0",
    scale = 1.0,
})
```

### 3. Aplicar
La config Lua se recarga al reiniciar Hyprland:
```bash
hyprctl reload
```
Si algo no toma, cerrar sesión y volver a entrar.

### 4. Verificar
```bash
hyprctl monitors | grep -E 'Monitor|@'
```
Confirmá resolución, refresh y posición de cada uno.

---

## ⚠️ Reglas importantes de ESTE setup

1. **El monitor en `position = "0x0"` es el primario.** Qt/Quickshell lo toma
   como primario y a él ata el reloj de animación. Por eso el OLED de 360Hz va
   en `0x0` → la barra de caelestia anima a 360Hz. Si ponés el de 75Hz en `0x0`,
   la barra anima a 75Hz.

2. **NO usar `nwg-displays`** (GUI de monitores): sobreescribe `monitors.lua` y
   pierde estas notas y el orden pensado.

3. **Posiciones = layout físico.** `-1920x0` pone al ASUS pegado a la izquierda
   del OLED (que arranca en x=0 y ocupa 0→2560). Si querés el secundario a la
   derecha: `position = "2560x0"`.

---

## Mejoras opcionales (a evaluar)

- **VRR / Adaptive Sync:** hoy está en `vrr: false` en ambos. Para gaming en el
  OLED puede convenir activarlo (menos tearing/stutter con FPS variable). Se
  activa global en la config de Hyprland (`misc { vrr = 1 }` o `= 2` para
  fullscreen-only), no en `monitors.lua`. El `= 2` (solo fullscreen) suele ser el
  más seguro para no romper el compositor en escritorio.

- **Bit depth / HDR:** el OLED soporta HDR. Hyprland tiene soporte experimental
  (`experimental { }` + color management). Hoy corre en `srgb` / 8-bit
  (`XRGB8888`). Dejar como está salvo que quieras meterte con HDR.

- **Refresh por uso:** si querés ahorrar (OLED burn-in / consumo) podés bajar a
  120Hz para trabajo y subir a 360Hz para jugar, cambiando el `mode`.

---

## Archivos relacionados (versionar / ignorar)

**Versionar:**
- `~/.config/hypr/monitors.lua`  ← este
- `~/.config/caelestia/hypr-user.lua`  (`require("monitors")`)
- `~/.config/caelestia/hypr-vars.lua`

**Ignorar (estado/backup, NO versionar):**
- `~/.config/hypr/*.bak`
- `~/.config/caelestia/monitors/*/shell.json`  (estado runtime, 4 bytes)
- `~/.config/hypr/scheme/current.lua`  (autogenerado)
