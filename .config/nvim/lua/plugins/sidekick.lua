-- Sidekick links its diff colors to DiffText/DiffDelete, which most themes make too dim
-- to tell apart. Derive clearly green/red backgrounds from the theme's Added/Removed
-- colors instead, so it keeps working after a theme switch.
local function blend(color, base, alpha)
  local mixed = 0
  for shift = 0, 16, 8 do
    local c = bit.band(bit.rshift(color, shift), 0xff)
    local b = bit.band(bit.rshift(base, shift), 0xff)
    mixed = mixed + bit.lshift(math.floor(c * alpha + b * (1 - alpha) + 0.5), shift)
  end
  return mixed
end

local function set_diff_highlights()
  local function hl(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
  -- Normal has no bg with a transparent terminal
  local base = hl("Normal").bg or (vim.o.background == "light" and 0xffffff or 0x000000)
  local added = hl("Added").fg or 0x00ff00
  local removed = hl("Removed").fg or 0xff0000

  vim.api.nvim_set_hl(0, "SidekickDiffAdd", { bg = blend(added, base, 0.3) })
  vim.api.nvim_set_hl(0, "SidekickDiffDelete", { bg = blend(removed, base, 0.3), strikethrough = true })
  vim.api.nvim_set_hl(0, "SidekickDiffContext", { link = "CursorLine" })
end

return {
  {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    opts = {
      nes = {
        -- Suggest while typing in insert mode too. No refresh on leaving insert mode:
        -- every refresh first clears the current suggestion, so Esc would lose it.
        trigger = { events = { "TextChanged", "TextChangedI", "User SidekickNesDone" } },
        clear = { events = { "TextChangedI" }, esc = false },
      },
    },
    config = function(_, opts)
      require("sidekick").setup(opts)
      set_diff_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_diff_highlights })
    end,
  },
}
