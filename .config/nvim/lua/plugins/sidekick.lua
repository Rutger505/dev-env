return {
  {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    opts = {
      -- Also suggest while typing in insert mode, like VS Code, instead of only after leaving it.
      nes = {
        trigger = { events = { "ModeChanged i:n", "TextChanged", "TextChangedI", "User SidekickNesDone" } },
        clear = { events = { "TextChangedI" } },
      },
    },
  },
}
