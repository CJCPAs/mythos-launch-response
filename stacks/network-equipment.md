# Network Equipment Security Hardening Guide

**For organizations managing routers, firewalls, switches, and access points in the post-Mythos era.**

Network equipment is the forgotten attack surface. It runs 24/7, rarely gets updated, often has default passwords, and sits between your business and the internet. Cisco and Palo Alto Networks are Glasswing founding partners — they're scanning their code. But the router in your office closet with the 4-year-old firmware and admin/admin credentials is on you.

---

## 1. The Emergency Audit (Do Right Now)

### Check for Default Credentials

These are the most commonly unchanged defaults. If ANY of these work on your equipment, change them immediately:

| Vendor | Default Username | Default Password | Default Admin URL |
|--------|-----------------|-----------------|-------------------|
| Netgear | admin | password | 192.168.1.1 or routerlogin.net |
| Linksys | admin | admin | 192.168.1.1 |
| TP-Link | admin | admin | 192.168.0.1 or tplinkwifi.net |
| Ubiquiti | ubnt | ubnt | 192.168.1.20 |
| Cisco (small business) | cisco | cisco | 192.168.1.1 |
| Meraki | (cloud managed) | — | dashboard.meraki.com |
| SonicWall | admin | password | 192.168.168.168 |
| Fortinet | admin | (blank) | 192.168.1.99 |
| pfSense | admin | pfsense | 192.168.1.1 |
| ISP-provided router | (varies) | (often on a sticker on the device) | (varies) |

- [ ] **Change the admin password** on every piece of network equipment to a strong unique password stored in your password manager
- [ ] **Change the Wi-Fi password** if it's a default or has been shared widely
- [ ] **Change SNMP community strings** if SNMP is enabled (default "public" and "private" are the first thing attackers try)

### Check Firmware Version

- [ ] **Log into every router, firewall, switch, and access point**
- [ ] **Check the current firmware version** against the vendor's website
- [ ] **Update firmware** if not current
- [ ] If the device is **end-of-life** (no more firmware updates from vendor) — plan replacement

```bash
# For Ubiquiti via SSH
ssh admin@192.168.1.20
info
# Compare version against https://ui.com/download

# For most routers: log into web admin → System / Administration → Firmware
```

---

## 2. Router and Firewall Configuration

### Firewall Rules

- [ ] **Default inbound policy: DENY ALL** — only allow specific traffic you need
- [ ] **Review every port forwarding rule** — for each one, ask:
  - Is this still needed?
  - Can the service be accessed through VPN instead?
  - Is the destination device patched and monitored?
- [ ] **No port forwarding to RDP (3389)** — use VPN instead (see [vpn-remote-access.md](vpn-remote-access.md))
- [ ] **No port forwarding to database ports** (3306, 5432, 6379, 27017, 1433)
- [ ] **No port forwarding to SMB (445)** — ever
- [ ] **UPnP disabled** — UPnP lets any device on your network open ports automatically. Malware uses this.

### WAN-Side Security

- [ ] **Remote management disabled from WAN** — admin interface should only be accessible from inside the network
  - If you MUST manage remotely, use VPN + management VLAN
- [ ] **ICMP (ping) disabled from WAN** (reduces reconnaissance)
- [ ] **DNS rebinding protection enabled** (if available)
- [ ] **SPI (Stateful Packet Inspection) firewall enabled**

---

## 3. Wi-Fi Security

### Encryption

- [ ] **WPA3 enabled** (if all devices support it)
- [ ] **Or WPA2-AES at minimum** — never WPA, never WEP, never TKIP
  ```
  WPA3 > WPA2-AES >>> WPA2-TKIP >>> WPA > WEP (completely broken)
  ```
- [ ] **Wi-Fi password is strong** (16+ characters, not the company name or address)
- [ ] **SSID is not your company name** (reduces targeting — "Netgear-5G" is better than "SmithCPA-Office")

### Network Separation

This is one of the most impactful things you can do:

- [ ] **Guest Wi-Fi on a separate VLAN/subnet** — guests cannot reach business systems
- [ ] **IoT devices on a separate VLAN** — security cameras, printers, smart TVs, thermostats
- [ ] **Business devices on their own network** — computers, phones used for work
- [ ] **Sensitive systems on a restricted VLAN** — accounting, payroll, client data servers

```
Example VLAN layout for a small office:

VLAN 10 - Management (192.168.10.0/24)
  Router admin, switch admin, AP admin
  Access: IT team only

VLAN 20 - Business (192.168.20.0/24)
  Employee workstations, business phones
  Access: Internet + internal servers

VLAN 30 - Sensitive (192.168.30.0/24)
  Accounting server, file server with client data
  Access: Only from VLAN 20, no direct internet

VLAN 40 - IoT (192.168.40.0/24)
  Printers, cameras, smart devices
  Access: Limited internet, no access to other VLANs

VLAN 50 - Guest (192.168.50.0/24)
  Guest Wi-Fi, visitor devices
  Access: Internet only, nothing internal
```

Most business routers (Ubiquiti, pfSense, Meraki, Fortinet) support VLANs. Even consumer routers support guest networks — use them.

### Wireless Audit

