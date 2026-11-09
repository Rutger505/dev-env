#!/bin/bash

# spotatui rewrites config.yml with an atomic rename, which would replace a stowed symlink
config="${XDG_CONFIG_HOME:-$HOME/.config}/spotatui/config.yml"
mkdir -p "$(dirname "$config")"
touch "$config"
yq -i '
  .behavior.disable_auto_update = true |
  .behavior.enable_global_song_count = false |
  .behavior.pin_community_playlist = false |
  .behavior.enable_announcements = false
' "$config"
