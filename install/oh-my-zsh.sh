#!/bin/bash

omz="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"

clone() {
  if [ ! -d "$2" ]; then
    git clone "$1" "$2"
  fi
}

clone https://github.com/ohmyzsh/ohmyzsh.git "$omz"
clone https://github.com/zsh-users/zsh-autosuggestions.git "$omz/custom/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$omz/custom/plugins/zsh-syntax-highlighting"
