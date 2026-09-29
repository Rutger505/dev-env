#!/bin/bash
set -euo pipefail

cd "$(dirname "$(realpath "$0")")/install"

optional_file="${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/optional-packages.conf"

add_chaotic_aur() {
  if grep -q '^\[chaotic-aur\]' /etc/pacman.conf; then
    return
  fi
  sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key 3056513887B78AEB
  sudo pacman -U --needed --noconfirm \
    https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst \
    https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst
  printf '[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n' | sudo tee -a /etc/pacman.conf >/dev/null
  sudo pacman -Sy
}

select_optional_groups() {
  local groups current preselect="" i=0 selected
  groups=$(for file in optional/*; do basename "${file%.*}"; done | sort -u)
  current=$(cat "$optional_file" 2>/dev/null || true)

  while read -r group; do
    i=$((i + 1))
    if grep -qxF "$group" <<<"$current"; then
      preselect+="pos($i)+toggle+"
    fi
  done <<<"$groups"

  # fzf returns the item under the cursor when nothing is marked, so an empty selection needs become(true)
  selected=$(fzf --multi --prompt="Optional packages: " \
    --header="SPACE to toggle, ENTER to confirm" \
    --bind "load:${preselect}first" \
    --bind "j:down,k:up,ctrl-a:select-all,ctrl-d:deselect-all,space:toggle" \
    --bind 'enter:transform:[ "$FZF_SELECT_COUNT" -eq 0 ] && echo "become(true)" || echo accept' \
    --preview 'head -n 50 optional/{}.*' \
    <<<"$groups")

  mkdir -p "$(dirname "$optional_file")"
  echo "$selected" >"$optional_file"
}

link_configs() {
  # Missing directories get folded into a symlink to the repo, and apps write keys, credentials and unit links into these
  mkdir -p -m 700 "$HOME/.ssh" "$HOME/.claude" "$HOME/.local/bin" "$HOME/.config/systemd/user"

  # Omarchy ships its own hypr, git, tmux and starship configs: adopt them to get past the conflicts, then restore ours.
  # Only on a clean tree, the restore would discard local changes.
  if git -C .. diff --quiet HEAD; then
    ../scripts/dev-env-stow --adopt
    git -C .. checkout -- .
  else
    ../scripts/dev-env-stow
  fi
}

add_chaotic_aur
sudo pacman -S --needed --noconfirm yay fzf stow
link_configs
select_optional_groups

lists=(packages.lst)
scripts=(*.sh)
while read -r group; do
  if [ -f "optional/$group.lst" ]; then lists+=("optional/$group.lst"); fi
  if [ -f "optional/$group.sh" ]; then scripts+=("optional/$group.sh"); fi
done <"$optional_file"

mapfile -t packages < <(grep -h . "${lists[@]}")
yay -S --needed "${packages[@]}"

for script in "${scripts[@]}"; do
  echo "Running $script"
  "./$script"
done

echo "Done. Reboot to switch to zsh, pick up the new groups and environment, and start tmux and the auto-updater."
