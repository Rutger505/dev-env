#!/bin/bash
set -e

settings="${XDG_CONFIG_HOME:-$HOME/.config}/discord/settings.json"

# Discord rewrites this file all the time, so only our key gets set in place instead of stowing the whole file.
# Without it a Discord update asks for a deb or tarball and locks Discord until the package catches up.
mkdir -p "$(dirname "$settings")"
if [ ! -s "$settings" ]; then
  echo '{}' >"$settings"
fi
jq '.SKIP_HOST_UPDATE = true' "$settings" >"$settings.tmp"
mv "$settings.tmp" "$settings"
