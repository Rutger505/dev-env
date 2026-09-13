#!/bin/bash

if [[ "$SHELL" != *zsh* ]]; then
  echo "Changing default shell to zsh"
  chsh -s $(which zsh)
fi

if [ ! -f /etc/zsh/zshenv ] || ! grep -q "export ZDOTDIR=" /etc/zsh/zshenv; then
  sudo mkdir -p /etc/zsh
  echo 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee -a /etc/zsh/zshenv > /dev/null
fi
