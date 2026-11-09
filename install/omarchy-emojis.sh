#!/bin/bash
set -e

config="$HOME/.config/omarchy/shell.json"

updated=$(jq '
  .plugins = ((.plugins // []) | if any(.id == "rutger.emojis") then . else . + [{ id: "rutger.emojis" }] end)
  | .disabledPlugins = ((.disabledPlugins // []) | if index("omarchy.emojis") then . else . + ["omarchy.emojis"] end)
' "$config")
printf '%s\n' "$updated" >"$config"
