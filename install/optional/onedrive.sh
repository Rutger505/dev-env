#!/bin/bash

mkdir -p "$HOME/School"

if [ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/onedrive/refresh_token" ]; then
  onedrive
fi

echo "Check the plan with 'onedrive --sync --dry-run --verbose', then run 'systemctl --user enable --now onedrive'"
