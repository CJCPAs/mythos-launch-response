#!/bin/bash
# Mythos Readiness: Linux Server Security Audit
# Usage: sudo bash audit-linux.sh
# Requires: root/sudo for full results

set -euo pipefail

PASS=0; FAIL=0; WARN=0

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; WHITE='\033[1;37m'; GRAY='\033[0;37m'; NC='\033[0m'

report() {
    case $1 in
        PASS) echo -e "  ${GREEN}[PASS]${NC} $2"; ((PASS++)) ;;
        FAIL) echo -e "  ${RED}[FAIL]${NC} $2"; ((FAIL++)) ;;
        WARN) echo -e "  ${YELLOW}[WARN]${NC} $2"; ((WARN++)) ;;
        INFO) echo -e "  ${GRAY}[INFO]${NC} $2" ;;
    esac
}

echo -e "\n${CYAN}========================================"
echo " MYTHOS READINESS: LINUX AUDIT"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "========================================${NC}\n"

# ── 1. OS AND KERNEL ──────────────────────────────────────
echo -e "${WHITE}1. OS AND KERNEL${NC}"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    report INFO "OS: $PRETTY_NAME"
fi
report INFO "Kernel: $(uname -r)"

# Check if kernel is up to date
if command -v apt &>/dev/null; then
    UPGRADABLE=$(apt list --upgradable 2>/dev/null | grep -c "linux-image" || true)
    if [ "$UPGRADABLE" -gt 0 ]; then
        report FAIL "Kernel update available — $UPGRADABLE kernel package(s) pending"
    else
        report PASS "Kernel appears current"
    fi
elif command -v dnf &>/dev/null; then
    UPGRADABLE=$(dnf check-update kernel 2>/dev/null | grep -c kernel || true)
    if [ "$UPGRADABLE" -gt 0 ]; then
        report FAIL "Kernel update available"
    else
        report PASS "Kernel appears current"
    fi
fi

# ── 2. SYSTEM UPDATES ────────────────────────────────────
echo -e "\n${WHITE}2. SYSTEM UPDATES${NC}"
if command -v apt &>/dev/null; then
    TOTAL_UPGRADABLE=$(apt list --upgradable 2>/dev/null | grep -c "upgradable" || true)
    if [ "$TOTAL_UPGRADABLE" -eq 0 ]; then
        report PASS "All packages up to date"
    elif [ "$TOTAL_UPGRADABLE" -le 5 ]; then
        report WARN "$TOTAL_UPGRADABLE packages have updates available"
    else
        report FAIL "$TOTAL_UPGRADABLE packages have updates available"
    fi
elif command -v dnf &>/dev/null; then
    TOTAL_UPGRADABLE=$(dnf check-update 2>/dev/null | grep -c "^[a-zA-Z]" || true)
    if [ "$TOTAL_UPGRADABLE" -eq 0 ]; then
        report PASS "All packages up to date"
    else
        report WARN "$TOTAL_UPGRADABLE packages have updates available"
    fi
fi

# Auto-updates
if dpkg -l unattended-upgrades &>/dev/null 2>&1; then
    report PASS "unattended-upgrades installed"
elif systemctl is-active dnf-automatic.timer &>/dev/null 2>&1; then
    report PASS "dnf-automatic timer active"
else
    report FAIL "No automatic security updates configured"
fi

# ── 3. OPEN PORTS ─────────────────────────────────────────
echo -e "\n${WHITE}3. OPEN PORTS AND SERVICES${NC}"
if command -v ss &>/dev/null; then
    LISTENING=$(ss -tlnp 2>/dev/null | tail -n +2)
    LISTEN_COUNT=$(echo "$LISTENING" | grep -c "LISTEN" || true)
    report INFO "$LISTEN_COUNT services listening"

    # Check for dangerous ports
    if echo "$LISTENING" | grep -q ":3306 "; then
        report WARN "MySQL (3306) listening — verify not internet-accessible"
    fi
    if echo "$LISTENING" | grep -q ":5432 "; then
        report WARN "PostgreSQL (5432) listening — verify not internet-accessible"
    fi
    if echo "$LISTENING" | grep -q ":6379 "; then
        report FAIL "Redis (6379) listening — Redis should NEVER be internet-accessible"
    fi
    if echo "$LISTENING" | grep -q ":27017 "; then
        report WARN "MongoDB (27017) listening — verify not internet-accessible"
    fi

    echo "$LISTENING" | while IFS= read -r line; do
        report INFO "  $line"
    done
fi

