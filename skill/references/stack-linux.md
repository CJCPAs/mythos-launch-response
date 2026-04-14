# Linux Server Hardening Reference

## Critical Checks

```bash
# 1. System updates
sudo apt update && apt list --upgradable 2>/dev/null | grep -c "upgradable"

# 2. Open ports
ss -tlnp

# 3. SSH config
grep -E "^(PermitRootLogin|PasswordAuthentication|MaxAuthTries)" /etc/ssh/sshd_config

# 4. Firewall
ufw status verbose

# 5. Auto-updates
dpkg -l unattended-upgrades 2>/dev/null && echo "installed" || echo "NOT installed"
```

## Hardening Actions

1. Full system update: `sudo apt update && sudo apt upgrade -y`
2. Enable auto-updates: `sudo apt install unattended-upgrades && sudo dpkg-reconfigure -plow unattended-upgrades`
3. SSH: PermitRootLogin no, PasswordAuthentication no, MaxAuthTries 3
4. Firewall: `sudo ufw default deny incoming && sudo ufw allow ssh && sudo ufw enable`
5. Install fail2ban: `sudo apt install fail2ban && sudo systemctl enable fail2ban`
6. Audit SUID binaries: `find / -perm -4000 -type f 2>/dev/null`
7. Audit authorized SSH keys: `find /home -name "authorized_keys" -exec cat {} \;`
8. Audit cron jobs for all users
9. Verify /etc/shadow permissions (640 or more restrictive)

## Mythos Context
Mythos found Linux kernel privilege escalation exploits for under $2,000. Kernel patches are critical. Consider kernel live patching if uptime is essential.
