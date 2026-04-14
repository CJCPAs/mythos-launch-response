# Immediate Patches: Known Mythos-Discovered CVEs

**These vulnerabilities have been publicly disclosed and have patches or exploit code available NOW.**

---

## CVE-2026-4747 — FreeBSD NFS Remote Code Execution

| Field | Value |
|-------|-------|
| **What** | RPCSEC_GSS stack buffer overflow in FreeBSD's NFS server |
| **Impact** | Remote code execution granting unauthenticated root access |
| **CVSS** | 8.8 HIGH (scored by CISA-ADP) |
| **Exploit code** | **PUBLIC.** A working `exploit.py` exists in a public GitHub repo referenced by NVD |
| **Source** | https://nvd.nist.gov/vuln/detail/CVE-2026-4747 |
| **Action** | **Patch immediately** if running FreeBSD or any NFS services on BSD-derived systems |

**Note on exposure:** Cloudflare's edge infrastructure runs on BSD-derived systems. If you use Cloudflare, verify your managed rulesets are current — Cloudflare is a Glasswing partner and should be patching, but verify.

---

## OpenBSD 7.8 Errata 025 — TCP SACK Kernel Crash

| Field | Value |
|-------|-------|
| **What** | TCP packets with invalid SACK options crash the kernel remotely |
| **Impact** | Remote denial of service — crash any OpenBSD machine by connecting to it |
| **Age** | 27 years undetected |
| **Patch** | https://ftp.openbsd.org/pub/OpenBSD/patches/7.8/common/025_sack.patch.sig |
| **Code changes** | In `tcp_input.c` |
| **Action** | **Patch immediately** if running OpenBSD (common in firewalls, routers, critical infrastructure) |

---

## What's Still Under Disclosure

These are the only two publicly confirmed Mythos-discovered vulnerabilities as of April 11, 2026. **Over 99% of findings remain in responsible disclosure queues.** Expect a wave of new CVEs through July 2026.

### Track New Disclosures

| Source | URL |
|--------|-----|
| NVD | https://nvd.nist.gov/ |
| CISA KEV | https://www.cisa.gov/known-exploited-vulnerabilities-catalog |
| OpenBSD Errata | https://www.openbsd.org/errata.html |
| FreeBSD Advisories | https://www.freebsd.org/security/advisories/ |

---

## Key Dates

| Date | Event |
|------|-------|
| March 25, 2026 | OpenBSD errata patch for SACK crash (first confirmed Mythos-discovered fix) |
| March 26, 2026 | CVE-2026-4747 published (FreeBSD NFS RCE, CVSS 8.8) |
| March 26, 2026 | Mythos existence leaked via CMS misconfiguration (~3,000 Anthropic assets exposed) |
| March 31, 2026 | Trojanized Claude Code forks appear as malware lures |
| April 7, 2026 | Official Mythos Preview + Project Glasswing announcement |
| ~July 7, 2026 | Glasswing 90-day report (patched vulnerabilities become public knowledge) |
| ~October 2026 | Open-weight models expected to reach similar capabilities (Stamos estimate) |

---

*This document will be updated as new CVEs are disclosed. Watch this file for changes.*
