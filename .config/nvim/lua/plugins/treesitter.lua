return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				"bash",
				"lua",
				"markdown",
				"markdown_inline",
				"vim",
				"vimdoc",
			})
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					if pcall(vim.treesitter.start, args.buf) then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
}
