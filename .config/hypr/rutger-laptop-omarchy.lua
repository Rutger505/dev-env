local autostart = require("hypr.autostart")

hl.on("hyprland.start", function()
  autostart.launch(1, "^zen$", autostart.after_network("zen-browser"))

  -- Racing tmux.service makes the shell's tmux fail with "duplicate session: 0", or
  -- leaves an extra tmux process that makes continuum skip the restore
  autostart.launch(3, "^com\\.mitchellh\\.ghostty$", "systemctl --user start tmux.service; uwsm app -- ghostty")

  autostart.launch(4, "^discord$", autostart.after_network("discord"))
  autostart.launch(4, "^chrome-www\\.snapchat\\.com__web-", "uwsm app -- Snapchat.desktop")

  autostart.launch(5, "^org\\.omarchy\\.spotatui$", "systemctl --user start tmux.service; " .. autostart.after_network("xdg-terminal-exec --app-id=org.omarchy.spotatui -e tmux new-session -A -s spotatui spotatui"))
end)

-- https://wiki.hypr.land/Configuring/Performance/#how-do-i-make-hyprland-draw-as-little-power-as-possible-on-my-laptop
hl.config({
  decoration = {
    blur = { enabled = false },
    shadow = { enabled = false },
  },
})

-- Omarchy's default/hypr/nvidia.lua forces these to nvidia, which wakes the dGPU
-- for every GLX/VA-API client. Host config loads after it, so override them back.
hl.env("__GLX_VENDOR_LIBRARY_NAME", "mesa")
hl.env("LIBVA_DRIVER_NAME", "radeonsi")
hl.env("VDPAU_DRIVER", "radeonsi")

-- dGPU left out entirely: aquamarine opens any DRM device it is given, and
-- vkEnumeratePhysicalDevices initialises every listed ICD, both of which
-- resume it from D3cold. Vulkan apps therefore only see the iGPU.
hl.env("AQ_DRM_DEVICES", "/dev/dri/amd-igpu")
hl.env("VK_ICD_FILENAMES", "/usr/share/vulkan/icd.d/radeon_icd.json")