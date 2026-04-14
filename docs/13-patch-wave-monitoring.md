# Phase 2: Patch Wave Monitoring

**Timeline: Ongoing from now through July 2026 and beyond.**

Glasswing partners are finding and patching vulnerabilities right now. Every patch they ship protects you - but only if you apply it.

---

## 2.1 The Glasswing Partners and What They're Patching

| Partner | What They Maintain | Your Exposure |
|---------|-------------------|---------------|
| **Microsoft** | Windows, Edge, .NET, Azure, VS Code | Dev tools, any Windows systems |
| **Apple** | macOS, Safari, iOS, WebKit | Dev machines, mobile apps |
| **Google** | Chrome, V8, Android, Linux kernel contributions | Node.js (V8 engine), Chrome, Chromium-based tools |
| **Amazon (AWS)** | Linux kernel, AWS services, Firecracker | Any AWS-hosted infrastructure, Lambda, ECS |
| **Linux Foundation** | Linux kernel, OpenSSF, critical open-source | Virtually everything server-side |
| **Cisco** | Network infrastructure, IOS | Firewalls, routers, network gear |
| **CrowdStrike** | Endpoint detection, threat intelligence | If you use their products |
| **Palo Alto Networks** | Firewalls, Prisma, Cortex | Network security appliances |
| **Broadcom** | VMware, Symantec, semiconductor firmware | Virtualization, firmware |
| **NVIDIA** | GPU drivers, CUDA, AI frameworks | GPU compute, AI inference |
| **JPMorganChase** | Internal financial systems | Industry security standards |

Plus 40+ additional organizations maintaining critical infrastructure.

---

## 2.2 Security Advisory Feeds to Monitor

Subscribe to ALL of these. Set up email alerts or RSS feeds.

### Operating Systems
- [Linux kernel security](https://lore.kernel.org/linux-security/)
- [Ubuntu Security Notices](https://ubuntu.com/security/notices)
- [Debian Security Advisories](https://www.debian.org/security/)
- [OpenBSD Errata](https://www.openbsd.org/errata.html)
- [FreeBSD Security Advisories](https://www.freebsd.org/security/advisories/)

### Browsers and Runtimes
- [Chrome Releases Blog](https://chromereleases.googleblog.com/)
- [Mozilla Security Advisories](https://www.mozilla.org/en-US/security/advisories/)
- [Node.js Security Releases](https://nodejs.org/en/blog/vulnerability)
- [Deno Security](https://github.com/denoland/deno/security/advisories)

### Cloud and Infrastructure
- [AWS Security Bulletins](https://aws.amazon.com/security/security-bulletins/)
- [Vercel Changelog](https://vercel.com/changelog)
- [Cloudflare Security Advisories](https://www.cloudflare.com/trust-hub/security-advisories/)
- [Supabase Status & Security](https://status.supabase.com/)

### Databases
- [PostgreSQL Security](https://www.postgresql.org/support/security/)
- [Redis Security](https://redis.io/docs/management/security/)

### Package Ecosystems
- [npm Security Advisories](https://github.com/advisories?query=ecosystem%3Anpm)
- [GitHub Advisory Database](https://github.com/advisories)
- [CISA Known Exploited Vulnerabilities](https://www.cisa.gov/known-exploited-vulnerabilities-catalog)

---

## 2.3 Automated Monitoring Setup

### GitHub Dependabot (if not already enabled)

Create `.github/dependabot.yml` in every repo:

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "daily"
    open-pull-requests-limit: 20
    labels:
      - "security"
      - "dependencies"
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
```

### Renovate Bot (alternative to Dependabot, more configurable)

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["config:recommended", ":automergeMinor"],
  "vulnerabilityAlerts": {
    "enabled": true,
    "labels": ["security"]
  },
  "schedule": ["every weekday"]
}
```

### CISA KEV Feed Monitoring Script

```bash
#!/bin/bash
# Download the latest Known Exploited Vulnerabilities catalog
curl -s https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json \
  | jq '.vulnerabilities | sort_by(.dateAdded) | reverse | .[0:10]'
```

---

## 2.4 The July 2026 Deadline

Anthropic will publish a 90-day Glasswing report around July 7, 2026. This report will disclose:
- Which vulnerabilities were found and patched
- Technical details of fixed issues
- Recommendations for the industry

**Why this is a hard deadline:** Once vulnerability details are public, adversaries can reverse-engineer exploits for any unpatched systems. Everything in your stack must be current BEFORE this report drops.

### Pre-July Checklist

- [ ] All OS patches current across all servers
- [ ] All npm/package dependencies updated
- [ ] All database engines updated
- [ ] All container base images rebuilt from latest
- [ ] Cloudflare/CDN managed rulesets on auto-update
- [ ] Automated patching pipeline tested and working

---

**Next:** [Phase 3 - Defensive AI Scanning](./03-defensive-ai-scanning.md)
