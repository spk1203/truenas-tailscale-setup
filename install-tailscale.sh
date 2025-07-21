#!/bin/sh
# install_tailscale.sh
#
# Installs and enables Tailscale inside a TrueNAS CORE (FreeBSD) jail.
# Safe to re-run; idempotent where possible.

set -eu

JAIL_NAME="$(hostname -s 2>/dev/null || echo unknown-jail)"

echo "=== [$JAIL_NAME] Installing Tailscale..."
if ! pkg info -e tailscale >/dev/null 2>&1; then
  pkg install -y tailscale
else
  echo ">>> Tailscale already installed; skipping."
fi

echo "=== Enabling tailscaled service at boot..."
sysrc -f /etc/rc.conf tailscaled_enable=YES

echo "=== Enabling IP forwarding (needed for subnet routing)..."
sysrc -f /etc/rc.conf gateway_enable=YES || true

grep -q '^net.inet.ip.forwarding=1' /etc/sysctl.conf 2>/dev/null || \
  echo 'net.inet.ip.forwarding=1' >> /etc/sysctl.conf

sysctl net.inet.ip.forwarding=1 || true

echo "=== Starting tailscaled (daemon)..."
service tailscaled onestart || true

echo
echo ">>> Base install complete."
echo ">>> Next: run setup_subnet_route.sh to configure auto 'tailscale up' + routes."
echo ">>> Or manually auth now:  tailscale up"
echo