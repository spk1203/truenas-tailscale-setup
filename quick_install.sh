#!/bin/sh
# quick_install.sh
#
# All-in-one installer for Tailscale on TrueNAS CORE jail with subnet routing.

set -eu

SUBNET="192.168.29.0/24"

echo "=== Installing Tailscale..."
pkg install -y tailscale

echo "=== Enabling services..."
sysrc tailscaled_enable=YES
sysrc gateway_enable=YES

grep -q '^net.inet.ip.forwarding=1' /etc/sysctl.conf 2>/dev/null || \
  echo 'net.inet.ip.forwarding=1' >> /etc/sysctl.conf

sysctl net.inet.ip.forwarding=1 || true

echo "=== Creating rc.d helper for subnet $SUBNET..."
cat > /usr/local/etc/rc.d/tailscale-route <<EOF
#!/bin/sh
# PROVIDE: tailscale_route
# REQUIRE: LOGIN tailscaled
# KEYWORD: shutdown

. /etc/rc.subr

name="tailscale_route"
rcvar="tailscale_route_enable"
start_cmd="tailscale_route_start"
stop_cmd=":"

tailscale_route_start()
{
    sleep 5
    /usr/local/bin/tailscale up --advertise-routes=$SUBNET --accept-dns=false
}

load_rc_config \$name
run_rc_command "\$1"
EOF

chmod +x /usr/local/etc/rc.d/tailscale-route
sysrc tailscale_route_enable=YES

service tailscaled start
service tailscale-route start

echo
echo ">>> Quick install complete!"
echo ">>> Run: tailscale up (authenticate)"
echo ">>> Approve routes in Tailscale admin console."