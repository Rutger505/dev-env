#!/usr/bin/env bash

# Make sudo-rs the system-wide sudo.
#
# Arch ships sudo-rs with an -rs suffix so it can coexist with Todd Miller's
# sudo. Symlinks in /usr/local/bin shadow /usr/bin for anything using PATH,
# which covers scripts too (a shell alias would not). The setuid bit lives on
# the target, so the symlinks still escalate. sudo-rs and sudoedit-rs are
# hardlinks of one binary that branches on argv[0], hence the exact names.
#
# The real sudo stays installed as a fallback: base-devel depends on it and it
# owns /etc/sudoers.

set -euo pipefail

if ! command -v sudo-rs > /dev/null; then
  echo "sudo-rs: not installed, skipping."
  exit 0
fi

if [ -e /usr/local/bin/sudo ]; then
  echo "sudo-rs: /usr/local/bin/sudo already exists, skipping."
  exit 0
fi

# sudo-rs implements a subset of sudoers. If it cannot parse the current
# config, linking it in would leave the machine with no working sudo at all.
if ! sudo visudo-rs -c > /dev/null; then
  echo "sudo-rs: cannot parse /etc/sudoers, refusing to link. Run 'sudo visudo-rs -c' to see why."
  exit 1
fi

sudo ln -s /usr/bin/sudo-rs /usr/local/bin/sudo
sudo ln -s /usr/bin/sudoedit-rs /usr/local/bin/sudoedit
sudo ln -s /usr/bin/visudo-rs /usr/local/bin/visudo

echo "sudo-rs: linked as sudo, sudoedit and visudo in /usr/local/bin."
