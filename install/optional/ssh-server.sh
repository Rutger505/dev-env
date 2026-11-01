#!/bin/bash
set -e

# Rewritten on every run, so keys added or removed on GitHub follow on the next install.sh.
# Written next to the target first, a failed download keeps the old keys.
keys="$HOME/.ssh/authorized_keys"
curl -fsSL https://github.com/rutger505.keys >"$keys.tmp"
chmod 600 "$keys.tmp"
mv "$keys.tmp" "$keys"

sudo tee /etc/ssh/sshd_config.d/10-dev-env.conf >/dev/null <<'EOF'
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin no
EOF

# Omarchy's ufw denies incoming traffic, so open SSH to the home LAN and the tailnet only
sudo ufw allow from 192.168.178.0/24 to any port 22 proto tcp comment ssh
sudo ufw allow in on tailscale0 to any port 22 proto tcp comment ssh

sudo systemctl enable sshd.service
sudo systemctl restart sshd.service
