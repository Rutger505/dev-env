-- OneDrive rounds the mtime of uploaded files down to whole seconds, which nvim
-- sees as an external change. Ignore mtime changes while the content on disk is
-- still exactly what nvim last read or wrote.

local M = {}

local known = {}

local function disk_hash(file)
	return vim.fn.sha256(table.concat(vim.fn.readfile(file, "b"), "\n"))
end

local function unchanged_on_disk(buf, file)
	return known[buf] ~= nil and vim.fn.filereadable(file) == 1 and disk_hash(file) == known[buf].hash
end

function M.setup()
	-- Write in place, so sync clients don't see a rename to file~ on every save
	vim.o.backupcopy = "yes"

	vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
		callback = function(args)
			local stat = vim.uv.fs_stat(args.match)
			known[args.buf] = stat and { hash = disk_hash(args.match), mtime = stat.mtime } or nil
		end,
	})

	-- The write check compares against the mtime nvim recorded when reading or writing, so restore it exactly
	vim.api.nvim_create_autocmd("BufWritePre", {
		callback = function(args)
			if not unchanged_on_disk(args.buf, args.match) then
				return
			end
			local mtime = known[args.buf].mtime
			vim.system({ "touch", "-m", "-d", string.format("@%d.%09d", mtime.sec, mtime.nsec), args.match }):wait()
		end,
	})

	vim.api.nvim_create_autocmd("FileChangedShell", {
		callback = function(args)
			vim.v.fcs_choice = unchanged_on_disk(args.buf, args.match) and "" or "ask"
		end,
	})

	vim.api.nvim_create_autocmd("BufDelete", {
		callback = function(args)
			known[args.buf] = nil
		end,
	})
end

return M
