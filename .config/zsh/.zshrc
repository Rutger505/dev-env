source $ZSH_CONFIG_DIR/tmux.zsh

###### ZSH / Oh My Zsh ######
ZSH_THEME="robbyrussell"
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="false"

zstyle ':omz:update' mode disabled

VI_MODE_SET_CURSOR=true

plugins=(
  git
  sudo
  safe-paste
  # System
  archlinux
  systemd
  # Enhancements
  zsh-autosuggestions
  zsh-syntax-highlighting
  eza
  starship
  zoxide
  vi-mode
  fzf
  copyfile
  colorize
  # Container
  docker
  kubectl
  # JavaScript / TypeScript / Node.js
  node
  npm
  fnm
  bun
  # Python
  python
  pip
  # Fun
  lol
)

source $ZSH/oh-my-zsh.sh

# After oh-my-zsh: it sets its own history options in lib/history.zsh
source $ZSH_CONFIG_DIR/history.zsh

source $ZSH_CONFIG_DIR/aliases.zsh

for file in $ZSH_CONFIG_DIR/packages/*.zsh; do
  [ -r "$file" ] && source "$file"
done
