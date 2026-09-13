return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		ft = { "rust" },
		init = function()
			vim.g.rustaceanvim = {
				server = {
					-- Always use stable's binary: custom toolchains like esp ship without
					-- rust-analyzer. A direct path (not `rustup run`) keeps cargo on the
					-- project's own toolchain.
					cmd = function()
						return { vim.trim(vim.fn.system({ "rustup", "which", "--toolchain", "stable", "rust-analyzer" })) }
					end,
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
