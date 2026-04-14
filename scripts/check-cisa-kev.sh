#!/bin/bash
# Mythos Readiness: CISA Known Exploited Vulnerabilities Monitor
# Usage: bash check-cisa-kev.sh [optional: vendor or product to filter]
# Requires: curl, jq

set -euo pipefail

FILTER="${1:-}"

CYAN='\033[0;36m'; WHITE='\033[1;37m'; RED='\033[0;31m'
YELLOW='\033[1;33m'; GRAY='\033[0;37m'; NC='\033[0m'

echo -e "\n${CYAN}========================================"
echo " CISA KNOWN EXPLOITED VULNERABILITIES"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "========================================${NC}\n"

if ! command -v curl &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Requires curl and jq. Install with:"
    echo "  apt install curl jq"
    echo "  brew install curl jq"
    exit 1
fi

KEV_URL="https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json"

echo -e "${WHITE}Downloading KEV catalog...${NC}"
KEV_DATA=$(curl -s "$KEV_URL")

TOTAL=$(echo "$KEV_DATA" | jq '.vulnerabilities | length')
echo -e "Total known exploited vulnerabilities: ${RED}$TOTAL${NC}\n"

# ── MOST RECENT ADDITIONS ────────────────────────────────
echo -e "${WHITE}10 Most Recently Added:${NC}\n"
echo "$KEV_DATA" | jq -r '
    .vulnerabilities | sort_by(.dateAdded) | reverse | .[0:10] |
    .[] | "  \(.dateAdded) | \(.cveID) | \(.vendorProject) | \(.product) | \(.shortDescription[0:80])"
'

# ── MYTHOS-RELATED CVEs ──────────────────────────────────
echo -e "\n${WHITE}Checking for Mythos-disclosed CVEs:${NC}\n"

# Check specific known Mythos CVEs
for cve in "CVE-2026-4747"; do
    FOUND=$(echo "$KEV_DATA" | jq -r --arg cve "$cve" '.vulnerabilities[] | select(.cveID == $cve) | "\(.cveID) | \(.vendorProject) | \(.product) | Due: \(.dueDate)"' 2>/dev/null || true)
    if [ -n "$FOUND" ]; then
        echo -e "  ${RED}[IN KEV]${NC} $FOUND"
    else
        echo -e "  ${GRAY}[NOT IN KEV]${NC} $cve — not yet in CISA catalog"
    fi
done

# ── FILTERED SEARCH ───────────────────────────────────────
if [ -n "$FILTER" ]; then
    echo -e "\n${WHITE}Filtering for: $FILTER${NC}\n"
    RESULTS=$(echo "$KEV_DATA" | jq -r --arg f "$FILTER" '
        .vulnerabilities[] |
        select((.vendorProject | ascii_downcase | contains($f | ascii_downcase)) or
               (.product | ascii_downcase | contains($f | ascii_downcase))) |
        "  \(.dateAdded) | \(.cveID) | \(.vendorProject) | \(.product) | Due: \(.dueDate)"
    ' | sort -r | head -20)

    if [ -n "$RESULTS" ]; then
        echo "$RESULTS"
        MATCH_COUNT=$(echo "$RESULTS" | wc -l)
        echo -e "\n  ${YELLOW}$MATCH_COUNT matches found for '$FILTER'${NC}"
    else
        echo -e "  ${GRAY}No matches for '$FILTER'${NC}"
    fi
fi

# ── DUE DATE CHECK ────────────────────────────────────────
echo -e "\n${WHITE}Vulnerabilities with remediation due in the next 14 days:${NC}\n"
TODAY=$(date '+%Y-%m-%d')
FUTURE=$(date -d "+14 days" '+%Y-%m-%d' 2>/dev/null || date -v+14d '+%Y-%m-%d' 2>/dev/null || echo "")

if [ -n "$FUTURE" ]; then
    UPCOMING=$(echo "$KEV_DATA" | jq -r --arg today "$TODAY" --arg future "$FUTURE" '
        .vulnerabilities[] |
        select(.dueDate >= $today and .dueDate <= $future) |
        "  \(.dueDate) | \(.cveID) | \(.vendorProject) | \(.product)"
    ' | sort | head -20)

    if [ -n "$UPCOMING" ]; then
        echo "$UPCOMING"
    else
        echo -e "  ${GRAY}No KEV entries due in the next 14 days${NC}"
    fi
fi

# ── STATS ─────────────────────────────────────────────────
echo -e "\n${WHITE}Top 10 Vendors in KEV catalog:${NC}\n"
echo "$KEV_DATA" | jq -r '.vulnerabilities[].vendorProject' | sort | uniq -c | sort -rn | head -10 | while read -r count vendor; do
    printf "  %4d  %s\n" "$count" "$vendor"
done

echo -e "\n${GRAY}Source: https://www.cisa.gov/known-exploited-vulnerabilities-catalog"
echo -e "Run weekly. Add vendor/product filter: bash check-cisa-kev.sh microsoft${NC}\n"
