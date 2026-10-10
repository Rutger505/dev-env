hl.on("hyprland.start", function()
  hl.exec_cmd("[workspace 2 silent] uwsm app -- zen-browser")

  hl.exec_cmd("uwsm app -- discord")

  hl.exec_cmd("[workspace 4 silent] uwsm app -- heroic")
end)

o.exec_on_start("omarchy toggle idle stay-awake")

-- Discord's real window appears after a popup and ignores the exec workspace annotation
o.window("^discord$", { workspace = "3 silent" })
