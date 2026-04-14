#!/bin/bash
# Mythos Readiness: Dependency and Supply Chain Audit
# Usage: bash audit-dependencies.sh [path-to-project]
# Checks npm, pip, system packages, and Docker images

set -euo pipefail

PROJECT_DIR="${1:-.}"

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
echo " MYTHOS READINESS: DEPENDENCY AUDIT"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo " Project: $PROJECT_DIR"
echo -e "========================================${NC}\n"

# ── 1. NODE.JS / NPM ─────────────────────────────────────
if [ -f "$PROJECT_DIR/package.json" ]; then
    echo -e "${WHITE}1. NODE.JS DEPENDENCIES${NC}"
    report INFO "package.json found"

    if command -v npm &>/dev/null; then
        # npm audit
        cd "$PROJECT_DIR"
        AUDIT_OUTPUT=$(npm audit --production 2>/dev/null || true)
        CRITICAL=$(echo "$AUDIT_OUTPUT" | grep -c "critical" || true)
        HIGH=$(echo "$AUDIT_OUTPUT" | grep -c "high" || true)

        if echo "$AUDIT_OUTPUT" | grep -q "found 0 vulnerabilities"; then
            report PASS "npm audit: no vulnerabilities found"
        else
            if [ "$CRITICAL" -gt 0 ]; then
                report FAIL "npm audit: CRITICAL vulnerabilities found"
            fi
            if [ "$HIGH" -gt 0 ]; then
                report FAIL "npm audit: HIGH vulnerabilities found"
            fi
            report INFO "Run 'npm audit' for details"
        fi

        # Outdated packages
        OUTDATED=$(npm outdated --json 2>/dev/null || echo "{}")
        OUTDATED_COUNT=$(echo "$OUTDATED" | python3 -c "import sys,json; print(len(json.load(sys.stdin)))" 2>/dev/null || echo "0")
        if [ "$OUTDATED_COUNT" -eq 0 ]; then
            report PASS "All npm packages up to date"
        elif [ "$OUTDATED_COUNT" -le 5 ]; then
            report WARN "$OUTDATED_COUNT npm packages have newer versions"
        else
            report WARN "$OUTDATED_COUNT npm packages have newer versions"
        fi

        # Check for lockfile
        if [ -f "$PROJECT_DIR/package-lock.json" ] || [ -f "$PROJECT_DIR/yarn.lock" ] || [ -f "$PROJECT_DIR/pnpm-lock.yaml" ]; then
            report PASS "Lockfile present (dependency versions pinned)"
        else
            report FAIL "No lockfile found — dependency versions not pinned (supply chain risk)"
        fi
        cd - &>/dev/null
    else
        report WARN "npm not installed — cannot audit Node.js dependencies"
    fi
else
    echo -e "${WHITE}1. NODE.JS${NC}"
    report INFO "No package.json found — skipping npm audit"
fi

# ── 2. PYTHON / PIP ──────────────────────────────────────
echo ""
if [ -f "$PROJECT_DIR/requirements.txt" ] || [ -f "$PROJECT_DIR/pyproject.toml" ] || [ -f "$PROJECT_DIR/Pipfile" ]; then
    echo -e "${WHITE}2. PYTHON DEPENDENCIES${NC}"

    if command -v pip-audit &>/dev/null; then
        cd "$PROJECT_DIR"
        AUDIT_OUTPUT=$(pip-audit 2>/dev/null || true)
        VULN_COUNT=$(echo "$AUDIT_OUTPUT" | grep -c "VULN" || true)
        if [ "$VULN_COUNT" -eq 0 ]; then
            report PASS "pip-audit: no vulnerabilities found"
        else
            report FAIL "pip-audit: $VULN_COUNT vulnerabilities found"
            report INFO "Run 'pip-audit' for details"
        fi
        cd - &>/dev/null
    elif command -v safety &>/dev/null; then
        cd "$PROJECT_DIR"
        if safety check 2>/dev/null; then
            report PASS "safety check: no vulnerabilities found"
        else
            report FAIL "safety check: vulnerabilities found"
        fi
        cd - &>/dev/null
    else
        report WARN "Neither pip-audit nor safety installed — install with: pip install pip-audit"
    fi
else
    echo -e "${WHITE}2. PYTHON${NC}"
    report INFO "No Python project files found — skipping pip audit"
fi

