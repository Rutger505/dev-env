#!/bin/bash

# Configures the abraunegg OneDrive client to sync a single remote folder into
# a local directory of choice (default: ~/School), instead of creating a
# ~/OneDrive folder in the home directory.

set -euo pipefail

if ! command -v onedrive &> /dev/null; then
  echo "OneDrive client is not installed, skipping configuration"
  exit 0
fi

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/onedrive"
CONFIG_FILE="$CONFIG_DIR/config"
SYNC_LIST_FILE="$CONFIG_DIR/sync_list"

ONEDRIVE_SYNC_DIR="${ONEDRIVE_SYNC_DIR:-$HOME/School}"
ONEDRIVE_REMOTE_DIR="${ONEDRIVE_REMOTE_DIR:-School}"

mkdir -p "$CONFIG_DIR"
mkdir -p "$ONEDRIVE_SYNC_DIR"

if [[ -f "$CONFIG_FILE" ]]; then
  echo "OneDrive config already exists at $CONFIG_FILE, leaving it untouched"
else
  echo "Writing OneDrive config to $CONFIG_FILE"
  cat > "$CONFIG_FILE" <<EOF
# Local directory that mirrors the remote folder selected in sync_list
sync_dir = "$ONEDRIVE_SYNC_DIR"

# Skip editor/office temporary files
skip_file = "~*|.~*|*.tmp|*.swp|*.partial"

# Check for remote changes every 5 minutes while in monitor mode
monitor_interval = "300"
EOF
fi

if [[ -f "$SYNC_LIST_FILE" ]]; then
  echo "OneDrive sync_list already exists at $SYNC_LIST_FILE, leaving it untouched"
else
  echo "Writing OneDrive sync_list to $SYNC_LIST_FILE"
  cat > "$SYNC_LIST_FILE" <<EOF
# Only sync this remote OneDrive folder
$ONEDRIVE_REMOTE_DIR/*
EOF
fi

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
