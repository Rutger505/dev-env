return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = { "Neotree" },
		init = function()
			local root = vim.fn.argc() > 0 and vim.fn.fnamemodify(vim.fn.argv(0), ":p:h") or vim.fn.getcwd()
			vim.api.nvim_create_autocmd({ "VimEnter", "TabNew" }, {
				callback = function()
					require("neo-tree.command").execute({ action = "show", dir = root })
				end,
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			window = {
				mappings = {
					["<space>"] = "noop",
				},
			},
			filesystem = {
				bind_to_cwd = false,
				hijack_netrw_behavior = "disabled",
				use_libuv_file_watcher = true,
			},
		},
	},
}

