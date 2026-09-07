#!/bin/bash

if grep -q '^\[chaotic-aur\]' /etc/pacman.conf; then
  echo Chaotic aur already installed :\)
  exit 0
fi


if ! sudo pacman-key --list-keys | grep -q 3056513887B78AEB; then
    echo "Initializing pacman keyring..."
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
fi

sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB

sudo pacman -U --needed 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U --needed 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# Only add chaotic-aur entry if it doesn't exist yet
if ! grep -q '^\[chaotic-aur\]' /etc/pacman.conf; then
	echo "Adding chaotic aur to pacman.conf"
	sudo tee -a /etc/pacman.conf > /dev/null <<EOF
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
else
	echo "chaotic-aur entry already exists in pacman.conf, skipping."
fi

# The new repo has no database on disk yet, so fetch it once here. This is the
# only place install.sh refreshes databases besides bootstrapping yay.
sudo pacman -Sy



