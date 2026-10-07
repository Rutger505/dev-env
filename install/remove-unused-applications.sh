#!/bin/bash

mapfile -t packages < <(awk '{ sub(/#.*/, "") } NF { print $1 }' "$(dirname "$0")/omarchy-bloat.lst")
# pacman -Q resolves provides (dotnet-runtime -> dotnet-runtime-9.0), pacman -R needs the real name
mapfile -t installed < <(pacman -Qq "${packages[@]}" 2>/dev/null)

required_by_kept_package() {
  local dependent
  for dependent in $(expac -Q '%N' "$1"); do
    [[ " ${installed[*]} " != *" $dependent "* ]] && return 0
  done
  return 1
}

# pacman aborts the whole removal if one package is still needed, and skipping one can block another
while true; do
  removable=()
  for package in "${installed[@]}"; do
    required_by_kept_package "$package" || removable+=("$package")
  done
  [ ${#removable[@]} -eq ${#installed[@]} ] && break
  installed=("${removable[@]}")
done

if [ ${#installed[@]} -gt 0 ]; then
  sudo pacman -Rns --noconfirm "${installed[@]}"
fi

# Keeps Omarchy migrations from reinstalling the removed preinstalls
mkdir -p "$HOME/.local/state/omarchy"
touch "$HOME/.local/state/omarchy/preinstalls-removed"

# pacman doesn't own the launchers Omarchy seeds, so they outlive their packages
for app in Basecamp ChatGPT Discord GitHub HEY WhatsApp X YouTube Zoom "Google Contacts" "Google Maps" \
  "Google Messages" "Google Photos" Alacritty foot typora windows-vm; do
  OMARCHY_REMOVE_NOTIFY=false omarchy-webapp-remove "$app"
done
