# Phase 0: Baseline Security Verification

Walk through each section interactively with the user. Record PASS/FAIL/WARN for each check.

## 0.1 Patch Currency

Check every component against latest security patches:

1. Operating system — is it current? Is it still receiving security updates?
2. Web browsers — auto-update verified (not assumed)?
3. Business software — all applications current?
4. Runtime/framework versions — Node.js, Python, etc. current?
5. Database engine — current version with security patches?
6. Network equipment firmware — router, firewall, switches updated?

Cross-reference against known Mythos-disclosed CVEs:
- CVE-2026-4747 (FreeBSD NFS RCE, CVSS 8.8) — affects FreeBSD NFS
- OpenBSD TCP SACK (Errata 025) — affects OpenBSD
- FFmpeg H.264 sentinel collision — affects anything processing video
- Linux kernel CVE-2024-47711 chain — affects Linux servers
- Browser sandbox escapes — affects all major browsers
- TLS/AES-GCM/SSH weaknesses — affects everything using TLS

**CRITICAL gate:** Any system running unpatched with known CVEs = FAIL. Fix before proceeding.

## 0.2 MFA Verification

Check MFA is ENABLED AND ENFORCED (not just available) on:

1. Email (Gmail, Outlook, etc.) — this is #1 priority
2. Password manager
3. Banking and financial services
4. Cloud hosting (AWS, Vercel, Supabase, etc.)
5. Domain registrar
6. Code repository (GitHub, etc.)
7. Accounting software (QuickBooks, Xero, etc.)
8. VPN / remote access

**CRITICAL gate:** Email without MFA = FAIL. Banking without MFA = FAIL. Fix before proceeding.

## 0.3 Password and Credential Hygiene

1. Password manager deployed for all team members?
2. No shared passwords?
3. No password reuse across accounts?
4. All API keys rotated within 90 days?
5. All inactive user accounts disabled?
6. All former employee access revoked?
7. Check haveibeenpwned.com for all business email addresses

**CRITICAL gate:** No password manager = FAIL. Known compromised credentials unfixed = FAIL.

## 0.4 Backup and Recovery

1. Backups exist for all critical data?
2. At least one backup is air-gapped (physically disconnected)?
3. Backup restore tested within last 90 days?
4. Recovery Time Objective (RTO) documented?
5. Incident response plan documented?
6. IR plan accessible when email is down?
7. Contact list for IR (legal, insurance, IT, law enforcement) documented?

**CRITICAL gate:** No backups = FAIL. Untested backups = WARN (test within 7 days).

## 0.5 Network Basics

1. No RDP (port 3389) exposed to the internet?
2. No database ports exposed to the internet?
3. Guest Wi-Fi separated from business network?
4. Default passwords changed on all network equipment?
5. UPnP disabled on router?

**CRITICAL gate:** Exposed RDP = FAIL. Fix immediately.

## Completion Gate

Do NOT proceed to Phase 1 until ALL CRITICAL items pass. Present summary:

| Section | Status | Critical Items |
|---------|--------|---------------|
| 0.1 Patches | PASS/FAIL | |
| 0.2 MFA | PASS/FAIL | |
| 0.3 Credentials | PASS/FAIL | |
| 0.4 Backups | PASS/FAIL | |
| 0.5 Network | PASS/FAIL | |
