return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		ft = { "rust" },
		init = function()
			vim.g.rustaceanvim = {
				server = {
					capabilities = require("blink.cmp").get_lsp_capabilities(),
					default_settings = {
						["rust-analyzer"] = {
							check = { command = "clippy" },
						},
					},
				},
			}
		end,
	},
	{
		"saecki/crates.nvim",
		event = "BufRead Cargo.toml",
		opts = {},
	},
}
