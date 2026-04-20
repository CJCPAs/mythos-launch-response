# Honeytokens and Deception

**Date:** April 17, 2026
**Audience:** SMBs, IT teams, security leaders
**Maps to:** SANS/CSA Priority Action PA9 — Build a Deception Capability (next 90 days)

---

## The Core Idea in One Sentence

**A honeytoken is bait that has no legitimate reason to be touched — so if anyone touches it, you know something is wrong.**

Unlike detection systems that try to distinguish attacker behavior from normal behavior (hard), honeytokens work because a real user has zero reason to click a file called `passwords_backup.kdbx` they've never seen before, or log into an AWS account they don't know exists. Any interaction is, by definition, malicious or mistaken.

In the post-Mythos landscape, honeytokens matter more than before. AI-assisted attackers move at machine speed and often operate via automated agents — which scan, enumerate, and exfiltrate indiscriminately. Machine-speed attackers are much more likely to trip deception bait than careful human attackers.

---

## What a Good Honeytoken Program Looks Like

| Layer | Example Bait | If Tripped, It Means |
|-------|-------------|----------------------|
| **File system** | `customer_database_backup.csv` on a shared drive | Someone is browsing shares they shouldn't |
| **Cloud storage** | A canary AWS access key in `~/.aws/credentials` | Credential theft on a developer workstation |
| **Directory/AD** | A fake "Domain Admin" account that no one ever logs into | Domain enumeration and credential-attack attempts |
| **Email** | A fake internal contact list including bait addresses | Email system compromise or data exfiltration |
| **Code repos** | A committed-then-quickly-deleted API key (rotated before commit) | Repo cloning and secret-scanning by attackers |
| **Database** | A row with fake PII tied to a specific identifier | Data-exfiltration queries |
| **Web app** | A hidden admin URL that returns a canary | Attacker reconnaissance |

The test of a good honeytoken: **would a normal user, or a normal internal script, ever touch this?** If yes, it's not a honeytoken — it's a false-positive factory.

---

## Free Tools to Start Today

### Thinkst Canarytokens (Free Tier)

**URL:** https://www.canarytokens.org

The easiest on-ramp. Free. Hosted by Thinkst Labs (the people who built Canary). No signup required.

Token types it generates:
- DNS canaries (alerts when a specific DNS name is looked up)
- AWS API keys (alerts when the key is used anywhere)
- Microsoft Word / Excel / PDF docs (alerts when opened)
- Web bug URLs (alerts when visited)
- MySQL / SQL Server dump files (alerts when imported)
- Slow redirect URLs
- Cloned website alerts
- Kubernetes config
- Azure login certificates

**Setup time:** ~10 minutes per token. You get an email or webhook alert when tripped.

### Thinkst Canary (Paid — for organizations that can spend)

**URL:** https://canary.tools

A physical or virtual appliance that impersonates a whole fake server (Windows file server, Linux SSH, router, network share). Attackers scanning your network find it first and trip alerts. ~$7,500/year minimum. Worth it for organizations with real sensitive data.

### DNS Canary via Your Own Domain (Free, DIY)

If you own a domain, you can build DIY DNS canaries:
1. Create a subdomain like `finance-backups.[yourdomain].com`
2. Point it at a server that logs any DNS lookup
3. Any lookup = someone is probing or has enumerated your DNS

---

## Starter Honeytoken Deployment (for an SMB)

You can deploy a meaningful starter set in an afternoon. In priority order:

### 1. Credential honeytoken in your password manager (10 minutes)
Create a fake banking entry named something like "First National — Ops Account" in Bitwarden/1Password. If anyone ever accesses it, they've compromised your password manager. Set up an alert on the vault entry.

### 2. Canary AWS key on your bookkeeper's workstation (15 minutes)
Generate a Canarytokens AWS key. Save it to `C:\Users\[bookkeeper]\.aws\credentials` (Windows) or `~/.aws/credentials` (Mac). If anyone uses that key, your bookkeeper's machine is compromised.

