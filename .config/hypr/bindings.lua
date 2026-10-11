-- gsr's own hotkeys are disabled: kanata grabs the keyboards and gsr skips kanata's virtual device
hl.unbind("SUPER + C")
o.bind("SUPER + SHIFT + C", "GSR show/hide", "gsr-ui-cli toggle-show")
o.bind("SUPER + C", "GSR save replay + share", "gsr-clip-share replay-save")

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

hl.unbind("SUPER + V")
o.bind("SUPER + V", "Type clipboard", type_clipboard)
