#!/bin/bash

# spotatui rewrites config.yml and state.yml with an atomic rename, which would replace stowed symlinks
config="${XDG_CONFIG_HOME:-$HOME/.config}/spotatui/config.yml"
mkdir -p "$(dirname "$config")"
touch "$config"
yq -i '
  .behavior.disable_auto_update = true |
  .behavior.enable_global_song_count = false |
  .behavior.pin_community_playlist = false |
  .behavior.enable_announcements = false |
  .behavior.startup_route = "stats" |
  .behavior.playbar_cover_art_size_percent = 200
' "$config"

state="${XDG_STATE_HOME:-$HOME/.local/state}/spotatui/state.yml"
mkdir -p "$(dirname "$state")"
touch "$state"
yq -i '.pane_layout = {"axis": "horizontal", "percent": 80, "first": "main", "second": "cover_art"}' "$state"
