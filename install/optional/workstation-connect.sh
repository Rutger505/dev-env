#!/bin/bash
set -e

# environment.d only applies after the reboot, and workstation-connect update installs into the same CARGO_HOME later
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
config="${XDG_CONFIG_HOME:-$HOME/.config}"
repo=https://github.com/Rutger505/workstation-connect
raw=https://raw.githubusercontent.com/Rutger505/workstation-connect/main/laptop/dist

if ! rustup default >/dev/null 2>&1; then
  rustup default stable
fi
# Later updates go through workstation-connect update
if [ ! -x "$CARGO_HOME/bin/workstation-connect" ]; then
  cargo install --git "$repo" --locked workstation-connect
fi

curl -fsSL "$raw/workstation-connect.service" -o "$config/systemd/user/workstation-connect.service"
mkdir -p "$config/workstation-connect"
if [ ! -f "$config/workstation-connect/config.toml" ]; then
  curl -fsSL "$raw/config.example.toml" -o "$config/workstation-connect/config.toml"
fi
systemctl --user enable workstation-connect.service

# The KDE Connect trackpad needs a RemoteDesktop portal, which xdg-desktop-portal-hyprland lacks.
# The whitelist skips luminous' permission dialog for KDE Connect only.
mkdir -p "$config/xdg-desktop-portal" "$config/xdg-desktop-portal-luminous"
printf '[preferred]\ndefault=hyprland;gtk\norg.freedesktop.impl.portal.RemoteDesktop=luminous\n' \
  >"$config/xdg-desktop-portal/hyprland-portals.conf"
echo '{"remote": ["org.kde.kdeconnect.daemon"]}' >"$config/xdg-desktop-portal-luminous/whitelist.json"

# The portal reads the app ID from the systemd unit, so D-Bus activation must start kdeconnectd in its app unit too
services="${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services"
mkdir -p "$services"
printf '[D-BUS Service]\nName=org.kde.kdeconnect\nExec=/usr/bin/kdeconnectd\nSystemdService=app-org.kde.kdeconnect.daemon@autostart.service\n' \
  >"$services/org.kde.kdeconnect.service"

# KDE Connect over Tailscale (no shared LAN): Omarchy's ufw denies incoming by default
if command -v ufw >/dev/null; then
  sudo ufw allow in on tailscale0 to any port 1714:1764 proto tcp
  sudo ufw allow in on tailscale0 to any port 1714:1764 proto udp
fi
