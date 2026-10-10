#!/bin/bash

# ydotool's own rule opens uinput to the input group, which would also let the user read every keyboard
sudo tee /etc/udev/rules.d/60-uinput-uaccess.rules >/dev/null <<'EOF'
KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"
EOF
