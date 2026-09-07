#!/usr/bin/env zsh

# Remove Omarchy preinstalled bloat we don't want on a dev machine.
# Safe to re-run: every removal is guarded by an installed/exists check.

DEV_ENV="${DEV_ENV:-$HOME/.local/share/dev-env}"
BLOAT_LIST="$DEV_ENV/applications/omarchy-bloat.lst"

# --- Packages to remove ----------------------------------------------------
# The list lives in applications/omarchy-bloat.lst, annotated with the reason
# for each package. Not kept under applications/packages/, because the
# installer loads every *.lst there and would reinstall them.
if [ -f "$BLOAT_LIST" ]; then
  # Strip comments (whole-line and trailing) and blank lines.
  REMOVE_PACKAGES=("${(@f)$(awk '{ sub(/#.*/, ""); if ($1 != "") print $1 }' "$BLOAT_LIST")}")

  # pacman -Q resolves provides, pacman -R does not: querying dotnet-runtime
  # answers dotnet-runtime-9.0, while removing it fails with "target not
  # found". So collect the real package names the query reports.
  INSTALLED_PACKAGES=()
  for pkg in "${REMOVE_PACKAGES[@]}"; do
    if resolved="$(pacman -Qq "$pkg" 2> /dev/null)"; then
      INSTALLED_PACKAGES+=("${(@f)resolved}")
    fi
  done

  if [ ${#INSTALLED_PACKAGES[@]} -gt 0 ]; then
    echo "Removing ${#INSTALLED_PACKAGES[@]} Omarchy packages: ${INSTALLED_PACKAGES[*]}"
    # -Rns also takes unneeded dependencies and config files with it.
    sudo pacman -Rns --noconfirm "${INSTALLED_PACKAGES[@]}"
  fi

  # Tell Omarchy the preinstalls are gone on purpose, so its migrations (and
  # the "Install > Preinstalls" menu entry) respect the choice. Undo with
  # omarchy-install-preinstalls.
  if [ -d "$HOME/.local/share/omarchy" ]; then
    mkdir -p "$HOME/.local/state/omarchy"
    touch "$HOME/.local/state/omarchy/preinstalls-removed"
  fi
else
  echo "Package list not found, skipping package removal: $BLOAT_LIST"
fi

# --- Desktop launchers to remove -------------------------------------------
# Removing the package is not always enough: Omarchy seeds .desktop files into
# ~/.local/share/applications, and pacman does not own those, so they survive
# a -Rns and keep showing up in the launcher pointing at a missing binary.

# Web apps Omarchy seeds as .desktop files (SUPER+SHIFT+... launchers).
REMOVE_WEBAPPS=(
  Basecamp
  ChatGPT
  Discord
  GitHub
  HEY
  WhatsApp
  X
  YouTube
  Zoom
  "Google Contacts"
  "Google Maps"
  "Google Messages"
  "Google Photos"
)

# Plain launchers (not web apps) for software this machine does not use.
REMOVE_DESKTOP_ENTRIES=(
  Alacritty   # Omarchy 3 terminal; Ghostty is the terminal here.
  foot        # Omarchy 4 terminal, same reason.
  typora      # Package already uninstalled, launcher stayed behind.
  windows-vm  # omarchy-windows-vm; no Windows VM on this machine.
)

APPS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
ICON_DIRS=(
  "${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor/256x256/apps"
  "$APPS_DIR/icons"
)

# Drop a launcher plus any icon installed alongside it. This mirrors what
# omarchy-webapp-remove does, but honours XDG_DATA_HOME instead of hardcoding
# $HOME/.local/share. Omarchy derives web-app icon names by lowercasing and
# dashing the app name, so try both that and the verbatim name.
remove_desktop_entry() {
  local name="$1" icon_dir slug
  slug="$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^[:alnum:]]\+/-/g; s/^-//; s/-$//')"

  [ -f "$APPS_DIR/$name.desktop" ] || return 0
  echo "Removing desktop entry: $name.desktop"
  rm -f "$APPS_DIR/$name.desktop"
  for icon_dir in "${ICON_DIRS[@]}"; do
    rm -f "$icon_dir/$name.png" "$icon_dir/$slug.png"
  done
}

for app in "${REMOVE_WEBAPPS[@]}" "${REMOVE_DESKTOP_ENTRIES[@]}"; do
  remove_desktop_entry "$app"
done

update-desktop-database "$APPS_DIR" &> /dev/null
