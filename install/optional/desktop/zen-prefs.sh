#!/bin/bash
set -e

zen_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zen"
# Zen keeps using the pre-XDG location on machines that already have it
if [ -d "$HOME/.zen" ]; then
  zen_dir="$HOME/.zen"
fi

# A headless start creates the profile, so the prefs apply from the very first real launch
if [ ! -f "$zen_dir/profiles.ini" ]; then
  zen-browser --headless --screenshot /dev/null about:blank >/dev/null 2>&1
fi

profile=$(awk -F= '/^\[Install/ { found = 1 } found && /^Default=/ { print $2; exit }' "$zen_dir/profiles.ini")

cat >"$zen_dir/$profile/user.js" <<'EOF'
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);
user_pref("spellchecker.dictionary", "en-US,nl");
EOF
