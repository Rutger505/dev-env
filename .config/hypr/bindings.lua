-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- GPU Screen Recorder
-- gsr's own evdev hotkeys are disabled (main.hotkeys_enable_option
-- disable_hotkeys) because kanata grabs the physical keyboards and gsr skips
-- kanata's virtual device as "might be a mouse", so it can never grab anything.
-- See applications/packages/kanata.sh. We bind the same actions to gsr-ui-cli
-- in Hyprland instead. (Ported back from the old bindings.conf, lost in the
-- .conf -> .lua migration.)
o.bind("ALT + Z", "GSR show/hide", "gsr-ui-cli toggle-show")
o.bind("ALT + F7", "GSR pause/unpause recording", "gsr-ui-cli toggle-pause")
o.bind("ALT + F8", "GSR start/stop streaming", "gsr-ui-cli toggle-stream")
o.bind("ALT + F9", "GSR start/stop recording", "gsr-ui-cli toggle-record")
o.bind("ALT + CONTROL + F9", "GSR record window", "gsr-ui-cli toggle-record-window")
o.bind("ALT + SHIFT + F9", "GSR record region", "gsr-ui-cli toggle-record-region")
o.bind("ALT + CONTROL + F10", "GSR start/stop replay", "gsr-ui-cli toggle-replay")
-- Replay-save also uploads the clip to the CDN and copies the URL to the
-- clipboard (gsr-clip-share wrapper).
o.bind("ALT + F10", "GSR save replay + share", "gsr-clip-share replay-save")
o.bind("ALT + F11", "GSR save replay (1 min) + share", "gsr-clip-share replay-save-1-min")
o.bind("ALT + F12", "GSR save replay (10 min) + share", "gsr-clip-share replay-save-10-min")
o.bind("PRINT", "GSR screenshot", "gsr-ui-cli take-screenshot")
o.bind("ALT + CONTROL + PRINT", "GSR screenshot window", "gsr-ui-cli take-screenshot-window")
o.bind("ALT + SHIFT + PRINT", "GSR screenshot region", "gsr-ui-cli take-screenshot-region")

-- Omarchy's preinstalled-app bindings are all disabled by the
-- ~/.local/state/omarchy/preinstalls-removed marker, so rebind the ones for
-- apps we do keep installed.
o.bind("SUPER + SHIFT + M", "Music", { omarchy = "spotify" })
