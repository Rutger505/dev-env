-- Autostarted apps would otherwise pull focus to their workspaces while booting
hl.on("hyprland.start", function()
  local no_focus = hl.window_rule({ match = { class = ".*" }, no_initial_focus = true })
  hl.config({ misc = { focus_on_activate = false } })

  hl.timer(function()
    no_focus:set_enabled(false)
    hl.config({ misc = { focus_on_activate = true } })
  end, { timeout = 15000, type = "oneshot" })
end)
