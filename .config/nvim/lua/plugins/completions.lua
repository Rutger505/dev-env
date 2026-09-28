return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = { 'rafamadriz/friendly-snippets' },
		opts = {
			keymap = {
				preset = "none",
				["<C-Space>"] = { "show", "fallback" },
				["<C-e>"] = { "hide", "fallback" },
				["<C-y>"] = { "accept", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<M-y>"] = {
					-- Leave insert mode first: sidekick's jump runs `normal! m'`, which mangles
					-- the buffer when it interrupts a pending insert.
					function()
						if not require("sidekick.nes").have() then
							return false
						end
						vim.cmd("stopinsert")
						vim.schedule(function() require("sidekick").nes_jump_or_apply() end)
						return true
					end,
					"fallback",
				},
				["<M-l>"] = {
					function() return vim.lsp.inline_completion.get() end,
					"fallback",
				},
				["<Tab>"] = { "fallback" },
				["<S-Tab>"] = { "fallback" },
			},
			sources = {
				default = { "lsp", "snippets", "buffer", "path" },
			},
			completion = {
				documentation = { auto_show = true },
			},
		},
	},
}
