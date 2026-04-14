# Pre-Access Patch Strategy: Riding the Glasswing Wave

**Date:** April 11, 2026
**Audience:** IT teams at organizations without direct Mythos access

---

## The Logic

You don't have Mythos. But 12 founding partners + 40+ organizations DO. Every vulnerability they find flows downstream as vendor patches — OS updates, browser updates, firmware updates, security product updates.

**Every patch they push is Mythos intelligence you receive for free. You just have to consume it fast.**

---

## 1. What to Monitor

### Operating Systems

| Vendor | What to Monitor | URL |
|--------|----------------|-----|
| **Microsoft** | MSRC Blog, Patch Tuesday + out-of-band releases | https://www.microsoft.com/en-us/msrc |
| **Apple** | Security releases | https://support.apple.com/en-us/100100 |
| **Linux** | Kernel security advisories, distro updates | https://kernel.org |
| **Google** | Android security bulletins | https://source.android.com/docs/security/bulletin |

### Browsers

| Browser | Action |
|---------|--------|
| **Chrome** | Verify auto-update enabled. Watch [Chrome Releases blog](https://chromereleases.googleblog.com/) |
| **Firefox** | Verify auto-update enabled. Watch [Mozilla Security Advisories](https://www.mozilla.org/en-US/security/advisories/) |
| **Edge** | Verify auto-update enabled. Follows Chromium + Microsoft patches |
| **Safari** | Included in Apple security releases |

Browser sandbox escapes are among Mythos's confirmed findings. Browser patches in the coming months may address Mythos-discovered vulnerabilities even if not explicitly attributed.

### Infrastructure

| Vendor | Monitor |
|--------|---------|
| **Cisco** | https://sec.cloudapps.cisco.com/security/center/publicationListing.x |
| **Palo Alto Networks** | https://security.paloaltonetworks.com |
| **Intel** | https://www.intel.com/content/www/us/en/security-center/default.html |
| **Broadcom** | Broadcom Security Advisories |
| **NVIDIA** | NVIDIA Security Bulletins |

### Government

| Source | URL | What to Watch |
|--------|-----|---------------|
| **CISA KEV** | https://www.cisa.gov/known-exploited-vulnerabilities-catalog | New entries — actively exploited vulnerabilities |
| **CISA Advisories** | https://www.cisa.gov/advisories | Government guidance updates |
| **NVD** | https://nvd.nist.gov | New CVEs, especially any attributed to Mythos/Glasswing |

---

## 2. Patch SLA Targets

The old 30-90 day patch cycle is no longer viable. New targets:

| Severity | Target | Rationale |
|----------|--------|-----------|
| **Critical** (internet-facing, RCE) | **48 hours** | N-day exploits now develop in hours |
| **High** (privilege escalation, data exposure) | **7 days** | Active exploitation likely within weeks |
| **Medium** (local access required) | **14 days** | Lower immediacy but still accelerated |
| **Low** (theoretical) | **30 days** | Next maintenance window |

---

## 3. Weekly Monitoring Routine (15 minutes)

Every Monday:

- [ ] Check CISA KEV catalog for new entries
- [ ] Check your OS vendor's security advisories
- [ ] Verify auto-update is working on all systems (check a sample)
- [ ] Review any security vendor threat intelligence updates
- [ ] Check NVD for new CVEs in software you run

Monthly:

- [ ] Full patch compliance audit
- [ ] Check Anthropic blog for Glasswing updates
- [ ] Check Cyber Verification Program status
- [ ] Review vendor patch cadence (are your vendors keeping up?)

---

## 4. CVE Tracking Table

As Mythos-discovered CVEs are published, track whether they affect you:

| CVE | Vendor | Software | Affects Us? | Patched? | Date |
|-----|--------|----------|:-----------:|:--------:|------|
| CVE-2026-4747 | FreeBSD | NFS | Check | | |
| (pending) | OpenBSD | TCP SACK | Check | | |
| (pending) | FFmpeg | H.264 codec | Likely (via media apps) | | |
| (pending) | Multiple | Browsers | Yes | | |
| (pending) | Linux | Kernel | Check servers | | |
| (pending) | Multiple | TLS/AES/SSH | Yes (everything uses TLS) | | |

---

## 5. Auto-Update Verification Checklist

Don't assume auto-update is working. Verify:

- [ ] **Windows Update:** Settings > Update & Security > Check status
- [ ] **macOS:** System Preferences > Software Update > Verify enabled
- [ ] **Linux servers:** Package manager auto-update configured (unattended-upgrades, dnf-automatic, etc.)
- [ ] **Chrome:** chrome://settings/help — should show "Chrome is up to date"
- [ ] **Firefox:** about:preferences > General > Firefox Updates > "Automatically install updates"
- [ ] **Router/firewall:** Check firmware version against vendor's latest
- [ ] **Business applications:** Confirm each vendor's update mechanism is active

---

## 6. What You Can Do Right Now (Without Mythos)

| Tool | What It Does | Cost |
|------|-------------|------|
| **Qualys FreeScan** | External vulnerability scan | Free (limited) |
| **OpenVAS / Greenbone** | Network vulnerability scanner | Free / open source |
| **OWASP ZAP** | Web application scanner | Free / open source |
| **Snyk** | Dependency and code scanning | Free tier available |
| **ClamAV** | Open source antivirus | Free |
| **Have I Been Pwned** | Credential breach checking | Free |

These don't have Mythos-class capability, but they catch the low-hanging fruit that attackers exploit first.

---

*The best defense against Mythos-class threats today is being fully patched against everything already known. The basics still matter — they matter more than ever.*
