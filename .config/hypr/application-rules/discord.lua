-- Workspace differs per host (desktop: 3, laptop: 4) to match each host's
-- autostart placement.
local hostname_handle = io.popen("hostname")
local hostname = hostname_handle and hostname_handle:read("*l") or nil
if hostname_handle then hostname_handle:close() end

local workspace = hostname == "rutger-laptop-omarchy" and "4" or "3"
o.window("^discord$", { workspace = workspace })
