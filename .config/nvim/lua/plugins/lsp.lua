return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
		opts = {},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		event = "BufReadPre",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"lua_ls",
				"neocmake",
				"vtsls",
				"eslint",
				"tailwindcss",
				"jsonls",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Set capabilities globally for all servers
			vim.lsp.config("*", { capabilities = capabilities })

			-- Enable all servers installed via mason-lspconfig
			vim.lsp.enable(require("mason-lspconfig").get_installed_servers())
		end,
	},
}
