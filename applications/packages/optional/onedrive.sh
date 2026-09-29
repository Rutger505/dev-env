#!/bin/bash

# Authenticates the abraunegg OneDrive client. The config and sync_list are
# stowed from .config/onedrive, syncing the remote School folder into ~/School.

set -euo pipefail

if ! command -v onedrive &> /dev/null; then
  echo "OneDrive client is not installed, skipping configuration"
  exit 0
fi

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/onedrive"

mkdir -p "$HOME/School"

# Authenticate if no refresh token is present yet.
# The client prints a URL, you log in and paste the redirected URL back.
if [[ -f "$CONFIG_DIR/refresh_token" ]]; then
  echo "OneDrive is already authenticated"
else
  echo ""
  echo "Authenticating with OneDrive."
  echo "Open the printed URL, sign in, and paste the resulting URL back here."
  echo ""
  onedrive
fi

echo ""
echo "Current OneDrive configuration:"
onedrive --display-config

echo ""
echo "Review the plan with a dry run before enabling the service:"
echo "  onedrive --sync --dry-run --verbose"
echo "Then enable continuous syncing with:"
echo "  systemctl --user enable --now onedrive"
