return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = { "Telescope" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		opts = {},
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {},
	},

	{
		"NMAC427/guess-indent.nvim",
		event = "BufReadPost",
		opts = {},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"echasnovski/mini.trailspace",
		version = "*",
		event = "BufReadPre",
		opts = {},
	},

	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				markdown = { "prettier" },
			},
			format_on_save = {
				timeout_ms = 1000,
			},
		},
	},

	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	{
		"folke/todo-comments.nvim",
		event = "BufReadPre",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
}
