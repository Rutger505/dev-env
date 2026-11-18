local autostart = require("hypr.autostart")

hl.on("hyprland.start", function()
  -- Engine for workstation-connect. In its app unit: the RemoteDesktop portal (trackpad) needs its app ID
  hl.exec_cmd("systemctl --user start app-org.kde.kdeconnect.daemon@autostart.service")

  autostart.launch(2, "^zen$", autostart.after_network("zen-browser"))

  autostart.launch(3, "^discord$", autostart.after_network("discord"))
end)

o.exec_on_start("omarchy toggle idle stay-awake")

hl.unbind("XF86PowerOff")
o.bind("XF86PowerOff", "Shutdown", "omarchy-system-shutdown", { locked = true })
