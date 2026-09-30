-- OneDrive rounds the mtime of uploaded files down to whole seconds, which nvim
-- sees as an external change. Ignore mtime changes while the content on disk is
-- still exactly what we last wrote.

local M = {}

local written = {}

local function disk_hash(file)
	return vim.fn.sha256(table.concat(vim.fn.readfile(file, "b"), "\n"))
end

local function unchanged_since_write(buf, file)
	return written[buf] ~= nil and vim.fn.filereadable(file) == 1 and disk_hash(file) == written[buf].hash
end

function M.setup()
	-- Write in place, so sync clients don't see a rename to file~ on every save
	vim.o.backupcopy = "yes"

	vim.api.nvim_create_autocmd("BufWritePost", {
		callback = function(args)
			written[args.buf] = { hash = disk_hash(args.file), mtime = vim.uv.fs_stat(args.file).mtime }
		end,
	})

	-- The write check compares against the mtime nvim recorded when writing, so restore it exactly
	vim.api.nvim_create_autocmd("BufWritePre", {
		callback = function(args)
			if not unchanged_since_write(args.buf, args.file) then
				return
			end
			local mtime = written[args.buf].mtime
			vim.system({ "touch", "-m", "-d", string.format("@%d.%09d", mtime.sec, mtime.nsec), args.file }):wait()
		end,
	})

	vim.api.nvim_create_autocmd("FileChangedShell", {
		callback = function(args)
			vim.v.fcs_choice = unchanged_since_write(args.buf, args.file) and "" or "ask"
		end,
	})

	vim.api.nvim_create_autocmd("BufDelete", {
		callback = function(args)
			written[args.buf] = nil
		end,
	})
end

return M
