local INLINE_COMPLETION = "textDocument/inlineCompletion"

-- Disabling inline completion drops its state, so a response to a request still in
-- flight would error. Cancelled requests get no response.
local function disable_inline_completion(buf)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, method = INLINE_COMPLETION })) do
		for id, request in pairs(client.requests) do
			if request.bufnr == buf and request.method == INLINE_COMPLETION then
				client:cancel_request(id)
			end
		end
	end
	vim.lsp.inline_completion.enable(false, { bufnr = buf })
end

local function hide_ai_suggestions_while_menu_open(ev)
	local buf = ev.buf
	local nes = require("sidekick.nes")

	if require("blink.cmp").is_menu_visible() then
		if vim.lsp.inline_completion.is_enabled({ bufnr = buf }) then
			disable_inline_completion(buf)
		end
		vim.b[buf].sidekick_nes = false
		nes.clear()
	else
		vim.lsp.inline_completion.enable(true, { bufnr = buf })
		if vim.b[buf].sidekick_nes == false then
			vim.b[buf].sidekick_nes = nil
			nes.update()
		end
	end
end

local function accept_next_edit()
	if not require("sidekick.nes").have() then
		return false
	end
	-- Leave insert mode first: sidekick's jump runs `normal! m'`, which mangles
	-- the buffer when it interrupts a pending insert.
	vim.cmd("stopinsert")
	vim.schedule(function() require("sidekick").nes_jump_or_apply() end)
	return true
end

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
				["<C-y>"] = {
					"accept",
					function() return vim.lsp.inline_completion.get() end,
					accept_next_edit,
					"fallback",
				},
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
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
		config = function(_, opts)
			require("blink.cmp").setup(opts)
			vim.api.nvim_create_autocmd("User", {
				pattern = { "BlinkCmpMenuOpen", "BlinkCmpMenuClose" },
				callback = hide_ai_suggestions_while_menu_open,
			})
		end,
	},
}
