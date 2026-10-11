#!/bin/bash

# omarchy-settings ships a sudoers rule with a regex argument, which sudo-rs can't parse,
# so it warns about the file on every sudo call until it's gone again
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
