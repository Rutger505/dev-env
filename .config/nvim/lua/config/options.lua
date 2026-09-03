require("config.remote_clipboard").setup()
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.showmode = false

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.scrolloff = 10

vim.o.cursorline = true

vim.opt.termguicolors = true

vim.o.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

vim.opt.tabstop = 4

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.spell = true
vim.opt.spelllang = { "en_us", "nl" }

-- Defer communicating to system clipboard after startup
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Equalize splits when the window is resized
vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		vim.cmd("wincmd =")
	end,
})
