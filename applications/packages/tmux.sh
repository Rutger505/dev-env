#!/bin/bash

SCRIPT_DIRECTORY="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
PLUGINS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/plugins"
TPM_DIR="$PLUGINS_DIR/tpm"
PATCHES_DIR="$SCRIPT_DIRECTORY/../patches"

echo "Installing tmux plugins"
if [ ! -d "$TPM_DIR" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
"$TPM_DIR/bin/install_plugins" all

# Local fixes to upstream plugins, applied as commits in each plugin's own
# clone. tpm updates with a plain `git pull`, so these survive as a merge.
apply_plugin_patches() {
  local plugin_dir patch plugin

  for plugin_dir in "$PATCHES_DIR"/*/; do
    plugin="$(basename "$plugin_dir")"

    if [ ! -d "$PLUGINS_DIR/$plugin/.git" ]; then
      echo "  $plugin: not installed, skipping patches"
      continue
    fi

    for patch in "$plugin_dir"*.patch; do
      [ -f "$patch" ] || continue

      if git -C "$PLUGINS_DIR/$plugin" apply --reverse --check "$patch" 2> /dev/null; then
        echo "  $plugin: $(basename "$patch") already applied"
      elif git -C "$PLUGINS_DIR/$plugin" am --keep-cr "$patch" > /dev/null 2>&1; then
        echo "  $plugin: applied $(basename "$patch")"
      else
        git -C "$PLUGINS_DIR/$plugin" am --abort 2> /dev/null
        echo "  $plugin: FAILED to apply $(basename "$patch"), upstream likely changed"
      fi
    done
  done
}

echo "Patching tmux plugins"
apply_plugin_patches
