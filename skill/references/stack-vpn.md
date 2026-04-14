# VPN / Remote Access Hardening Reference

## Critical Checks

```bash
# Is RDP exposed? (run from outside network)
nmap -p 3389 your-public-ip  # Must NOT show "open"

# Is SSH exposed with password auth?
nmap -p 22 your-public-ip
grep "PasswordAuthentication" /etc/ssh/sshd_config  # Must be "no"
```

## Rules

1. **Never expose RDP directly to the internet** — #1 ransomware vector
2. Never expose SSH with password auth to the internet
3. No split tunneling for sensitive work
4. Each person gets their own VPN credentials/keys
5. Revoke access immediately on departure

## Recommended Solutions

| Solution | Best For |
|----------|---------|
| Tailscale | Non-technical teams. Zero-config WireGuard mesh. SSO integration. |
| WireGuard | Technical teams. Fast, minimal attack surface, audited. |
| Cloudflare Access | Application-level ZTNA. Free up to 50 users. |
| OpenVPN | If already deployed. Enforce TLS 1.2+, cert-based auth, tls-crypt, disable compression. |

## RDP If Required

- Only through VPN (never directly exposed)
- Network Level Authentication enabled
- Account lockout after 5 failed attempts
- Session timeout configured
- Consider cloud desktop (Windows 365) instead

## SSH Hardening

```
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
MaxAuthTries 3
AllowUsers specific-username
```

## Mythos Context
VPN software itself is an attack target. Mythos found TLS implementation weaknesses. Keep VPN software updated. WireGuard/Tailscale have minimal codebases (smaller attack surface).
