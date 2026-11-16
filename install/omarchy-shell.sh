#!/bin/bash
set -e

config="$HOME/.config/omarchy/shell.json"

updated=$(jq '
  .plugins = ((.plugins // []) | if any(.id == "rutger.emojis") then . else . + [{ id: "rutger.emojis" }] end)
  | .disabledPlugins = ((.disabledPlugins // []) | if index("omarchy.emojis") then . else . + ["omarchy.emojis"] end)
  | if [.bar.layout[][]? | .id?] | index("rutger.wsconnect") then .
    else .bar.layout.right |= ((map(.id?) | index("omarchy.bluetooth") // length) as $i | .[:$i] + [{ id: "rutger.wsconnect" }] + .[$i:])
    end
' "$config")
printf '%s\n' "$updated" >"$config"
