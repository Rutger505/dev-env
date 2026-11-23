local autostart = {}
local workspace_rules = {}
local booting = true

-- Autostarted apps would otherwise pull focus to their workspaces while booting
hl.on("hyprland.start", function()
  local no_focus = hl.window_rule({ match = { class = ".*" }, no_initial_focus = true })
  hl.config({ misc = { focus_on_activate = false } })

  hl.timer(function()
    no_focus:set_enabled(false)
    hl.config({ misc = { focus_on_activate = true } })
  end, { timeout = 15000, type = "oneshot" })

  hl.timer(function()
    booting = false
    for _, rule in ipairs(workspace_rules) do
      rule:set_enabled(false)
    end
  end, { timeout = 60000, type = "oneshot" })
end)

-- A window rule instead of the [workspace N] exec annotation, which only matches processes
-- Hyprland spawned itself and so misses apps started as uwsm services or handed off to a browser
local function send_to_workspace(workspace, class)
  table.insert(workspace_rules, hl.window_rule({ match = { class = class }, workspace = workspace .. " silent" }))
end

function autostart.launch(workspace, class, command)
  send_to_workspace(workspace, class)
  hl.exec_cmd(command)
end

-- Omarchy gives every monitor its own block of ten workspaces (see its monitor-workspaces.lua). Pins the
-- workspace to its monitor, else Hyprland opens it on the focused one. Hyprland starts with only the first
-- monitor added, so the others are resolved when they arrive
function autostart.launch_on(monitor_name, slot, class, command)
  local pinned = false

  local function pin()
    local monitor = hl.get_monitor(monitor_name)
    if pinned or not booting or not monitor then
      return
    end
    pinned = true

    local workspace = o.workspaces.workspace_id(monitor, slot)
    hl.workspace_rule({ workspace = tostring(workspace), monitor = monitor.name })
    send_to_workspace(workspace, class)
  end

  hl.on("monitor.added", pin)
  pin()
  hl.exec_cmd(command)
end

function autostart.after_network(command)
  return "uwsm app -t service -p Wants=network-online.target -p After=network-online.target -- " .. command
end

return autostart
