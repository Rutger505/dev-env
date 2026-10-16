#!/bin/bash
set -e

# The package ships the unit under its app id, sunshine.service is only an alias that exists once it is enabled
systemctl --user enable app-dev.lizardbyte.app.Sunshine.service

# On the tailnet itself, so Moonlight connects to the host directly instead of through the subnet router
if ! omarchy-installed-service-tailscale; then
  omarchy-install-service-tailscale
fi
# Tailscale's routing table is looked up before main, so the accepted LAN route would send the host's own
# LAN traffic through the subnet router. The host never leaves home and doesn't need it.
tailscale set --accept-routes=false
tailscale up

# Omarchy's ufw denies incoming traffic. Streaming is reachable from the home LAN and the tailnet,
# the web UI on 47990 stays local. mDNS lets Moonlight find the host on the LAN.
lan=192.168.178.0/24
sudo ufw allow from "$lan" to any port 47984,47989,48010 proto tcp comment sunshine
sudo ufw allow from "$lan" to any port 5353,47998:48000 proto udp comment sunshine
sudo ufw allow in on tailscale0 to any port 47984,47989,48010 proto tcp comment sunshine
sudo ufw allow in on tailscale0 to any port 47998:48000 proto udp comment sunshine
