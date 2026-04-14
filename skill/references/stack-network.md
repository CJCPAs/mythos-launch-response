# Network Equipment Hardening Reference

## Emergency Checks

1. **Default credentials changed?** — Check against common defaults:
   - Netgear: admin/password
   - TP-Link: admin/admin
   - Ubiquiti: ubnt/ubnt
   - Cisco: cisco/cisco
   - pfSense: admin/pfsense
2. **Firmware current?** — Check manufacturer's support site
3. **Remote management from WAN disabled?**
4. **UPnP disabled?**

## Hardening Actions

1. Change admin password on ALL network equipment (strong, unique, in password manager)
2. Update firmware to latest
3. Disable UPnP
4. Disable remote management from WAN
5. Disable WPS on Wi-Fi
6. Set WPA3 or WPA2-AES (never WPA, WEP, or TKIP)
7. Create separate VLANs: Business, Guest, IoT, Sensitive, Management
8. Set DNS to filtered provider (Cloudflare 1.1.1.3, Quad9 9.9.9.9)
9. Enable syslog and review monthly
10. Disable unused switch ports
11. Replace any end-of-life equipment

## VLAN Layout Example

```
VLAN 10 - Management: Router/switch admin (IT only)
VLAN 20 - Business: Employee workstations
VLAN 30 - Sensitive: Accounting, client data servers
VLAN 40 - IoT: Printers, cameras, smart devices
VLAN 50 - Guest: Guest Wi-Fi (internet only)
```

## Mythos Context
Cisco and Palo Alto are Glasswing partners — enterprise gear gets Mythos-informed patches. Consumer gear (Netgear, TP-Link, Linksys) does NOT. Consider upgrading to Ubiquiti, pfSense, or Cisco small business for active security updates.
