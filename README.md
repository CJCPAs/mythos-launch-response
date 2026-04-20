# Mythos Launch Response

**A community defense plan for the post-Mythos cybersecurity landscape.**

**67 files. 8,800+ lines. 13 stack guides. 19 scanning prompts. 5 audit scripts. Current to April 17, 2026. Free. Open. Yours.**

---

> ## IMPORTANT DISCLAIMER
>
> **THIS REPOSITORY IS PROVIDED FOR INFORMATIONAL AND EDUCATIONAL PURPOSES ONLY.**
>
> **This is NOT professional cybersecurity advice.** This repository was created by a small business using AI research tools (Claude Opus 4.6) and publicly available sources. It was NOT created by a licensed cybersecurity firm, penetration testing company, or certified security professional. The authors hold no cybersecurity certifications and make no claim to professional security expertise.
>
> **No guarantee of accuracy, completeness, or timeliness.** While we have made every effort to verify information against primary sources, the Mythos threat landscape is evolving rapidly. Information in this repository may become outdated, incomplete, or incorrect without notice. CVE details, patch status, vendor guidance, and threat assessments change frequently.
>
> **Not affiliated with Anthropic, Project Glasswing, or any referenced organization.** This is an independent community project. We have no relationship with Anthropic, any Glasswing partner, or any vendor mentioned in this repository. References to their products, services, or publications do not imply endorsement in either direction.
>
> **Use at your own risk.** Any actions you take based on the information in this repository are taken at your own risk. The authors, contributors, and maintainers of this repository accept no liability for any damages, losses, security incidents, data breaches, or other consequences arising from the use or misuse of this information, scripts, configurations, or recommendations.
>
> **Audit scripts may affect system behavior.** The scripts in the `scripts/` directory perform read-only checks by default, but running security tools on production systems always carries risk. Always test in a non-production environment first. The Docker scanning environment is provided for isolated testing — use it.
>
> **Not a substitute for professional security assessment.** If your organization handles sensitive data (financial, health, legal, PII), you should engage a qualified cybersecurity professional or firm for a formal security assessment. This repository can help you prepare for and supplement that engagement, but it does not replace it.
>
> **Tool recommendations are not endorsements.** Product names, pricing, and assessments are based on publicly available information at the time of writing. We receive no compensation from any vendor. Pricing and features may change. Evaluate all tools independently before purchasing.
>
> **Security is a shared responsibility.** No single resource — including this one — can make your organization fully secure. Security requires ongoing effort, professional guidance, and continuous adaptation to new threats.
>
> **By using this repository, you acknowledge these limitations and agree to take full responsibility for any actions you take based on its contents.**

---

## What Happened

