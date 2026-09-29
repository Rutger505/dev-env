source $ZDOTDIR/tmux.zsh

ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode disabled
VI_MODE_SET_CURSOR=true

plugins=(
  git
  sudo
  safe-paste
  archlinux
  systemd
  zsh-autosuggestions
  zsh-syntax-highlighting
  eza
  starship
  zoxide
  vi-mode
  fzf
  copyfile
  colorize
  docker
  kubectl
  node
  npm
  fnm
  bun
  python
  pip
  lol
)

source $ZSH/oh-my-zsh.sh

# oh-my-zsh sets its own history options, so ours have to come after it
source $ZDOTDIR/history.zsh
source $ZDOTDIR/aliases.zsh

for file in $ZDOTDIR/packages/*.zsh; do
  source "$file"
done
