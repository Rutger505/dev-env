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

sudo systemctl daemon-reload
sudo systemctl enable --now kanata.service
