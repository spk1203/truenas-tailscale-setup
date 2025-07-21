# Tailscale on TrueNAS CORE Jail (Plex + TrueNAS Remote Access)

This repo provides ready-made scripts to:
- Install **Tailscale** inside a TrueNAS CORE jail.
- Enable **remote Plex and TrueNAS access** without port forwarding.
- Optionally share **LAN subnet** for Plex/TrueNAS.
- Auto-reconnect after reboots.

---

## Why This?
Setting up Tailscale on TrueNAS CORE can be painful due to FreeBSD quirks. These scripts automate:
1. Installing Tailscale.
2. Enabling IP forwarding for subnet routing.
3. Creating a startup helper for `tailscale up`.
4. Auto-advertising LAN routes (optional).

---

## Quick Install (One-Liner)
If you just want subnet routing for `your IP`:
```bash
fetch https://raw.githubusercontent.com/spk1203/truenas-tailscale-setup/main/quick_install.sh
sh quick_install.sh
