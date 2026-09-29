#!/bin/bash

tpm="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/plugins/tpm"

if [ ! -d "$tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$tpm"
fi
"$tpm/bin/install_plugins"