### 3. Canary document on your shared drive (10 minutes)
Create a Word doc named `Q1 2026 Payroll Backup — DO NOT DELETE.docx` using Canarytokens. Upload to the same shared folder as real payroll data. Anyone browsing the share and opening files they shouldn't trips the alert.

### 4. Fake AD admin account (30 minutes, if you have Active Directory)
Create `svc_backup_admin` or similar. Grant Domain Admin. Set a 100-character random password. Enable auditing on the account. Never use it. Any login attempt is a red alert.

### 5. Canary in your customer database (30 minutes)
Insert a row with a fake customer named something like "Alexandra Ziegler" with a unique, distinctive email. Set an alert that fires if that email address is ever queried against external services (HIBP, spam databases) — it means your database was exfiltrated.

---

## Rules for Honeytokens That Actually Work

1. **Make them plausible.** A file named `hackme.txt` will be ignored. A file named `2026_Q1_payroll_final.xlsx` placed where real payroll lives will not.
2. **Make them irresistible to automated tooling.** AI-assisted attacker agents scan for `.env`, `credentials`, `backup`, `database`, `payroll`, `admin`, `keys`, `secrets`. Use those names.
3. **Put them where real data is.** A canary on an isolated honeypot network catches nothing. A canary alongside real data catches everything.
4. **Tell no one except the response lead.** Honeytoken effectiveness degrades as awareness spreads. Keep the list in a sealed document, not in the company wiki.
5. **Test the alert path once a quarter.** A silent canary is worse than no canary.
6. **Treat any trip as a P1 incident until proven otherwise.** Don't downgrade "probably a curious employee" without investigation. The whole point of honeytokens is that the trip itself is high-signal.

---

## What Honeytokens Do NOT Replace

- **Perimeter security** (firewall, EDR, patching) — honeytokens detect late-stage compromise
- **Backups** — honeytokens don't recover data, they just tell you data was touched
- **Incident response plans** — when a canary trips, you need a playbook ready
- **MFA** — honeytokens catch attackers who are already in; MFA keeps them out

Think of honeytokens as the smoke detectors of your security program. You still need the fire extinguisher and the escape route.

---

## Why This Matters More After Mythos

Three specific post-Mythos reasons to deploy honeytokens this quarter:

1. **Automated agentic attackers scan aggressively.** AI-driven attack agents (documented in April 2026 Picus research: 2,500 orgs compromised in under an hour via one LLM attack chain) are not careful. They scan fast, enumerate shares, and dump credentials. They will trip honeytokens.

2. **The discovery-to-exploitation window collapsed.** You do not have time to retrofit detection after an attacker is already in. Honeytokens deployed today detect tomorrow's attack.

3. **SANS Priority Action PA9 calls for it explicitly.** Industry consensus now treats deception as a required capability, not an optional one. See [docs/17-industry-consensus-framework.md](17-industry-consensus-framework.md) for the full framework.

---

## A 90-Day Deception Capability Plan

| Week | Action | Cost |
|------|--------|------|
| 1 | Deploy 5 free Canarytokens (credential, AWS key, Word doc, DNS, web bug) | Free |
| 2 | Document alert escalation path; test every token | Free |
| 3-4 | Add one AD honey-account (if applicable) and one database canary row | Free, ~2 hours labor |
| 5-8 | Identify 3 places normal users never reach; place a canary in each | Free |
| 9-10 | Review trip log; retire any false-positive-prone tokens; replace with better bait | Free |
| 11-12 | If budget allows, evaluate Thinkst Canary appliance or equivalent | $7.5K/year if purchased |

By day 90 you should have ~10 active honeytokens covering credentials, files, network, database, and cloud — for under $100 out-of-pocket and <10 hours of labor.

---

## Further Reading

- Thinkst Labs research and blog: https://blog.thinkst.com
- MITRE ATT&CK — Deception techniques: https://attack.mitre.org
- "The Canary Guide" (Thinkst, free PDF after email signup)
- NIST SP 800-53 SC-26 (Honeypots) — formal US federal control

---

*Part of the mythos-launch-response community response plan. Contributions welcome — particularly specific deployment guides for AD, Azure, and Google Workspace environments.*
