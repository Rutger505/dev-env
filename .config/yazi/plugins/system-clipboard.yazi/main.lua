local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, file in pairs(tab.selected) do
		paths[#paths + 1] = tostring(file.url)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

local function notify(content, level)
	ya.notify({ title = "System Clipboard", content = content, level = level, timeout = 5 })
end

local function mime_type(path)
	local output = Command("file"):arg({ "--brief", "--mime-type", path }):stdout(Command.PIPED):output()
	return output and output.stdout:gsub("%s+$", "") or ""
end

local function file_uri(path)
	return "file://" .. path:gsub("[^%w%-%._~/]", function(char)
		return string.format("%%%02X", char:byte())
	end)
end

-- Pasting into browsers and chat apps only works with the image data itself, not a file URI.
local function copy_command(paths)
	local mime = #paths == 1 and mime_type(paths[1]) or ""
	if mime:match("^image/") then
		return Command("sh"):arg({ "-c", 'exec wl-copy --type "$1" < "$2"', "sh", mime, paths[1] })
	end

	local uris = {}
	for i, path in ipairs(paths) do
		uris[i] = file_uri(path)
	end
	return Command("wl-copy"):arg({ "--type", "text/uri-list", table.concat(uris, "\r\n") })
end

return {
	entry = function()
		ya.emit("escape", { visual = true })

		local paths = selected_or_hovered()
		if #paths == 0 then
			return notify("No file selected", "warn")
		end

		-- wl-copy forks a child that serves the clipboard; inherited pipes would block until it exits.
		local status, err = copy_command(paths)
			:stdin(Command.NULL)
			:stdout(Command.NULL)
			:stderr(Command.NULL)
			:status()

		if status and status.success then
			notify(string.format("Copied %d file(s)", #paths), "info")
		else
			notify("Could not copy: " .. (status and tostring(status.code) or tostring(err)), "error")
		end
	end,
}
