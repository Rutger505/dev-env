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
				"copilot",
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

			-- Next edit suggestions apply edits at positions the server computed. With the
			-- default 150ms debounce the server's document lags the buffer while typing, so
			-- those positions land in the wrong place and scramble the text.
			vim.lsp.config("copilot", { flags = { debounce_text_changes = 0 } })

			-- Enable all servers installed via mason-lspconfig
			vim.lsp.enable(require("mason-lspconfig").get_installed_servers())

			vim.lsp.inline_completion.enable()
		end,
	},
}
