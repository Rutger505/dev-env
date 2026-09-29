hl.on("hyprland.start", function()
  hl.exec_cmd("[workspace 2 silent] uwsm app -- zen-browser")

  -- Discord's real window appears after a popup and ignores the workspace annotation
  hl.exec_cmd("hyprctl dispatch workspace 3")
  hl.exec_cmd("[workspace 3 silent] uwsm app -- discord")

  hl.exec_cmd("[workspace 4 silent] uwsm app -- heroic")
end)

o.exec_on_start("omarchy toggle idle stay-awake")

o.window("^discord$", { workspace = "3" })
