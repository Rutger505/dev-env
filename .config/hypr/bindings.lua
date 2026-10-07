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

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.rebind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.rebind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.rebind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + SHIFT + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + SHIFT + K", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + SHIFT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- The preinstalls-removed marker disables Omarchy's app bindings, and its launcher lacks the wayland flag
o.bind("SUPER + SHIFT + M", "Music", { focus = "spotify", launch = "spotify --ozone-platform=wayland" })
