#!/bin/bash

sudo tee /etc/systemd/system/kanata.service >/dev/null <<EOF
[Unit]
Description=Kanata
Requires=local-fs.target
After=local-fs.target

[Service]
ExecStart=/usr/bin/kanata -c /etc/kanata/kanata.conf
Restart=on-failure
RestartSec=5

[Install]
WantedBy=sysinit.target
EOF

sudo mkdir -p /etc/kanata
sudo tee /etc/kanata/kanata.conf >/dev/null <<EOF
(defcfg
  ;; the default, set explicitly to silence a startup warning
  process-unmapped-keys no
  ;; gpu-screen-recorder ignores kanata's virtual keyboard when it also carries mouse events
  linux-device-detect-mode keyboard-only
  linux-dev-names-exclude ("gsr-ui virtual keyboard")
)

(defsrc)
(deflayermap (base-layer)
  caps esc)
EOF

sudo mkdir -p /etc/systemd/system-sleep
sudo tee /etc/systemd/system-sleep/kanata >/dev/null <<'EOF'
#!/bin/bash
# kanata's grab surviving suspend leaves the keyboard dead for seconds after resume,
# kanata-unlock.service starts it again once the lockscreen is unlocked
if [[ $1 == pre ]]; then
  systemctl stop kanata.service
fi
EOF
sudo chmod +x /etc/systemd/system-sleep/kanata

# Omarchy's lockscreen has no unlock hook, the journal line is the only signal
sudo tee /etc/systemd/system/kanata-unlock.service >/dev/null <<'EOF'
[Unit]
Description=Start Kanata after unlocking the lockscreen

[Service]
ExecStart=/bin/bash -c 'journalctl -f -n0 -o cat SYSLOG_IDENTIFIER=omarchy-shell --grep "omarchy lock .* unlocked" | while read -r _; do systemctl start kanata.service; done'
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now kanata.service kanata-unlock.service
