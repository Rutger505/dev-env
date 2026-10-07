#!/bin/bash

# Left behind by Omarchy's LazyVim config next to our stowed specs. lazy.nvim merges it after
# plugins/snacks.lua, so it would turn snacks scroll back off.
rm -f "$HOME/.config/nvim/lua/plugins/snacks-animated-scrolling-off.lua"
