#!/bin/bash

# The disk passphrase after a hibernate resume already proves who's there, so the lock
# screen accepts any password for a minute after one. Only root can write the marker.
# systemd-sleep only runs hooks from /usr/lib, not /etc
sudo rm -f /etc/systemd/system-sleep/hibernate-unlock
sudo tee /usr/lib/systemd/system-sleep/hibernate-unlock >/dev/null <<'EOF'
#!/bin/bash
# suspend-then-hibernate also runs this after its plain suspend stage, which needs no passphrase
if [[ $1 == post && $SYSTEMD_SLEEP_ACTION == hibernate ]]; then
  date +%s >/run/hibernate-resumed
fi
EOF
sudo chmod +x /usr/lib/systemd/system-sleep/hibernate-unlock

sudo tee /usr/local/bin/hibernate-resumed-recently >/dev/null <<'EOF'
#!/bin/bash
[[ -f /run/hibernate-resumed ]] && (( $(date +%s) - $(</run/hibernate-resumed) < 60 ))
EOF
sudo chmod +x /usr/local/bin/hibernate-resumed-recently

# omarchy-apply-lock rewrites this file, rerun this script after it does
pam_line='auth       sufficient                  pam_exec.so quiet /usr/local/bin/hibernate-resumed-recently'
if ! rg -qF "$pam_line" /etc/pam.d/omarchy-lock-password; then
  sudo sed -i "1a $pam_line" /etc/pam.d/omarchy-lock-password
fi

systemctl --user enable hibernate-unlock.path
