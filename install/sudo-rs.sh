#!/bin/bash

# omarchy-settings ships a sudoers rule with a regex argument, which sudo-rs can't parse,
# so it warns about the file on every sudo call until it's gone again
sudo mkdir -p /etc/pacman.d/hooks
sudo tee /etc/pacman.d/hooks/remove-omarchy-tzupdate.hook >/dev/null <<'EOF'
[Trigger]
Type = Path
Operation = Install
Operation = Upgrade
Target = etc/sudoers.d/omarchy-tzupdate

[Action]
Description = Removing omarchy-tzupdate, which sudo-rs can't parse...
When = PostTransaction
Exec = /usr/bin/rm -f /etc/sudoers.d/omarchy-tzupdate
EOF

sudo rm -f /etc/sudoers.d/omarchy-tzupdate

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
