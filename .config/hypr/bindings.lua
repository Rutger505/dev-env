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

-- The preinstalls-removed marker disables Omarchy's app bindings, and its launcher lacks the wayland flag
o.bind("SUPER + SHIFT + M", "Music", { focus = "spotify", launch = "spotify --ozone-platform=wayland" })

-- Omarchy's send_key_state only fakes the modifier state, so apps that read raw keys (noVNC) never see Ctrl.
-- ydotool sends real keys, but Hyprland merges a held Super into them, so wait until Super is released.
local keycodes = { ctrl = 29, shift = 42, c = 46, v = 47 }

local function key_chord(...)
  local presses, releases = {}, {}
  for _, key in ipairs({ ... }) do
    table.insert(presses, keycodes[key] .. ":1")
    table.insert(releases, 1, keycodes[key] .. ":0")
  end
  return "ydotool key " .. table.concat(presses, " ") .. " " .. table.concat(releases, " ")
end

local function after_super_released(command)
  if hl.is_key_down("Super_L") or hl.is_key_down("Super_R") then
    hl.timer(function()
      after_super_released(command)
    end, { timeout = 10, type = "oneshot" })
  else
    hl.exec_cmd(command)
  end
end

local function is_terminal(window)
  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end
  return false
end

local function is_vnc_console(window)
  return window.title:find("Proxmox") or window.title:find("noVNC")
end

-- A VNC console can't read the host clipboard, so paste types it out instead
local function universal_clipboard(key)
  return function()
    local window = hl.get_active_window()
    if key == "v" and window and is_vnc_console(window) then
      after_super_released("wl-paste --no-newline | ydotool type --file -")
    elseif window and is_terminal(window) then
      after_super_released(key_chord("ctrl", "shift", key))
    else
      after_super_released(key_chord("ctrl", key))
    end
  end
end

o.rebind("SUPER + C", "Universal copy", universal_clipboard("c"))
o.rebind("SUPER + V", "Universal paste", universal_clipboard("v"))
