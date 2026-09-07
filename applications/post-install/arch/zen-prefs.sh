#!/usr/bin/env bash

# Apply Zen browser about:config preferences via user.js.
#
# Zen (like Firefox) stores its profile at ~/.zen/<random>.<name>/, where the
# leading 8-char salt is generated at first launch and differs per machine.
# We therefore resolve the active profile path from profiles.ini (falling back
# to globbing) and write our prefs into that profile's user.js.

set -euo pipefail

ZEN_DIR="$HOME/.zen"

if [ ! -d "$ZEN_DIR" ]; then
  echo "zen-prefs: ~/.zen not found — launch Zen once first. Skipping."
  exit 0
fi

# The pref(s) we manage. Add more lines here as needed.
read -r -d '' MANAGED_PREFS <<'PREFS' || true
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", false);
user_pref("spellchecker.dictionary", "en-US,nl-NL");
PREFS

resolve_profile() {
  local ini="$ZEN_DIR/profiles.ini"

  # Prefer the [Install*] Default= entry (the profile Zen actually launches).
  if [ -f "$ini" ]; then
    local rel
    rel=$(awk -F= '/^\[Install/{ins=1} ins && /^Default=/{print $2; exit}' "$ini")
    if [ -n "${rel:-}" ] && [ -d "$ZEN_DIR/$rel" ]; then
      echo "$ZEN_DIR/$rel"
      return 0
    fi

    # Otherwise take the first [ProfileN] with Default=1, then the first profile.
    rel=$(awk -F= '
      /^\[Profile/{p=1; path=""; def=0}
      p && /^Path=/{path=$2}
      p && /^Default=1/{def=1}
      p && path!="" && def==1{print path; exit}
    ' "$ini")
    if [ -n "${rel:-}" ] && [ -d "$ZEN_DIR/$rel" ]; then
      echo "$ZEN_DIR/$rel"
      return 0
    fi

    rel=$(awk -F= '/^\[Profile/{p=1} p && /^Path=/{print $2; exit}' "$ini")
    if [ -n "${rel:-}" ] && [ -d "$ZEN_DIR/$rel" ]; then
      echo "$ZEN_DIR/$rel"
      return 0
    fi
  fi

  # Last resort: glob for a *.Default profile folder.
  local match
  match=$(find "$ZEN_DIR" -maxdepth 1 -type d -iname '*.Default*' 2>/dev/null | head -1)
  if [ -n "${match:-}" ]; then
    echo "$match"
    return 0
  fi

  return 1
}

PROFILE_DIR=$(resolve_profile) || {
  echo "zen-prefs: could not resolve a Zen profile from $ZEN_DIR — skipping."
  exit 0
}

USER_JS="$PROFILE_DIR/user.js"
touch "$USER_JS"

# Idempotently ensure each managed pref line is present (replace existing key).
while IFS= read -r line; do
  [ -z "$line" ] && continue
  key=$(printf '%s' "$line" | sed -n 's/^user_pref("\([^"]*\)".*/\1/p')
  if [ -n "$key" ] && grep -q "\"$key\"" "$USER_JS"; then
    # Replace the existing line for this key.
    tmp=$(mktemp)
    grep -v "\"$key\"" "$USER_JS" >"$tmp" || true
    printf '%s\n' "$line" >>"$tmp"
    mv "$tmp" "$USER_JS"
  else
    printf '%s\n' "$line" >>"$USER_JS"
  fi
done <<<"$MANAGED_PREFS"

echo "zen-prefs: applied prefs to $USER_JS"