# ── 3. DOCKER IMAGES ─────────────────────────────────────
echo ""
if [ -f "$PROJECT_DIR/Dockerfile" ] || [ -f "$PROJECT_DIR/docker-compose.yml" ] || [ -f "$PROJECT_DIR/docker-compose.yaml" ]; then
    echo -e "${WHITE}3. DOCKER IMAGES${NC}"
    report INFO "Docker configuration found"

    if command -v trivy &>/dev/null; then
        report INFO "Scanning with Trivy..."
        # Scan the Dockerfile for misconfigurations
        if [ -f "$PROJECT_DIR/Dockerfile" ]; then
            TRIVY_OUTPUT=$(trivy config "$PROJECT_DIR/Dockerfile" 2>/dev/null || true)
            MISCONFIG=$(echo "$TRIVY_OUTPUT" | grep -c "CRITICAL\|HIGH" || true)
            if [ "$MISCONFIG" -eq 0 ]; then
                report PASS "Dockerfile: no critical/high misconfigurations"
            else
                report WARN "Dockerfile: $MISCONFIG critical/high misconfigurations found"
            fi
        fi
    elif command -v docker &>/dev/null && command -v docker scout &>/dev/null; then
        report INFO "Trivy not installed, Docker Scout available — run 'docker scout cves' on your images"
    else
        report WARN "Neither Trivy nor Docker Scout available — install Trivy: brew install trivy"
    fi

    # Check for root user in Dockerfile
    if [ -f "$PROJECT_DIR/Dockerfile" ]; then
        if grep -q "^USER " "$PROJECT_DIR/Dockerfile"; then
            report PASS "Dockerfile sets a non-root USER"
        else
            report WARN "Dockerfile does not set USER — container may run as root"
        fi
    fi
else
    echo -e "${WHITE}3. DOCKER${NC}"
    report INFO "No Docker files found — skipping container audit"
fi

# ── 4. SECRETS SCAN ───────────────────────────────────────
echo ""
echo -e "${WHITE}4. SECRETS IN CODE${NC}"
if command -v trufflehog &>/dev/null; then
    report INFO "Scanning for secrets with TruffleHog..."
    SECRET_COUNT=$(trufflehog filesystem "$PROJECT_DIR" --only-verified --json 2>/dev/null | wc -l || true)
    if [ "$SECRET_COUNT" -eq 0 ]; then
        report PASS "No verified secrets found in codebase"
    else
        report FAIL "$SECRET_COUNT verified secrets found in codebase — rotate immediately"
        report INFO "Run 'trufflehog filesystem $PROJECT_DIR --only-verified' for details"
    fi
else
    # Fallback: basic grep for common patterns
    report INFO "TruffleHog not installed — running basic pattern check"
    PATTERNS="sk_live\|sk_test\|AKIA[A-Z0-9]\|password\s*=\s*['\"].\+['\"]\|-----BEGIN.*PRIVATE KEY"
    FOUND=$(grep -rl "$PATTERNS" "$PROJECT_DIR" --include="*.ts" --include="*.js" --include="*.py" --include="*.env" --include="*.json" 2>/dev/null | grep -v node_modules | grep -v ".git" | head -20 || true)
    if [ -n "$FOUND" ]; then
        report WARN "Possible secrets found in files (install TruffleHog for verified results):"
        echo "$FOUND" | while IFS= read -r file; do
            report WARN "  $file"
        done
    else
        report PASS "No obvious secret patterns found (basic scan only)"
    fi
fi

# ── 5. .GITIGNORE CHECK ──────────────────────────────────
echo ""
echo -e "${WHITE}5. GITIGNORE SAFETY${NC}"
if [ -f "$PROJECT_DIR/.gitignore" ]; then
    for pattern in ".env" ".env.local" ".env.production" "*.pem" "*.key"; do
        if grep -q "$pattern" "$PROJECT_DIR/.gitignore" 2>/dev/null; then
            report PASS ".gitignore includes $pattern"
        else
            report WARN ".gitignore does NOT include $pattern"
        fi
    done
else
    report FAIL "No .gitignore found — secrets may be committed to git"
fi

# ── 6. SYSTEM PACKAGES ───────────────────────────────────
echo ""
echo -e "${WHITE}6. SYSTEM PACKAGES${NC}"
if command -v apt &>/dev/null; then
    SECURITY_UPDATES=$(apt list --upgradable 2>/dev/null | grep -i "security" | wc -l || true)
    TOTAL_UPDATES=$(apt list --upgradable 2>/dev/null | grep -c "upgradable" || true)
    if [ "$SECURITY_UPDATES" -gt 0 ]; then
        report FAIL "$SECURITY_UPDATES security updates pending"
    elif [ "$TOTAL_UPDATES" -gt 0 ]; then
        report WARN "$TOTAL_UPDATES non-security updates pending"
    else
        report PASS "System packages up to date"
    fi
elif command -v dnf &>/dev/null; then
    UPDATES=$(dnf check-update --security 2>/dev/null | grep -c "^[a-zA-Z]" || true)
    if [ "$UPDATES" -gt 0 ]; then
        report FAIL "$UPDATES security updates pending"
    else
        report PASS "System packages up to date"
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
    echo -e "  ${GREEN}STATUS: CLEAN — No issues found${NC}"
elif [ $FAIL -eq 0 ]; then
    echo -e "  ${YELLOW}STATUS: MOSTLY CLEAN — $WARN items to review${NC}"
else
    echo -e "  ${RED}STATUS: ACTION NEEDED — $FAIL issues to fix${NC}"
fi

echo -e "\n  ${GRAY}Full guide: https://github.com/CJCPAs/mythos-launch-response${NC}\n"
