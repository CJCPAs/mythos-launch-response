# Linux Server Hardening Guide

**For teams running Linux servers (VPS, dedicated, cloud instances) in the post-Mythos era.**

---

## Immediate Actions

```bash
# 1. Full system update
sudo apt update && sudo apt upgrade -y

# 2. Check kernel version - ensure it's current
uname -r

# 3. Review open ports
ss -tlnp

# 4. Review running services
systemctl list-units --type=service --state=running

# 5. Check for unauthorized users
cat /etc/passwd | grep -v nologin | grep -v false

# 6. Check for unauthorized SSH keys
find /home -name "authorized_keys" -exec echo "=== {} ===" \; -exec cat {} \;

# 7. Check cron jobs for all users
for user in $(cut -f1 -d: /etc/passwd); do echo "=== $user ==="; crontab -u $user -l 2>/dev/null; done

# 8. Review firewall rules
sudo ufw status verbose  # or iptables -L -n

# 9. Check for SUID binaries (potential privilege escalation)
find / -perm -4000 -type f 2>/dev/null

# 10. Enable automatic security updates
sudo apt install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

---

## SSH Hardening

Edit `/etc/ssh/sshd_config`:

```
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
AllowUsers your-username
```

---

## Firewall (UFW)

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
# Add specific ports as needed
sudo ufw enable
```

---

## Monitoring

```bash
# Install and configure fail2ban
sudo apt install fail2ban
sudo systemctl enable fail2ban

# Monitor auth logs
tail -f /var/log/auth.log

# Check for recent failed login attempts
grep "Failed password" /var/log/auth.log | tail -20
```

---

## Post-Mythos: Key Concerns

Mythos found vulnerabilities in the Linux kernel itself. Your servers are running that kernel.

- **Enable automatic kernel updates** and plan for regular reboots
- **Use kernel live patching** if uptime is critical (Ubuntu Livepatch, KernelCare)
- **Minimize installed software** - every binary is potential attack surface
- **Container isolation** - run services in containers to limit blast radius
- **Network segmentation** - don't let a compromised service pivot to others
