hl.on("hyprland.start", function()
  hl.exec_cmd("[workspace 1 silent] uwsm app -- zen-browser")

  hl.exec_cmd("[workspace 3 silent] uwsm app -- ghostty")

  hl.exec_cmd("uwsm app -- discord")
  hl.exec_cmd("[workspace 4 silent] uwsm app -- Snapchat.desktop")

  hl.exec_cmd("[workspace 5 silent] uwsm app -- spotify --ozone-platform=wayland")
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

-- Discord's real window appears after a popup and ignores the exec workspace annotation
o.window("^discord$", { workspace = "4 silent" })
