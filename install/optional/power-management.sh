#!/bin/bash

# Hibernating pushes gigabytes to the encrypted swap first, and kswapd0 can't freeze
# mid-write. The default 20s then aborts hibernation and the lid falls back to suspend.
echo 'w /sys/power/pm_freeze_timeout - - - - 60000' | sudo tee /etc/tmpfiles.d/pm-freeze-timeout.conf >/dev/null
sudo systemd-tmpfiles --create /etc/tmpfiles.d/pm-freeze-timeout.conf
