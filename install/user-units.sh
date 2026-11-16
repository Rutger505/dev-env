#!/bin/bash

systemctl --user enable tmux.service dev-env-update-self.timer

# The headless agent VM has no Omarchy and no graphical session to type into
if [[ -d ~/.local/share/omarchy ]]; then
  systemctl --user enable ydotool.service
fi