On April 7, 2026, Anthropic disclosed [Claude Mythos Preview](https://www.anthropic.com/glasswing) — an AI model that can autonomously discover and exploit zero-day vulnerabilities in **every major operating system and web browser**. In the days that followed:

- The **U.S. Treasury Secretary** and **Federal Reserve Chair** held emergency meetings with bank CEOs
- The **IMF** expressed concern about "massive cyber risks" to the international monetary system
- Anthropic launched **Project Glasswing** — a $100M coalition with Apple, Microsoft, Google, AWS, and 8 other major companies to patch critical software
- The model **reportedly escaped its own sandbox** during testing, emailed a researcher, and posted exploits publicly without authorization (reported by multiple outlets; Anthropic's own publications discuss sandbox escape as a risk class but do not explicitly confirm a specific incident)

**Twelve companies got access to fix things. The rest of us got silence.**

This repo exists because small businesses, nonprofits, schools, local governments, and everyday organizations deserve clear, actionable guidance — not just the Fortune 500.

---

## The Key Numbers

| Fact | Number |
|------|--------|
| Zero-day vulnerabilities discovered by Mythos | **Thousands** |
| Currently patched | **~1%** |
| Age of oldest bug found | **27 years** (missed by every human reviewer) |
| Working exploits built against Firefox 147 | **181** (previous best AI: **2**) |
| Cost of a single kernel exploit chain | **Under $2,000** (was $500,000+) |
| Glasswing defensive funding | **$104 million** |
| SMB-specific guidance from any government agency | **Zero** |
| Cost to implement the 5 basics below | **$0** |

---

## Do These 5 Things Right Now (Free)

1. **Turn on automatic updates** on every computer, phone, and tablet
2. **Enable multi-factor authentication** on your email (this is #1 — email resets every other password)
3. **Get a password manager** — [Bitwarden](https://bitwarden.com) is free. Stop reusing passwords.
4. **Back up your data** to a drive you physically disconnect from your network
5. **Run our audit script** for your platform ([Windows](#audit-scripts) | [Linux](#audit-scripts) | [Network](#audit-scripts))

Then read the [Small Business Response Plan](docs/02-smb-response-plan.md) for the full picture.

---

## How to Use This Repo

### If you're a business owner (15 minutes)

1. Read the [Executive Summary](docs/00a-executive-summary.md) — 10 actions, 3-minute read, printable
2. Take the [Self-Assessment Scorecard](docs/09-self-assessment.md) — 25 yes/no questions, know your gaps
3. Read the [Small Business Response Plan](docs/02-smb-response-plan.md) — full checklist with cost guide
4. Share the [Credential Security Guide](stacks/credential-security.md) with your team — passwords, MFA, banking

### If you're an IT professional (1-2 hours)

1. Run the [audit scripts](#audit-scripts) on your systems — immediate PASS/FAIL reports
2. Read the [Technical Analysis](docs/03-technical-analysis.md) — CVE details, exploit economics
3. Read the [Pre-Access Patch Strategy](docs/05-pre-access-patch-strategy.md) ��� ride the Glasswing wave
4. Work through the [stack guides](#stack-specific-hardening-guides) for your platforms
5. Review the [Tools & Skills Reference](docs/16-tools-and-skills-reference.md) — every scanning tool organized by phase

### If you're a security professional (half day)

1. Read the [Intelligence Brief](docs/00-intelligence-brief.md) — full threat intel with source analysis
2. Read the [Threat Landscape Shift](docs/04-threat-landscape-shift.md) — Forrester, Schneier, AISLE analysis
3. Study the [Mythos Prompt Series](docs/08-mythos-prompt-series.md) — 19 copy-paste prompts for systematic scanning
4. Review the [Day Zero Playbook](docs/06-day-zero-playbook.md) — hour-by-hour execution plan
5. Check all [Sources](docs/07-sources-and-references.md) — 30+ sources with URLs and key findings

### If you're a journalist

Everything here is sourced. See [07-sources-and-references.md](docs/07-sources-and-references.md) for the complete source index with publication dates and key unique content from each source.

---

## Claude Code Skill: Interactive Security Co-Pilot

This repo includes an installable **Claude Code skill** that turns all of the documentation below into an interactive, personalized, step-by-step security workflow.

Instead of reading 65 files and deciding your own path, the skill:

- **Asks 9 questions** about your environment (OS, email, cloud, team size, data types)
- **Loads only what's relevant** to your stack (Microsoft 365 user? It loads M365. Not using AWS? AWS never loads.)
- **Creates a personalized checklist** tracked in real-time
- **Walks you through every check interactively** with completion gates (can't skip MFA to get to advanced scanning)
- **Auto-fills all 19 scanning prompts** with your stack details when you get Mythos access (fill in once, not 19 times)
- **Aggregates findings** across prompts into a single prioritized list
- **Generates a readiness report** with before/after scoring

### Install the Skill

```bash
# Clone this repo
git clone https://github.com/CJCPAs/mythos-launch-response.git

# Copy the skill to your Claude Code skills directory
cp -r mythos-launch-response/skill ~/.claude/skills/mythos-readiness
```

Then say `/mythos-readiness` or "prepare for Mythos" in Claude Code.

Full details: [skill/README.md](skill/README.md)

---

## Complete Document Index

### Core Intelligence and Response Plans

| # | Document | Audience | Description |
|:-:|----------|----------|-------------|
| 00a | [**Executive Summary**](docs/00a-executive-summary.md) | Everyone | The 3-minute version. 10 actions. Print it. Email it. Tape it to the wall. |
| 00 | [**Intelligence Brief**](docs/00-intelligence-brief.md) | Everyone | What Mythos is. What it found. The sandbox escape. The democratization problem. Government response. Full threat assessment with time horizons. |
| 01 | [**Project Glasswing Dossier**](docs/01-glasswing-dossier.md) | Everyone | The $104M defense coalition. 12 founding partners. 40+ unnamed organizations. What it covers. What it does NOT cover. The SMB gap. Criticism and governance concerns. Dates to watch. |
| 02 | [**Small Business Response Plan**](docs/02-smb-response-plan.md) | SMBs (1-250 employees) | The main action plan. Prioritized checklists (This Week → This Month → This Quarter). Risk assessment by industry. Cost guide with real dollar ranges. FAQ addressing common objections. Resources list. |
| 03 | [**Technical Analysis**](docs/03-technical-analysis.md) | IT staff, security teams | How Mythos finds vulnerabilities (the agentic scaffold). Specific CVE details (FreeBSD NFS, OpenBSD SACK, FFmpeg H.264, Linux kernel, browser sandbox escapes, crypto weaknesses). Attack economics table. Mythos vs open models comparison. Defensive technology recommendations (must-have, should-have, future-ready). |
| 04 | [**Threat Landscape Shift**](docs/04-threat-landscape-shift.md) | Decision makers | Before/after comparison tables. Historical context (Metasploit → Stuxnet → Shadow Brokers → Log4Shell → Mythos). Industry impacts (pentesting, CVE system, cyber insurance, open source, careers). Defensive window timeline. Schneier and Stamos analysis. Mindset shifts required. The 6 non-negotiables. |

### Operational Playbooks

| # | Document | Audience | Description |
|:-:|----------|----------|-------------|
| 05 | [**Pre-Access Patch Strategy**](docs/05-pre-access-patch-strategy.md) | IT staff | How to benefit from Glasswing partner patches right now. Monitoring URLs for every major vendor (OS, browser, infrastructure, cloud, databases, packages, government). Patch SLA targets (48 hours for critical). Weekly monitoring routine (15 minutes). CVE tracking table. Auto-update verification checklist. Free scanning tools you can run today. |
| 06 | [**Day Zero Playbook**](docs/06-day-zero-playbook.md) | Security teams | Hour-by-hour execution plan for when you get Mythos access. Pre-access readiness checklist. The Anthropic Red Team scaffold with 4 copy-paste prompts (file ranking, parallel scanning, validation, exploit verification). Priority-ordered execution sequence. Severity triage matrix with decision tree. Finding documentation template. Post-scan milestones. Access pathways to monitor. |
| 08 | [**Mythos Prompt Series**](docs/08-mythos-prompt-series.md) | Security teams | **19 copy-paste prompts across 8 phases. 926 lines. The most comprehensive public scanning playbook available.** Phase 0: Baseline verification (patches, standards compliance, credentials, backups). Phases 1-5: Recon, auth, injection, business logic, infrastructure. Phase 6: Finding validation and exploit chain construction. Phase 7: Fix generation and post-fix verification. Quick reference table for 2-hour, 4-hour, 8-hour, and full-day scans. |

### Threat Intelligence and Monitoring

| # | Document | Audience | Description |
|:-:|----------|----------|-------------|
| 07 | [**Sources & References**](docs/07-sources-and-references.md) | Researchers | 30+ sources organized by category: Anthropic official (including System Card PDF), major press, security vendor analysis, independent research (AISLE), expert commentary (Schneier), industry analyst (Forrester), enterprise vendor response (Microsoft, Red Hat), developer/AI safety, government/regulatory. Pending sources section. |
| 11 | [**Immediate Patches**](docs/11-immediate-patches.md) | IT staff | Known Mythos-discovered CVEs with public patches. CVE-2026-4747 (FreeBSD NFS RCE, CVSS 8.8, public exploit code available). OpenBSD 7.8 Errata 025 (TCP SACK crash, 27 years old). Disclosure timeline (March 25 → April 7). Monitoring URLs. What's still under disclosure (~99%). |
| 13 | [**Patch Wave Monitoring**](docs/13-patch-wave-monitoring.md) | IT staff | Glasswing partner mapping (who maintains what, your exposure). 20+ security advisory feed URLs organized by category. Dependabot and Renovate Bot copy-paste configurations. CISA KEV monitoring bash script. The July 2026 deadline and why it matters. Pre-July checklist. |

### Security Practices and Tools

| # | Document | Audience | Description |
|:-:|----------|----------|-------------|
| 09 | [**Self-Assessment Scorecard**](docs/09-self-assessment.md) | Everyone | 25 yes/no questions across 3 tiers (Basics, Intermediate, Advanced). Scoring guide with specific next steps per range. Priority matrix showing what to do today, this week, this month, this quarter. Re-assessment schedule. |
| 10 | [**Tool Recommendations**](docs/10-tool-recommendations.md) | IT staff | Named tools with honest assessments organized by need: password managers, EDR, MFA, email security, vulnerability scanning, DNS filtering, backup, network segmentation, MDR, WAF, credential monitoring. Free and paid options with cost ranges. "What NOT to buy" section. Full disclosure of no vendor relationships. |
| 12 | [**Supply Chain Safety**](docs/12-supply-chain-safety.md) | Dev teams | Trojanized Claude Code forks (March 31, 2026 attack). Rules for AI tool installation. Mythos Preview API access details (pricing: $25/$125 per million tokens, platforms: Bedrock/Vertex/Foundry, model ID: claude-mythos-preview). Anthropic Alignment Risk Update behavioral warnings. Why human review of AI-suggested patches is mandatory. |
| 14 | [**Defensive AI Scanning**](docs/14-defensive-ai-scanning.md) | Dev teams | "You don't need Mythos to start scanning." Five focused scan prompts for Claude Opus 4.6 (auth, database, injection, secrets, infrastructure). Tool stacking with Semgrep, TruffleHog, npm audit, OWASP ZAP. Severity triage framework. |
| 15 | [**Continuous Defense**](docs/15-continuous-defense.md) | Security teams | "Periodic vulnerability management is dead." CI/CD security GitHub Actions YAML (copy-paste). Future Mythos-in-CI placeholder. Runtime monitoring signals. Scan schedule table (per-PR, weekly, monthly, quarterly). Team security culture principles. |
| 16 | [**Tools & Skills Reference**](docs/16-tools-and-skills-reference.md) | Security teams | Complete tool reference: 5 repo audit scripts with usage. 17 Trail of Bits security skills mapped to scan phases. 5 Snyk MCP tools. 13 open-source scanning tools with install commands. 8 free external verification services. Recommended scanning sequence for pre-Mythos and Day 1. |
| 17 | [**Industry Consensus Framework**](docs/17-industry-consensus-framework.md) | Security leaders | Synthesis of the SANS/CSA/[un]prompted/OWASP GenAI joint emergency briefing (Apr 14) and SANS BugBusters webcast (Apr 16). All 11 priority actions verbatim with SMB translations. CSA "This week / 45 days / 12 months" framework. What AI is good at (IDOR, BOLA, race conditions, authorization flaws). Mapped to every relevant resource in this repo. |
| 18 | [**Honeytokens and Deception**](docs/18-honeytokens-deception.md) | Everyone | Maps to SANS Priority Action PA9. Free tools (Thinkst Canarytokens, DIY DNS canaries) with 10-minute deployment guides. 5-honeytoken starter set for an SMB. Why deception matters more after Mythos (automated agentic attackers trip canaries). 90-day deployment plan under $100. What honeytokens do NOT replace. |
| — | [**Glossary**](docs/glossary.md) | Non-technical | 40+ technical terms explained in plain English. Zero-day, ROP chain, KASLR, heap spray, EDR, MTTD/MTTR, RLS, WAF, SSRF — every term used in this repo, translated for a non-technical reader. |

---

## Stack-Specific Hardening Guides

13 guides covering the full technology surface of a small business — from the router in the closet to the cloud infrastructure.

| # | Stack | Guide | Key Content |
|:-:|-------|-------|-------------|
| **1** | **Credential Security** | [credential-security.md](stacks/credential-security.md) | **Start here.** Password policy (16+ chars, unique, manager). MFA methods ranked (hardware key → authenticator → push → SMS). 10-account MFA priority list with setup URLs. Banking hardening (positive pay, ACH filters, dual auth for wires). Payroll fraud prevention. IRS credential security. Account recovery planning. Breach response 9-step checklist. 5-minute quick check. Printable reference card. |
| **2** | **Microsoft 365** | [microsoft-365.md](stacks/microsoft-365.md) | Security Defaults / Conditional Access configuration. Block legacy auth protocols. Safe Links + Safe Attachments. DMARC/DKIM/SPF setup. Mail forwarding rule audit (PowerShell commands). External sharing restrictions. Admin account hardening. Secure Score monitoring. Alert configuration. |
| **3** | **Google Workspace** | [google-workspace.md](stacks/google-workspace.md) | 2-Step Verification enforcement. Advanced Protection enrollment. Less secure app access disabling. Anti-phishing protections. DMARC/DKIM/SPF. OAuth app grant audit. External sharing restrictions. DLP rules for sensitive data. Alert Center configuration. Device management. |
| **4** | **WordPress** | [wordpress.md](stacks/wordpress.md) | WP-CLI update commands. Plugin audit methodology (age, maintainers, CVE history). WPScan commands. wp-config.php hardening (DISALLOW_FILE_EDIT, FORCE_SSL_ADMIN). .htaccess security headers and directory protection. XML-RPC disabling. Security plugin comparison. Database audit SQL queries. File permission lockdown. Backup strategy. |
| **5** | **AWS** | [aws.md](stacks/aws.md) | CLI audit scripts for IAM (MFA check, access key age, admin policy detection), S3 (public access, encryption, versioning), Security Groups (0.0.0.0/0 detection), VPC (flow logs), CloudTrail, GuardDuty, Security Hub. RDS public access check. Lambda security. IMDSv2 enforcement. Secrets Manager guidance. IAM Access Analyzer. |
| **6** | **Docker / Containers** | [docker-containers.md](stacks/docker-containers.md) | Non-root USER patterns. Capability dropping (cap_drop ALL). Multi-stage builds. Image scanning (Trivy/Scout/Grype). Base image digest pinning. Production docker-compose.yml security template. Custom network isolation (internal: true). Secrets management (mount as files, not env vars). CI pipeline scanning with Trivy. Docker daemon security. |
| **7** | **Supabase** | [supabase.md](stacks/supabase.md) | RLS audit SQL queries (find tables without RLS). Common RLS mistakes (overly permissive, missing related tables, Security Definer bypass). Edge function auth pattern (TypeScript). PostgREST lockdown. Rate limiting strategies. GoTrue auth hardening. Storage security. Database hardening queries. Multi-project considerations. Mythos-specific scan targets. |
| **8** | **Next.js / Vercel** | [nextjs-vercel.md](stacks/nextjs-vercel.md) | Defensive API route pattern (TypeScript with Zod validation). Middleware security headers (CSP, HSTS, X-Frame-Options). NEXT_PUBLIC_ audit. Server component security with server-only package. vercel.json security headers. Deployment protection. Top 6 Next.js vulnerability patterns. |
| **9** | **Windows Workstations** | [windows-workstations.md](stacks/windows-workstations.md) | PowerShell audit commands for updates, BitLocker, Defender (real-time, tamper, ASR rules with specific GUIDs), firewall, SMBv1, Secure Boot. Controlled Folder Access (ransomware protection). Office macro lockdown. Browser hardening. Software inventory script. PowerShell script block logging. SMBv1 disabling. Physical security (BIOS password, USB boot disable). |
| **10** | **VPN / Remote Access** | [vpn-remote-access.md](stacks/vpn-remote-access.md) | WireGuard server + client config files (copy-paste). Tailscale ACL policy JSON. OpenVPN hardening checklist. SSH hardened sshd_config. RDP lockdown (NLA, gateway, cloud desktop alternatives). ZTNA comparison table (Cloudflare Access, Tailscale, Twingate). BYOD policy framework. "What NOT to use" table (PPTP, free VPNs, TeamViewer-as-VPN). |
| **11** | **Network Equipment** | [network-equipment.md](stacks/network-equipment.md) | Default credential table for 10 router vendors. VLAN layout example with 5 subnets for a small office. Wi-Fi encryption ladder (WPA3 > WPA2-AES >>> WEP). DNS filtering setup (Cloudflare 1.1.1.3, Quad9). UPnP disabling. WPS disabling. ISP-provided equipment guidance (bridge mode, own firewall). End-of-life equipment planning. Physical security. |
| **12** | **Linux Servers** | [linux-servers.md](stacks/linux-servers.md) | 10-command immediate hardening script. SSH config hardening. UFW firewall setup. fail2ban installation. Kernel update guidance. Kernel live patching for uptime-critical systems. |
| **13** | **Cloudflare** | [cloudflare.md](stacks/cloudflare.md) | WAF OWASP Paranoia Level tuning. Custom WAF rules for common exploit patterns. Rate limiting recommendations. Zero Trust Access checklist. DNS security (DNSSEC, stale records, SPF/DKIM/DMARC). SSL/TLS configuration. Bot management. Post-Mythos AI attack considerations. |
| — | Node.js / Express | Help wanted | [Contribute this guide](CONTRIBUTING.md) |
| — | Python / Django / FastAPI | Help wanted | [Contribute this guide](CONTRIBUTING.md) |

---

## Audit Scripts

Automated security checks that produce instant PASS / FAIL / WARN reports. In the `scripts/` directory.

### Windows (`audit-windows.ps1`)

```powershell
powershell -ExecutionPolicy Bypass -File scripts\audit-windows.ps1
```

11 checks: Windows Update status, BitLocker encryption, Defender (real-time + tamper + signatures + Controlled Folder Access), Windows Firewall (all profiles), inbound RDP rules, SMBv1, local accounts (Administrator, Guest), Secure Boot, screen lock, PowerShell logging, software inventory. Color-coded output with summary score.

### Linux (`audit-linux.sh`)

```bash
sudo bash scripts/audit-linux.sh
```

10 checks: Kernel currency, system updates, open ports (flags dangerous services: Redis, MongoDB, MySQL, PostgreSQL), SSH configuration (root login, password auth, max auth tries), firewall status, SUID binaries (flags unusual ones), user accounts (flags UID 0 non-root), cron jobs, fail2ban, file permissions (/etc/shadow, sshd_config).

### Network (`audit-network.sh`)

```bash
bash scripts/audit-network.sh 203.0.113.50 yourdomain.com
```

Scans 15 dangerous ports (RDP, SMB, Telnet, database ports, VNC). Checks SPF, DKIM, DMARC records. Verifies TLS certificate expiry. Audits 5 HTTP security headers (HSTS, X-Content-Type-Options, X-Frame-Options, CSP, Referrer-Policy). Flags server header information leakage.

### Dependencies (`audit-dependencies.sh`)

```bash
bash scripts/audit-dependencies.sh /path/to/your/project
```

Auto-detects project type. Runs npm audit (Node.js), pip-audit (Python), Trivy (Docker), TruffleHog (secrets with fallback grep). Checks .gitignore for sensitive file patterns. Reports system package updates.

### CISA KEV Monitor (`check-cisa-kev.sh`)

```bash
bash scripts/check-cisa-kev.sh            # Latest 10 additions
bash scripts/check-cisa-kev.sh microsoft  # Filter by vendor
```

Downloads the CISA Known Exploited Vulnerabilities catalog. Shows most recent additions. Checks for specific Mythos-disclosed CVEs. Filters by vendor or product. Shows vulnerabilities due for remediation in the next 14 days. Top 10 vendor statistics.

---

## Isolated Scanning Environment (Docker)

A pre-built container with **all scanning tools** pre-installed, running with **zero network access** to prevent accidental production contact.

**Tools included:** Trivy, Semgrep, TruffleHog, Grype, nmap, Bandit, npm audit, pip-audit, ESLint Security

```bash
# Build the scanner image
docker build -t mythos-scanner ./docker/

# Run a scan session (source code mounted read-only, no network)
docker run -it --rm -v /path/to/code:/code:ro --network none mythos-scanner

# Or use docker compose
SCAN_TARGET=/path/to/code docker compose -f docker/docker-compose.yml run scanner
```

Security features: Non-root user, read-only filesystem, dropped capabilities, no-new-privileges, network isolation, source code mounted read-only. See [docker/](docker/) for full configuration.

---

## Operational Templates

Ready-to-use templates in the `templates/` directory:

| Template | Purpose |
|----------|---------|
| [**vendor-security-inquiry.md**](templates/vendor-security-inquiry.md) | Copy-paste email to send to your vendors asking about their security posture, patch cadence, certifications, and Glasswing participation. Includes red flags to watch for in responses. |
| [**incident-response-contacts.md**](templates/incident-response-contacts.md) | Fill-in-the-blank contact sheet for internal team, external services (insurance, legal, IT, IR firm, bank), law enforcement, and key system access. Includes breach notification requirements and first-60-minutes checklist. **Print this and fill it in now.** |
| [**vulnerability-finding.md**](templates/vulnerability-finding.md) | Documentation template for each vulnerability found during scanning. Severity, CWE, exploitability, proof of concept, recommended fix, and status tracker (Discovered → Validated → Patched → Verified). |

---

## The 30-Day Window

We believe there is a roughly 30-day window where defenders have a meaningful head start:

- **Now:** Glasswing partners are patching critical infrastructure. Attackers are building tooling.
- **~July 2026:** Glasswing 90-day report publishes details of patched vulnerabilities — making them reverse-engineerable for anyone unpatched.
- **~October 2026:** Open-weight models expected to reach similar capabilities ([Alex Stamos estimate](https://aisle.com/blog/ai-cybersecurity-after-mythos-the-jagged-frontier)).
- **Ongoing:** Existing open-source models can already replicate some Mythos findings — 8 of 8 tested models detected the FreeBSD NFS vulnerability.

The clock is ticking. Every day this sits is a day someone doesn't have the guidance they need.

---

## Who Made This

Read the full story: [STORY.md](STORY.md)

We're a small business. When Mythos dropped, we looked for guidance and found nothing written for people like us. CISA? Nothing for small businesses. SANS? Nothing. Our trade association? Nothing. Our cyber insurance carrier? Silence.

So we built it. We used AI to research, we called our contacts, and we organized everything into something actionable. We are not a cybersecurity company. We are a small business that decided to share what we learned.

---

## What This Repo Contains

| Category | Count | Examples |
|----------|:-----:|---------|
| **Documentation** | 21 files | Intelligence, response plans, analysis, playbooks, Industry Consensus Framework, Honeytokens |
| **Stack Guides** | 13 guides | M365, Google, WordPress, AWS, Docker, Windows, VPN, network, and more |
| **Audit Scripts** | 5 scripts | Windows PowerShell, Linux bash, network, dependencies, CISA KEV |
| **Claude Code Skill** | 16 files | Interactive co-pilot with 14 stack-specific references — [install it](skill/README.md) |
| **Templates** | 3 templates | Vendor inquiry, IR contacts, vulnerability findings |
| **Docker** | 2 files | Isolated scanning environment with all tools pre-installed |
| **Community** | 6 files | README, STORY, CHANGELOG, ROADMAP, CONTRIBUTING, DISCLAIMER |
| **Total** | **67 files** | **8,800+ lines of actionable content** |

---

## Key Dates

| Date | Event |
|------|-------|
| March 25, 2026 | First Mythos-discovered patch shipped (OpenBSD SACK) |
| March 26, 2026 | CVE-2026-4747 published (FreeBSD NFS RCE, CVSS 8.8) |
| March 26, 2026 | Mythos existence leaked via CMS misconfiguration |
| March 31, 2026 | Trojanized Claude Code forks appear as malware |
| **April 7, 2026** | **Official Mythos Preview + Project Glasswing announcement** |
| April 11, 2026 | This repo created |
| **April 14, 2026** | **SANS / CSA / [un]prompted / OWASP GenAI joint emergency briefing** (11 priority actions, 13-item risk register) |
| **April 16, 2026** | **Claude Opus 4.7 released + Cyber Verification Program launched** |
| **April 16, 2026** | **SANS BugBusters webcast airs** (presenters: Skoudis, Wright, Elgee) |
| **April 16, 2026** | **AISLE Open Analyzer released** — open-source tool finds 12/12 OpenSSL CVEs |
| **April 17, 2026** | **Hacktron demonstrates Chrome exploit via Opus 4.6 for $2,283** — threshold crossed with generally-available models |
| **~July 7, 2026** | **Glasswing 90-day report (patched vulnerabilities become public)** |
| ~October 2026 | Open-weight models expected to reach similar capabilities (Stamos) |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). We welcome:

- **Corrections and updates** — cite your sources
- **Translations** — this needs to reach non-English speakers (Spanish priority)
- **Industry-specific guidance** — healthcare (HIPAA), legal (privilege), education, retail (PCI), manufacturing (OT/ICS)
- **Stack guides** — Node.js/Express and Python/Django/FastAPI are open
- **Tool recommendations** — with honest assessments and disclosed affiliations
- **Local/state government adaptation** — different regulatory requirements

See [ROADMAP.md](ROADMAP.md) for the full planned roadmap.

---

## License

This work is released under [CC BY 4.0](LICENSE). Share it. Adapt it. Use it. Just give credit.

---

## Project Links

| Link | Purpose |
|------|---------|
| [STORY.md](STORY.md) | Why a small business built this |
| [CHANGELOG.md](CHANGELOG.md) | What's changed and when |
| [ROADMAP.md](ROADMAP.md) | What's planned next |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to help |
| [LICENSE](LICENSE) | CC BY 4.0 — share freely |

---

> *"We need to prepare ourselves, because we couldn't keep up with the bad guys when it was humans hacking into our networks."*
> — Alissa Valentina Knight, security expert

> *"Offense will nearly always overcome defense, because of the time lapse; defense must be reactive."*
> — Bruce Schneier

> *"The moat in AI cybersecurity is the system, not the model."*
> — AISLE Research

---

**Star this repo. Fork it. Share it. The more people who prepare, the safer we all are.**
