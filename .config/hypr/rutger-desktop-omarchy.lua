-- Host-specific setup for rutger-desktop-omarchy.
-- Ported from the old custom-rutger-desktop-omarchy.conf.

hl.on("hyprland.start", function()
  hl.exec_cmd("[workspace 2 silent] uwsm app -- zen-browser")

  -- Discord starts a popup initially, then the actual window that does not
  -- follow the workspace annotation.
  hl.exec_cmd("hyprctl dispatch workspace 3")
  hl.exec_cmd("[workspace 3 silent] uwsm app -- discord")

  hl.exec_cmd("[workspace 4 silent] uwsm app -- heroic")
end)

-- Never idle: no screensaver, no idle lock, no display sleep.
o.exec_on_start("omarchy toggle idle stay-awake")