# ── 4. SSH CONFIGURATION ─────────────────────────────────
echo -e "\n${WHITE}4. SSH HARDENING${NC}"
SSHD_CONFIG="/etc/ssh/sshd_config"
if [ -f "$SSHD_CONFIG" ]; then
    # Root login
    ROOT_LOGIN=$(grep -i "^PermitRootLogin" "$SSHD_CONFIG" 2>/dev/null | awk '{print $2}')
    if [ "$ROOT_LOGIN" = "no" ]; then
        report PASS "Root login disabled"
    elif [ -z "$ROOT_LOGIN" ]; then
        report WARN "PermitRootLogin not explicitly set (default may allow root)"
    else
        report FAIL "Root login allowed ($ROOT_LOGIN)"
    fi

    # Password authentication
    PASS_AUTH=$(grep -i "^PasswordAuthentication" "$SSHD_CONFIG" 2>/dev/null | awk '{print $2}')
    if [ "$PASS_AUTH" = "no" ]; then
        report PASS "Password authentication disabled (key-only)"
    else
        report WARN "Password authentication enabled — consider key-only"
    fi

    # Max auth tries
    MAX_AUTH=$(grep -i "^MaxAuthTries" "$SSHD_CONFIG" 2>/dev/null | awk '{print $2}')
    if [ -n "$MAX_AUTH" ] && [ "$MAX_AUTH" -le 5 ]; then
        report PASS "MaxAuthTries set to $MAX_AUTH"
    else
        report WARN "MaxAuthTries not restricted (default 6)"
    fi
else
    report INFO "SSH config not found at $SSHD_CONFIG"
fi

# Authorized keys audit
echo -e "\n  Authorized SSH keys:"
find /home -name "authorized_keys" 2>/dev/null | while IFS= read -r keyfile; do
    KEY_COUNT=$(wc -l < "$keyfile" 2>/dev/null || echo 0)
    OWNER=$(stat -c '%U' "$keyfile" 2>/dev/null || echo "unknown")
    report INFO "  $keyfile ($KEY_COUNT keys, owner: $OWNER)"
done
ROOT_KEYS="/root/.ssh/authorized_keys"
if [ -f "$ROOT_KEYS" ]; then
    report WARN "Root has authorized_keys — $(wc -l < "$ROOT_KEYS") keys"
fi

# ── 5. FIREWALL ───────────────────────────────────────────
echo -e "\n${WHITE}5. FIREWALL${NC}"
if command -v ufw &>/dev/null; then
    UFW_STATUS=$(ufw status 2>/dev/null | head -1)
    if echo "$UFW_STATUS" | grep -q "active"; then
        report PASS "UFW firewall active"
        ufw status numbered 2>/dev/null | tail -n +4 | while IFS= read -r rule; do
            report INFO "  $rule"
        done
    else
        report FAIL "UFW firewall INACTIVE"
    fi
elif command -v firewall-cmd &>/dev/null; then
    if firewall-cmd --state &>/dev/null 2>&1; then
        report PASS "firewalld active"
    else
        report FAIL "firewalld INACTIVE"
    fi
elif iptables -L -n &>/dev/null 2>&1; then
    RULES=$(iptables -L -n 2>/dev/null | grep -c "^[A-Z]" || true)
    if [ "$RULES" -gt 3 ]; then
        report PASS "iptables has $RULES chains with rules"
    else
        report WARN "iptables appears to have minimal rules"
    fi
else
    report FAIL "No firewall detected (ufw, firewalld, or iptables)"
fi

# ── 6. SUID BINARIES ─────────────────────────────────────
echo -e "\n${WHITE}6. SUID BINARIES (privilege escalation risk)${NC}"
SUID_COUNT=$(find / -perm -4000 -type f 2>/dev/null | wc -l)
report INFO "$SUID_COUNT SUID binaries found"
if [ "$SUID_COUNT" -gt 30 ]; then
    report WARN "High number of SUID binaries — review for unnecessary entries"
fi
# Flag unusual ones
find / -perm -4000 -type f 2>/dev/null | while IFS= read -r binary; do
    case "$binary" in
        /usr/bin/passwd|/usr/bin/sudo|/usr/bin/su|/usr/bin/mount|/usr/bin/umount|/usr/bin/chfn|/usr/bin/chsh|/usr/bin/newgrp|/usr/bin/gpasswd|/usr/lib/openssh/ssh-keysign|/usr/lib/dbus-*)
            ;; # Expected SUID binaries
        *)
            report WARN "Unexpected SUID binary: $binary"
            ;;
    esac
done