- [ ] **Check for rogue access points** — unauthorized Wi-Fi devices plugged into your network
- [ ] **Disable WPS** (Wi-Fi Protected Setup) — has known vulnerabilities, allows PIN brute force
- [ ] **Disable Wi-Fi if not needed** on wired-only servers or network equipment
- [ ] **Check connected devices list** on your router — recognize every device? If not, investigate.

---

## 4. Switch Security (If You Have Managed Switches)

- [ ] **Change default admin credentials** on all switches
- [ ] **Firmware updated to latest**
- [ ] **Unused ports disabled** — a port that nothing's plugged into should be administratively shut down
- [ ] **DHCP snooping enabled** (prevents rogue DHCP servers)
- [ ] **Port security enabled** (limits MAC addresses per port — prevents network device impersonation)
- [ ] **Spanning tree protection enabled** (prevents network topology attacks)
- [ ] **Management VLAN separated** from user traffic

For unmanaged switches: they're just dumb pipe. Ensure they're physically secured (locked closet) and replace with managed switches when budget allows.

---

## 5. DNS Security

Your router is likely your DNS server for the office.

- [ ] **Use a DNS provider with malware filtering:**
  | Provider | IP | What It Blocks |
  |----------|-----|---------------|
  | Cloudflare for Families | 1.1.1.3 | Malware |
  | Cloudflare for Families | 1.1.1.2 | Malware + adult content |
  | Quad9 | 9.9.9.9 | Malware |
  | OpenDNS | 208.67.222.222 | Configurable |

- [ ] Configure these as the DNS servers in your router's DHCP settings (so all devices on the network automatically use them)
- [ ] **DNSSEC validation enabled** (if your router supports it)
- [ ] **DNS-over-HTTPS (DoH) or DNS-over-TLS (DoT)** enabled if supported

---

## 6. Logging and Monitoring

Most network equipment can log — but most SMBs don't look at the logs.

- [ ] **Syslog enabled** and sending to a central log server (or at minimum, storing locally with enough retention)
- [ ] **Log all denied firewall connections** (shows what's hitting your perimeter)
- [ ] **Log all admin access** (who logged into the router and when)
- [ ] **Review logs monthly** for:
  - Denied connections from internal devices to unusual destinations (malware calling home)
  - Admin logins from unexpected times or IPs
  - Port scan patterns from external IPs
  - DHCP requests from unknown MAC addresses

### Free Monitoring Options

| Tool | What It Does |
|------|-------------|
| **Uptime Kuma** | Free, self-hosted uptime monitoring for your services |
| **Grafana + SNMP** | Network traffic visualization |
| **ntopng** | Network traffic analysis |
| **Router's built-in logging** | Better than nothing — enable it and check it |

---

## 7. Physical Security

Network equipment is often in unlocked closets, under desks, or in public areas.

- [ ] **Router/firewall in a locked closet or cabinet**
- [ ] **Console/serial ports not physically accessible** to visitors
- [ ] **No unauthorized devices plugged into network ports** in public areas (conference rooms, lobbies)
- [ ] **Ethernet ports in public areas disabled** or on a guest VLAN
- [ ] **Label all cables and ports** — know what's plugged into what

---

## 8. ISP-Provided Equipment

Many SMBs use the router their ISP provided. These are often poorly configured and rarely updated.

**Options:**
1. **Replace it** with your own router (pfSense, Ubiquiti, Fortinet) and put the ISP device in bridge mode
2. **Harden it** — change passwords, update firmware, disable remote management, disable WPS, configure as above
3. **Put your own firewall behind it** — ISP device handles the WAN connection, your firewall handles security

Option 1 is best. Option 3 is easiest. Option 2 is the minimum.

- [ ] **ISP remote management disabled** (ISPs often leave remote access enabled for support — this is a backdoor)
- [ ] **ISP device firmware updated** (call your ISP and ask for the latest firmware)
- [ ] **Default ISP admin password changed**

---

## 9. End-of-Life Equipment

Network equipment that no longer receives firmware updates is a ticking time bomb.

- [ ] **Inventory all network equipment** with model and firmware version
- [ ] **Check each device against vendor's end-of-life list**
- [ ] **Replace any EOL equipment** — no firmware updates means no patches for Mythos-discovered vulnerabilities
- [ ] **Budget for replacement** if not immediate — network equipment typically lasts 5-7 years before EOL

Cisco and Palo Alto are Glasswing partners. If they find vulnerabilities in their own equipment, patches will ship for supported hardware. EOL hardware gets nothing.

---

## 10. Mythos-Specific Concerns

Cisco and Palo Alto Networks are Glasswing founding partners. Broadcom (which owns VMware and Symantec) is also a partner. This means:

- Enterprise firewall and network equipment firmware will be scanned by Mythos
- Patches for Cisco IOS, Palo Alto PAN-OS, and Fortinet FortiOS may arrive faster than usual through July 2026
- Consumer/small business network equipment (Netgear, TP-Link, Linksys) is **NOT** covered by Glasswing

**If you run consumer-grade network equipment:**
- You will NOT get Mythos-informed patches
- Consider upgrading to Ubiquiti, pfSense, or a Cisco small business device that receives active security updates
- At minimum, keep firmware current and default credentials changed

---

## Quick Wins (Do Today)

1. Log into your router — is the admin password still the default? Change it NOW.
2. Check firmware version against vendor's website — update if behind
3. Disable UPnP
4. Disable remote management from WAN
5. Set up a guest Wi-Fi network separated from your business network
