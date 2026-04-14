# VPN and Remote Access Security Hardening Guide

**For organizations with remote employees in the post-Mythos era.**

Exposed Remote Desktop Protocol (RDP) is the single most exploited attack vector for ransomware. AI-assisted attackers will automate credential stuffing and exploit discovery against remote access services at unprecedented scale. If your remote access isn't locked down, this is your highest priority.

---

## 1. The Rules

### Rule #1: Never Expose RDP Directly to the Internet

This is non-negotiable. RDP on port 3389 exposed to the internet is an invitation to get ransomware'd.

```bash
# Check if RDP is internet-facing (run from outside your network)
nmap -p 3389 your-public-ip

# If this shows "open" — you have an emergency to fix right now
```

If you need remote desktop access, it MUST go through a VPN or zero-trust solution first.

### Rule #2: Never Expose SSH Directly to the Internet Without Key Auth

```bash
# Check if SSH is internet-facing
nmap -p 22 your-public-ip

# If open, verify password auth is disabled
grep "PasswordAuthentication" /etc/ssh/sshd_config
# Must show: PasswordAuthentication no
```

### Rule #3: No Split Tunneling for Sensitive Work

When connected to the VPN, ALL traffic should go through the VPN — not just traffic to office resources. Split tunneling lets an attacker on the employee's local network intercept non-VPN traffic.

---

## 2. VPN Solutions for SMBs

### Option A: WireGuard (Recommended for Technical Teams)

Fast, modern, audited, minimal attack surface.

```bash
# Server setup (Ubuntu)
sudo apt install wireguard

# Generate server keys
wg genkey | tee server_private.key | wg pubkey > server_public.key

# /etc/wireguard/wg0.conf
[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = <server_private_key>

# Enable IP forwarding
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# For each client:
[Peer]
PublicKey = <client_public_key>
AllowedIPs = 10.0.0.2/32
```

```bash
# Client config
[Interface]
Address = 10.0.0.2/32
PrivateKey = <client_private_key>
DNS = 1.1.1.3  # Cloudflare malware-blocking DNS

[Peer]
PublicKey = <server_public_key>
Endpoint = your-server-ip:51820
AllowedIPs = 0.0.0.0/0  # Route ALL traffic through VPN (no split tunnel)
PersistentKeepalive = 25
```

- [ ] WireGuard port (51820) is the ONLY port exposed on the VPN server
- [ ] Each employee has their own key pair (no shared keys)
- [ ] Keys are revoked immediately when an employee leaves
- [ ] DNS goes through the VPN (prevents DNS leaks)

### Option B: Tailscale (Recommended for Non-Technical Teams)

Zero-config WireGuard mesh. Easiest to deploy and manage.

- [ ] Tailscale installed on all employee devices and office servers
- [ ] SSO/identity provider connected (Google Workspace, Microsoft, Okta)
- [ ] MFA enforced through your identity provider
- [ ] ACLs configured — not everyone needs access to everything
  ```json
  // tailscale ACL policy
  {
    "acls": [
      // All employees can reach the file server
      {"action": "accept", "src": ["group:employees"], "dst": ["fileserver:*"]},
      // Only IT can reach servers via SSH
      {"action": "accept", "src": ["group:it"], "dst": ["servers:22"]},
      // Only finance can reach accounting systems
      {"action": "accept", "src": ["group:finance"], "dst": ["accounting:443"]}
    ]
  }
  ```
- [ ] Exit nodes configured for full-tunnel when needed
- [ ] Device approval enabled (new devices require admin approval)
- [ ] Key expiry set (forces re-authentication periodically)

### Option C: OpenVPN (If You Already Have It)

Older but functional. If you're already running OpenVPN:

- [ ] **TLS 1.2+ enforced** (no older versions)
- [ ] **Strong cipher suite** (AES-256-GCM recommended)
- [ ] **Certificate-based authentication** (not just username/password)
- [ ] **Certificate revocation list (CRL) maintained** — revoke certs for departed employees
- [ ] **tls-auth or tls-crypt enabled** (adds HMAC to prevent DoS and fingerprinting)
- [ ] **Compression disabled** (VORACLE attack vector)
  ```
  # In server.conf:
  compress stub
  push "compress stub"
  ```
- [ ] **Each user has their own certificate** (no shared certs)
- [ ] **Server certificate renewed before expiry**

### What NOT to Use

| Technology | Why Not |
|-----------|---------|
| **PPTP** | Broken encryption. Crackable in hours. Never use. |
| **L2TP/IPSec with pre-shared key** | Weak if PSK is reused or guessable. Certificate-based IPSec is acceptable. |
| **Free VPN services** | They see all your traffic. You are the product. |
| **TeamViewer / AnyDesk as VPN replacement** | Not designed as security boundaries. Fine for support sessions, not as persistent remote access. |
| **Exposed RDP with "strong passwords"** | Passwords alone are not enough. Credential stuffing and brute force are automated. |

---

## 3. Zero Trust Network Access (ZTNA)

For organizations ready to move beyond traditional VPN:

