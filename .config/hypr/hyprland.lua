dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

require("default.hypr.omarchy")

require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

local paths = require("default.hypr.paths")
local hypr_dir = paths.config_home .. "/hypr"

local hostname = io.popen("hostname"):read("*l")
if io.open(hypr_dir .. "/" .. hostname .. ".lua") then
  require("hypr." .. hostname)
end

require("default.hypr.toggles")

-- Omarchy's require_all.files() uses `find -type f`, which skips the stowed symlinks
local rules = io.popen("find -L '" .. hypr_dir .. "/application-rules' -maxdepth 1 -type f -name '*.lua' -printf '%f\\n' | sort")
for filename in rules:lines() do
  require("hypr.application-rules." .. filename:gsub("%.lua$", ""))
end
rules:close()
