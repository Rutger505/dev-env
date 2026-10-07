-- gsr's own hotkeys are disabled: kanata grabs the keyboards and gsr skips kanata's virtual device
o.bind("ALT + Z", "GSR show/hide", "gsr-ui-cli toggle-show")
o.bind("ALT + F7", "GSR pause/unpause recording", "gsr-ui-cli toggle-pause")
o.bind("ALT + F8", "GSR start/stop streaming", "gsr-ui-cli toggle-stream")
o.bind("ALT + F9", "GSR start/stop recording", "gsr-ui-cli toggle-record")
o.bind("ALT + CONTROL + F9", "GSR record window", "gsr-ui-cli toggle-record-window")
o.bind("ALT + SHIFT + F9", "GSR record region", "gsr-ui-cli toggle-record-region")
o.bind("ALT + CONTROL + F10", "GSR start/stop replay", "gsr-ui-cli toggle-replay")
o.bind("ALT + F10", "GSR save replay + share", "gsr-clip-share replay-save")
o.bind("ALT + F11", "GSR save replay (1 min) + share", "gsr-clip-share replay-save-1-min")
o.bind("ALT + F12", "GSR save replay (10 min) + share", "gsr-clip-share replay-save-10-min")
o.bind("PRINT", "GSR screenshot", "gsr-ui-cli take-screenshot")
o.bind("ALT + CONTROL + PRINT", "GSR screenshot window", "gsr-ui-cli take-screenshot-window")
o.bind("ALT + SHIFT + PRINT", "GSR screenshot region", "gsr-ui-cli take-screenshot-region")

-- The autoclicker runs on XWayland and can't see global key presses on Wayland
o.bind("ALT + F6", "Autoclicker toggle", "useful-autoclicker --toggle")

hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- The preinstalls-removed marker disables Omarchy's app bindings, and its launcher lacks the wayland flag
o.bind("SUPER + SHIFT + M", "Music", { focus = "spotify", launch = "spotify --ozone-platform=wayland" })

-- Hyprland merges a held Super into the injected keys and runs Super + letter binds, so type after it's released
local function type_clipboard()
  if hl.is_key_down("Super_L") or hl.is_key_down("Super_R") then
    hl.timer(type_clipboard, { timeout = 10, type = "oneshot" })
  else
    -- ydotool indexes its ASCII keymap with signed bytes, so non-ASCII input would press arbitrary keys
    hl.exec_cmd("wl-paste --no-newline --type text | tr -cd '\\t\\n\\40-\\176' | ydotool type --file -")
  end
end

hl.unbind("SUPER + C")
hl.unbind("SUPER + V")
o.bind("SUPER + V", "Type clipboard", type_clipboard)
