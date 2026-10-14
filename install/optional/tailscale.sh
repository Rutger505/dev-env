#!/bin/bash
set -e

if ! omarchy-installed-service-tailscale; then
  omarchy-install-service-tailscale
fi

# Split DNS resolves homelab.rutgerpronk.com through AdGuard Home, the LAN route reaches it away from home
tailscale set --accept-dns --accept-routes
