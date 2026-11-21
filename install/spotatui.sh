#!/bin/bash
set -e

# Own fork for the playbar cover fix and the now playing panel at startup. No self-update feature, so it can't replace itself with upstream.
# environment.d only applies after the reboot
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
# env.sh points this at the ESP Xtensa clang when esp-tools are installed, which breaks the pipewire bindgen
unset LIBCLANG_PATH
if ! rustup default >/dev/null 2>&1; then
  rustup default stable
fi
if pacman -Q spotatui-bin >/dev/null 2>&1; then
  yay -Rns --noconfirm spotatui-bin
fi
cargo install --git https://github.com/Rutger505/spotatui --locked --no-default-features \
  --features telemetry,tui,streaming,discord-rpc,cover-art,scripting,mcp-server,ai-dj,audio-viz,audio-viz-cpal,mpris,local-files,subsonic,internet-radio,youtube,qobuz,soloist spotatui

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
  .behavior.playbar_cover_art_size_percent = 200 |
  .behavior.now_playing_panel_on_startup = true
' "$config"

state="${XDG_STATE_HOME:-$HOME/.local/state}/spotatui/state.yml"
mkdir -p "$(dirname "$state")"
touch "$state"
yq -i '.pane_layout = {"axis": "horizontal", "percent": 80, "first": "main", "second": "cover_art"}' "$state"
