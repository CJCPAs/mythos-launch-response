#!/bin/bash
# Mythos Readiness: Network and External Security Audit
# Usage: bash audit-network.sh [your-public-ip] [your-domain.com]
# Requires: nmap, dig, curl, openssl

set -euo pipefail

PUBLIC_IP="${1:-}"
DOMAIN="${2:-}"

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
echo " MYTHOS READINESS: NETWORK AUDIT"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "========================================${NC}\n"

if [ -z "$PUBLIC_IP" ] && [ -z "$DOMAIN" ]; then
    echo "Usage: bash audit-network.sh [public-ip] [domain.com]"
    echo "  Provide at least one of: public IP or domain name"
    echo ""
    echo "Examples:"
    echo "  bash audit-network.sh 203.0.113.50"
    echo "  bash audit-network.sh 203.0.113.50 example.com"
    echo "  bash audit-network.sh \"\" example.com"
    exit 1
fi

# ── 1. PORT SCAN ──────────────────────────────────────────
if [ -n "$PUBLIC_IP" ]; then
    echo -e "${WHITE}1. EXTERNAL PORT SCAN ($PUBLIC_IP)${NC}"
    if command -v nmap &>/dev/null; then
        # Scan common dangerous ports
        SCAN_RESULT=$(nmap -Pn -sT -p 22,23,25,80,443,445,1433,3306,3389,5432,5900,6379,8080,8443,27017 "$PUBLIC_IP" 2>/dev/null)

        # Check critical ports
        if echo "$SCAN_RESULT" | grep -q "3389/tcp.*open"; then
            report FAIL "RDP (3389) is OPEN — #1 ransomware attack vector. Close immediately or VPN-restrict."
        else
            report PASS "RDP (3389) not exposed"
        fi

        if echo "$SCAN_RESULT" | grep -q "445/tcp.*open"; then
            report FAIL "SMB (445) is OPEN — never expose SMB to the internet"
        else
            report PASS "SMB (445) not exposed"
        fi

        if echo "$SCAN_RESULT" | grep -q "23/tcp.*open"; then
            report FAIL "Telnet (23) is OPEN — unencrypted, replace with SSH"
        else
            report PASS "Telnet (23) not exposed"
        fi

        if echo "$SCAN_RESULT" | grep -q "3306/tcp.*open"; then
            report FAIL "MySQL (3306) is OPEN — databases should never be internet-facing"
        fi

        if echo "$SCAN_RESULT" | grep -q "5432/tcp.*open"; then
            report FAIL "PostgreSQL (5432) is OPEN — databases should never be internet-facing"
        fi

        if echo "$SCAN_RESULT" | grep -q "6379/tcp.*open"; then
            report FAIL "Redis (6379) is OPEN — Redis has no auth by default, critical exposure"
        fi

        if echo "$SCAN_RESULT" | grep -q "27017/tcp.*open"; then
            report FAIL "MongoDB (27017) is OPEN — databases should never be internet-facing"
        fi

        if echo "$SCAN_RESULT" | grep -q "5900/tcp.*open"; then
            report FAIL "VNC (5900) is OPEN — unencrypted remote access, close immediately"
        fi

        if echo "$SCAN_RESULT" | grep -q "22/tcp.*open"; then
            report WARN "SSH (22) is open — ensure key-only auth, fail2ban, and consider VPN-restricting"
        fi

        # Show all open ports
        echo ""
        report INFO "All open ports:"
        echo "$SCAN_RESULT" | grep "open" | while IFS= read -r line; do
            report INFO "  $line"
        done
    else
        report WARN "nmap not installed — install with: apt install nmap / brew install nmap"
    fi
else
    echo -e "${WHITE}1. PORT SCAN${NC}"
    report INFO "No public IP provided — skipping port scan"
fi

