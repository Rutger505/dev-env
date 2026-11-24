#!/bin/bash

# Hibernating pushes gigabytes to the encrypted swap first, and kswapd0 can't freeze
# mid-write. The default 20s then aborts hibernation and the lid falls back to suspend.
echo 'w /sys/power/pm_freeze_timeout - - - - 60000' | sudo tee /etc/tmpfiles.d/pm-freeze-timeout.conf >/dev/null
sudo systemd-tmpfiles --create /etc/tmpfiles.d/pm-freeze-timeout.conf

sudo install -Dm755 /dev/stdin /usr/lib/systemd/system-sleep/btusb-workaround <<'EOF'
#!/bin/sh
  # MT7921 Bluetooth needs ~2.5 s to set up its controller after an S3 resume, and
  # removing btusb mid-setup hangs. suspend-then-hibernate starts hibernating 2 s
  # after the suspend phase resumes, so wait for hci0 before unloading.
case "$1" in
  pre)
    if [ -d /sys/module/btusb ]; then
      for _ in 1 2 3 4 5; do
        [ -e /sys/class/bluetooth/hci0 ] && break
        sleep 1
      done
      modprobe -r btusb
    fi
    ;;
  post)
    modprobe btusb
    ;;
esac
EOF
