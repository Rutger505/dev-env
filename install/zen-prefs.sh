#!/bin/bash

profile=$(awk -F= '/^\[Install/ { found = 1 } found && /^Default=/ { print $2; exit }' "$HOME/.zen/profiles.ini" 2>/dev/null || true)
if [ -z "$profile" ]; then
  echo "Zen has no profile yet, launch it once and rerun install.sh"
  exit 0
fi

cat >"$HOME/.zen/$profile/user.js" <<'EOF'
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);
user_pref("spellchecker.dictionary", "en-US,nl");
EOF
