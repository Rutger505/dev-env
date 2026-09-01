-- Host-specific setup for rutger-laptop-omarchy.
-- Ported from the old custom-rutger-laptop-omarchy.conf.

hl.on("hyprland.start", function()
  hl.exec_cmd("[workspace 1 silent] uwsm app -- zen-browser")

  hl.exec_cmd("[workspace 3 silent] uwsm app -- ghostty")

  -- Discord starts a popup initially, then the actual window that does not
  -- follow the workspace annotation.
  hl.exec_cmd("hyprctl dispatch workspace 4")
  hl.exec_cmd("[workspace 4 silent] uwsm app -- discord")

  hl.exec_cmd("[workspace 5 silent] uwsm app -- spotify")
end)

-- https://wiki.hypr.land/Configuring/Performance/#how-do-i-make-hyprland-draw-as-little-power-as-possible-on-my-laptop
hl.config({
  decoration = {
    blur = { enabled = false },
    shadow = { enabled = false },
  },
})

-- NVIDIA environment variables (disabled for power optimalization)
-- hl.env("NVD_BACKEND", "direct")
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- Select iGPU for rendering and dGPU as backup.
hl.env("AQ_DRM_DEVICES", "/dev/dri/amd-igpu:/dev/dri/nvidia-dgpu")
hl.env("VK_ICD_FILENAMES", "/usr/share/vulkan/icd.d/radeon_icd.x86_64.json:/usr/share/vulkan/icd.d/nvidia_icd.json")
