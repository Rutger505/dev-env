#!/bin/bash

if [ -e /usr/local/bin/sudo ]; then
  exit 0
fi

# Linking sudo-rs while it can't parse sudoers would leave no working sudo at all
if ! sudo visudo-rs -c >/dev/null; then
  echo "sudo-rs can't parse sudoers, not linking it"
  exit 0
fi

# /usr/local/bin shadows /usr/bin, and sudo-rs picks its mode from argv[0]
sudo ln -s /usr/bin/sudo-rs /usr/local/bin/sudo
sudo ln -s /usr/bin/sudoedit-rs /usr/local/bin/sudoedit
sudo ln -s /usr/bin/visudo-rs /usr/local/bin/visudo
