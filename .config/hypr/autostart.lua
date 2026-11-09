local autostart = {}
local workspace_rules = {}

-- Autostarted apps would otherwise pull focus to their workspaces while booting
hl.on("hyprland.start", function()
  local no_focus = hl.window_rule({ match = { class = ".*" }, no_initial_focus = true })
  hl.config({ misc = { focus_on_activate = false } })

  hl.timer(function()
    no_focus:set_enabled(false)
    hl.config({ misc = { focus_on_activate = true } })
  end, { timeout = 15000, type = "oneshot" })

  hl.timer(function()
    for _, rule in ipairs(workspace_rules) do
      rule:set_enabled(false)
    end
  end, { timeout = 60000, type = "oneshot" })
end)

-- A window rule instead of the [workspace N] exec annotation, which only matches processes
-- Hyprland spawned itself and so misses apps started as uwsm services or handed off to a browser
function autostart.launch(workspace, class, command)
  table.insert(workspace_rules, hl.window_rule({ match = { class = class }, workspace = workspace .. " silent" }))
  hl.exec_cmd(command)
end

function autostart.after_network(command)
  return "uwsm app -t service -p Wants=network-online.target -p After=network-online.target -- " .. command
end

return autostart
