#!/bin/bash

if [[ "$SHELL" != */zsh ]]; then
  chsh -s /usr/bin/zsh
fi

if ! grep -qs 'export ZDOTDIR=' /etc/zsh/zshenv; then
  sudo mkdir -p /etc/zsh
  echo 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee -a /etc/zsh/zshenv >/dev/null
fi
