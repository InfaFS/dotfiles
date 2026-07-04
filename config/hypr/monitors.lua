-- Configuracion de monitores (editada a mano - NO usar nwg-displays,
-- lo sobreescribiria). Se carga via hypr-user.lua -> require("monitors").
--
-- Formato:  hl.monitor({ output, mode = "ANCHOxALTO@HZ", position = "XxY", scale })
-- Ver modos disponibles de cada salida con:  hyprctl monitors
--
-- IMPORTANTE: el monitor que este en position "0x0" es el que Qt/Quickshell
-- toma como primario, y a el ata el reloj de animacion. Por eso el OLED de
-- 360Hz va en 0x0 -> la barra de caelestia anima a 360Hz.

-- OLED principal (360Hz) en el origen 0x0 = primario
hl.monitor({
    output = "DP-1",
    mode = "2560x1440@360.0",   -- modos: 360 / 240 / 120 / 60
    position = "0x0",
    scale = 1.0,
})

-- Monitor secundario, a la izquierda del OLED
hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@75.0",    -- soporta hasta 75Hz: "1920x1080@75.0"
    position = "-1920x0",
    scale = 1.0,
})