# ── 7. USER ACCOUNTS ─────────────────────────────────────
echo -e "\n${WHITE}7. USER ACCOUNTS${NC}"
LOGIN_USERS=$(grep -v "nologin\|false\|sync\|shutdown\|halt" /etc/passwd | grep -v "^#")
LOGIN_COUNT=$(echo "$LOGIN_USERS" | wc -l)
report INFO "$LOGIN_COUNT accounts with login shells"
echo "$LOGIN_USERS" | while IFS=: read -r user _ uid _ _ _ shell; do
    if [ "$uid" -eq 0 ] && [ "$user" != "root" ]; then
        report FAIL "Non-root user '$user' has UID 0 (root equivalent)"
    elif [ "$uid" -ge 1000 ] || [ "$user" = "root" ]; then
        report INFO "  $user (UID $uid, shell: $shell)"
    fi
done

# ── 8. CRON JOBS ──────────────────────────────────────────
echo -e "\n${WHITE}8. SCHEDULED TASKS (cron)${NC}"
for user in $(cut -f1 -d: /etc/passwd); do
    CRONTAB=$(crontab -u "$user" -l 2>/dev/null | grep -v "^#" | grep -v "^$" || true)
    if [ -n "$CRONTAB" ]; then
        report INFO "Cron jobs for $user:"
        echo "$CRONTAB" | while IFS= read -r job; do
            report INFO "  $job"
        done
    fi
done

# ── 9. FAIL2BAN ──────────────────────────────────────────
echo -e "\n${WHITE}9. BRUTE FORCE PROTECTION${NC}"
if command -v fail2ban-client &>/dev/null; then
    if systemctl is-active fail2ban &>/dev/null; then
        report PASS "fail2ban running"
        JAILS=$(fail2ban-client status 2>/dev/null | grep "Jail list" | sed 's/.*://;s/,/ /g' || true)
        report INFO "Active jails: $JAILS"
    else
        report WARN "fail2ban installed but not running"
    fi
else
    report WARN "fail2ban not installed — brute force attacks unmitigated"
fi

# Recent failed logins
FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l || true)
if [ "$FAILED_LOGINS" -gt 100 ]; then
    report WARN "$FAILED_LOGINS failed login attempts in auth.log — possible brute force"
elif [ "$FAILED_LOGINS" -gt 0 ]; then
    report INFO "$FAILED_LOGINS failed login attempts in auth.log"
fi

# ── 10. FILE PERMISSIONS ──────────────────────────────────
echo -e "\n${WHITE}10. CRITICAL FILE PERMISSIONS${NC}"
for file in /etc/shadow /etc/gshadow; do
    if [ -f "$file" ]; then
        PERMS=$(stat -c '%a' "$file" 2>/dev/null)
        if [ "$PERMS" = "640" ] || [ "$PERMS" = "600" ] || [ "$PERMS" = "000" ]; then
            report PASS "$file permissions: $PERMS"
        else
            report FAIL "$file permissions: $PERMS (should be 640 or more restrictive)"
        fi
    fi
done

if [ -f /etc/ssh/sshd_config ]; then
    PERMS=$(stat -c '%a' /etc/ssh/sshd_config 2>/dev/null)
    if [ "$PERMS" = "600" ] || [ "$PERMS" = "644" ]; then
        report PASS "sshd_config permissions: $PERMS"
    else
        report WARN "sshd_config permissions: $PERMS"
    fi
fi

# ── SUMMARY ───────────────────────────────────────────────
echo -e "\n${CYAN}========================================"
echo " AUDIT SUMMARY"
echo -e "========================================${NC}"
echo -e "  ${GREEN}PASS: $PASS${NC}"
echo -e "  ${RED}FAIL: $FAIL${NC}"
echo -e "  ${YELLOW}WARN: $WARN${NC}"
echo ""

if [ $FAIL -eq 0 ] && [ $WARN -eq 0 ]; then
    echo -e "  ${GREEN}STATUS: STRONG — All checks passed${NC}"
elif [ $FAIL -eq 0 ]; then
    echo -e "  ${YELLOW}STATUS: GOOD — No failures, $WARN warnings to review${NC}"
elif [ $FAIL -le 2 ]; then
    echo -e "  ${YELLOW}STATUS: NEEDS ATTENTION — $FAIL failures to fix${NC}"
else
    echo -e "  ${RED}STATUS: CRITICAL — $FAIL failures require immediate action${NC}"
fi

echo -e "\n  ${GRAY}Full guide: https://github.com/CJCPAs/mythos-launch-response/blob/main/stacks/linux-servers.md${NC}\n"