| Solution | Cost | Notes |
|----------|------|-------|
| **Cloudflare Access** | Free (up to 50 users) | Application-level access, identity-aware, no network-level VPN needed |
| **Tailscale** | Free (up to 3 users), $6/user/mo | WireGuard mesh with identity and ACLs |
| **Twingate** | Free (up to 5 users), $5/user/mo | Application-level ZTNA |
| **Zscaler Private Access** | Enterprise pricing | Full ZTNA for larger orgs |

Zero Trust approach:
- No implicit trust from being "on the network"
- Every access request is verified against identity, device health, and context
- Applications are accessed individually, not entire network segments
- Works for remote AND in-office employees

---

## 4. Remote Desktop (When You Need It)

If employees must use Remote Desktop:

### Behind VPN (Minimum)

```
Employee laptop → VPN tunnel → Office network → RDP to workstation
                  (encrypted)    (firewall)      (internal only)
```

- [ ] RDP port 3389 is NOT exposed to the internet (verify with external nmap scan)
- [ ] RDP only accessible through VPN
- [ ] Network Level Authentication (NLA) enabled on all target machines
  ```powershell
  # Check NLA status
  Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name UserAuthentication
  # Must return 1
  ```
- [ ] RDP session timeout configured (don't leave sessions open indefinitely)
- [ ] Account lockout policy enabled (lock after 5 failed attempts)

### Better: RDP Gateway

- [ ] Remote Desktop Gateway deployed — authenticates before connecting
- [ ] Gateway requires MFA
- [ ] Gateway logs all connections for audit

### Best: Cloud Desktop

- [ ] Consider Windows 365 Cloud PC or Azure Virtual Desktop
- [ ] Employee accesses a cloud desktop, not your on-prem machine
- [ ] Data never leaves the cloud (no data on the laptop to steal)
- [ ] Managed patching, managed backups, managed security

---

## 5. Employee Device Security for Remote Work

### Company-Owned Devices

- [ ] Full disk encryption enabled (BitLocker on Windows, FileVault on Mac)
- [ ] EDR/endpoint protection installed and reporting
- [ ] VPN auto-connects or is always-on
- [ ] Screen lock after 5 minutes of inactivity
- [ ] USB storage blocked or audited (prevent data exfiltration)
- [ ] Local admin rights removed for daily-use accounts
- [ ] Remote wipe capability tested

### BYOD (Bring Your Own Device)

If employees use personal devices:

- [ ] **Never allow direct network access from BYOD** — use application-level access (ZTNA) instead
- [ ] Require current OS version (no unpatched personal machines on your network)
- [ ] Require endpoint protection installed
- [ ] Require full disk encryption
- [ ] Require screen lock
- [ ] Use MAM (Mobile Application Management) to containerize work data
- [ ] Enforce MFA on every application accessed from BYOD
- [ ] **Accept that BYOD is higher risk** — limit what BYOD devices can access compared to company-owned

---

## 6. SSH Access (For IT/Dev Teams)

```bash
# /etc/ssh/sshd_config — hardened configuration
Port 22                          # Consider non-standard port to reduce noise
PermitRootLogin no               # Never allow root SSH
PasswordAuthentication no        # Key-only authentication
PubkeyAuthentication yes
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
AllowUsers your-username         # Whitelist specific users
X11Forwarding no
AllowTcpForwarding no
AllowAgentForwarding no

# Restart SSH after changes
sudo systemctl restart sshd
```

- [ ] **SSH keys, not passwords** — disable password authentication entirely
- [ ] **Each person has their own key pair** — no shared keys
- [ ] **Keys protected with passphrases**
- [ ] **Old keys removed** when employees leave
  ```bash
  # Audit authorized keys for all users
  find /home -name "authorized_keys" -exec echo "=== {} ===" \; -exec cat {} \;
  ```
- [ ] **fail2ban or similar** installed to block brute force attempts
- [ ] **SSH accessible only through VPN** if possible (not directly internet-facing)

---

## 7. Monitoring Remote Access

- [ ] **Log all VPN connections** — who connected, when, from where, for how long
- [ ] **Alert on impossible travel** — same user connecting from two cities within an hour
- [ ] **Alert on off-hours access** — connections at 3 AM from unusual locations
- [ ] **Alert on failed authentication attempts** — brute force indicator
- [ ] **Review VPN logs monthly** for anomalies
- [ ] **Revoke access immediately** when employees leave — VPN credentials, SSH keys, RDP access, all of it

---

## 8. Mythos-Specific Concerns

VPN software itself is a target. Mythos-class scanning will likely find vulnerabilities in:

- VPN server software (OpenVPN, WireGuard, IPSec implementations)
- VPN client software
- SSL/TLS libraries used by VPN connections (Mythos found TLS implementation weaknesses)
- Authentication protocols

**Defense:**
- Keep VPN software updated (auto-update if possible)
- Use WireGuard or Tailscale (minimal codebase = smaller attack surface)
- Monitor for vendor security advisories
- Have a plan to switch VPN solutions if a critical vuln is found in yours

---

## Quick Wins (Do Today)

1. Run `nmap -p 3389 your-public-ip` from outside your network — is RDP exposed?
2. Run `nmap -p 22 your-public-ip` — is SSH exposed with password auth?
3. If either is exposed, fix it TODAY — this is your highest-risk item
4. If you don't have a VPN, set up Tailscale (free for up to 3 users, takes 15 minutes)
5. Audit who has VPN access — remove anyone who shouldn't