# ── 2. EMAIL SECURITY ─────────────────────────────────────
if [ -n "$DOMAIN" ]; then
    echo -e "\n${WHITE}2. EMAIL SECURITY ($DOMAIN)${NC}"
    if command -v dig &>/dev/null; then
        # SPF
        SPF=$(dig +short TXT "$DOMAIN" 2>/dev/null | grep "v=spf1" || true)
        if [ -n "$SPF" ]; then
            if echo "$SPF" | grep -q "\-all"; then
                report PASS "SPF record found with hard fail (-all): $SPF"
            elif echo "$SPF" | grep -q "~all"; then
                report WARN "SPF record found with soft fail (~all) — change to -all: $SPF"
            else
                report WARN "SPF record found but may be permissive: $SPF"
            fi
        else
            report FAIL "No SPF record found — email spoofing of your domain is possible"
        fi

        # DMARC
        DMARC=$(dig +short TXT "_dmarc.$DOMAIN" 2>/dev/null | grep "v=DMARC1" || true)
        if [ -n "$DMARC" ]; then
            if echo "$DMARC" | grep -q "p=reject"; then
                report PASS "DMARC record found with reject policy: $DMARC"
            elif echo "$DMARC" | grep -q "p=quarantine"; then
                report WARN "DMARC record found with quarantine policy — upgrade to p=reject"
            elif echo "$DMARC" | grep -q "p=none"; then
                report FAIL "DMARC record found but set to p=none (monitoring only, not enforcing)"
            fi
        else
            report FAIL "No DMARC record found — email spoofing protection missing"
        fi

        # DKIM (check common selectors)
        DKIM_FOUND=false
        for selector in default google s1 s2 selector1 selector2 k1; do
            DKIM=$(dig +short TXT "${selector}._domainkey.$DOMAIN" 2>/dev/null | grep "v=DKIM1" || true)
            if [ -n "$DKIM" ]; then
                report PASS "DKIM record found (selector: $selector)"
                DKIM_FOUND=true
                break
            fi
        done
        if [ "$DKIM_FOUND" = false ]; then
            report WARN "No DKIM record found at common selectors — may use a non-standard selector"
        fi

        # MX records
        MX=$(dig +short MX "$DOMAIN" 2>/dev/null || true)
        if [ -n "$MX" ]; then
            report INFO "MX records:"
            echo "$MX" | while IFS= read -r mx; do
                report INFO "  $mx"
            done
        else
            report WARN "No MX records found"
        fi
    else
        report WARN "dig not installed — install with: apt install dnsutils / brew install bind"
    fi

    # ── 3. TLS CERTIFICATE ────────────────────────────────
    echo -e "\n${WHITE}3. TLS CERTIFICATE ($DOMAIN)${NC}"
    if command -v openssl &>/dev/null; then
        CERT_INFO=$(echo | openssl s_client -servername "$DOMAIN" -connect "$DOMAIN:443" 2>/dev/null | openssl x509 -noout -dates -subject 2>/dev/null || true)
        if [ -n "$CERT_INFO" ]; then
            EXPIRY=$(echo "$CERT_INFO" | grep "notAfter" | cut -d= -f2)
            if [ -n "$EXPIRY" ]; then
                EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s 2>/dev/null || date -j -f "%b %d %H:%M:%S %Y %Z" "$EXPIRY" +%s 2>/dev/null || echo 0)
                NOW_EPOCH=$(date +%s)
                DAYS_LEFT=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))
                if [ "$DAYS_LEFT" -gt 30 ]; then
                    report PASS "TLS certificate valid for $DAYS_LEFT more days (expires: $EXPIRY)"
                elif [ "$DAYS_LEFT" -gt 0 ]; then
                    report WARN "TLS certificate expires in $DAYS_LEFT days — renew soon"
                else
                    report FAIL "TLS certificate EXPIRED"
                fi
            fi
        else
            report WARN "Could not retrieve TLS certificate from $DOMAIN:443"
        fi
    fi

    # ── 4. HTTP SECURITY HEADERS ──────────────────────────
    echo -e "\n${WHITE}4. HTTP SECURITY HEADERS (https://$DOMAIN)${NC}"
    if command -v curl &>/dev/null; then
        HEADERS=$(curl -sI "https://$DOMAIN" 2>/dev/null || true)
        if [ -n "$HEADERS" ]; then
            # HSTS
            if echo "$HEADERS" | grep -qi "strict-transport-security"; then
                report PASS "HSTS header present"
            else
                report FAIL "HSTS header MISSING — browsers may connect over HTTP"
            fi

            # X-Content-Type-Options
            if echo "$HEADERS" | grep -qi "x-content-type-options"; then
                report PASS "X-Content-Type-Options header present"
            else
                report WARN "X-Content-Type-Options header missing"
            fi

            # X-Frame-Options
            if echo "$HEADERS" | grep -qi "x-frame-options"; then
                report PASS "X-Frame-Options header present"
            else
                report WARN "X-Frame-Options header missing (clickjacking risk)"
            fi

            # Content-Security-Policy
            if echo "$HEADERS" | grep -qi "content-security-policy"; then
                report PASS "Content-Security-Policy header present"
            else
                report WARN "Content-Security-Policy header missing"
            fi

            # Referrer-Policy
            if echo "$HEADERS" | grep -qi "referrer-policy"; then
                report PASS "Referrer-Policy header present"
            else
                report WARN "Referrer-Policy header missing"
            fi

            # Server header (information leakage)
            SERVER=$(echo "$HEADERS" | grep -i "^server:" | head -1)
            if [ -n "$SERVER" ]; then
                report WARN "Server header exposed: $SERVER (leaks software info)"
            else
                report PASS "Server header not exposed"
            fi
        else
            report WARN "Could not fetch headers from https://$DOMAIN"
        fi
    fi
else
    echo -e "\n${WHITE}2-4. EMAIL / TLS / HEADERS${NC}"
    report INFO "No domain provided — skipping email, TLS, and header checks"
fi

# ── SUMMARY ──���────────────────────────────────────────────
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

echo -e "\n  ${GRAY}Full guide: https://github.com/CJCPAs/mythos-launch-response/blob/main/stacks/network-equipment.md${NC}"
echo -e "  ${GRAY}VPN guide: https://github.com/CJCPAs/mythos-launch-response/blob/main/stacks/vpn-remote-access.md${NC}\n"
