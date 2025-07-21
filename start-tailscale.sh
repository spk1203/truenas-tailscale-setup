#!/bin/sh
# start_tailscale.sh
#
# Starts tailscaled + tailscale-route helper and shows status / next steps.

set -eu

echo "=== Starting tailscaled..."
service tailscaled start || true

echo "=== Starting tailscale-route helper (if configured)..."
service tailscale-route start || echo ">>> tailscale-route not configured (okay if Tailscale-only)."

echo
echo "=== Current Tailscale status:"
tailscale status || echo ">>> tailscale status failed (not authenticated yet?)."

echo
echo "NEXT STEPS:"
echo "1. If not authenticated yet:   tailscale up"
echo "2. If subnet mode: approve routes in Tailscale admin (Machines -> Routes)."
echo "3. Test from remote device:"
echo "   - Plex:  http://<tailscale-IP-of-plex>:32400/web"
echo "   - TrueNAS: https://<tailscale-IP-of-truenas>/"
echo