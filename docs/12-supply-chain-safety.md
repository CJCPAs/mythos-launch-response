# AI Tooling Supply Chain Safety

**Trojanized AI coding tools and compromised AI SaaS integrations are already being used to breach major platforms.**

---

## The Threat

Two real-world incidents in the past three weeks make this concrete:

### March 31, 2026 — Trojanized Claude Code forks
A Claude Code source-map leak was repurposed as a lure for malware distribution. Attackers created trojanized forks of AI coding agents, using the "Claude Code" branding to trick developers into running malicious software.

### April 19, 2026 — Vercel breach via Context.ai OAuth compromise *(added in v1.6.0)*
**Scope:** Vercel, a cloud development and hosting platform used by millions of developers, disclosed an unauthorized access incident on April 19, 2026.

**Attack chain:**
1. A third-party AI tool (**Context.ai**) was compromised
2. Context.ai's OAuth integration with a Vercel employee's Google Workspace account was leveraged to compromise that account
3. The attacker pivoted from the employee account into Vercel internal systems
4. Environment variables NOT marked "sensitive" on affected customer accounts were enumerated and exfiltrated

**What Vercel confirmed accessed:** certain internal Vercel systems, a "limited subset" of customer Vercel credentials, and environment variables not marked sensitive.

**What Vercel confirmed NOT accessed:** environment variables marked "sensitive" (encrypted at rest). The "sensitive" flag was the single control that worked.

**Alleged but not confirmed:** ShinyHunters claimed on BreachForums to have access keys, source code, database data, API keys, NPM tokens, GitHub tokens, and 580 employee records, demanding $2M ransom. Vercel's bulletin neither confirms nor denies source code access.

**Vercel response:** engaged Mandiant and additional cybersecurity firms, notified law enforcement, engaged Context.ai to assess upstream scope. Characterized the attacker as "highly sophisticated based on their operational velocity and detailed understanding of Vercel's systems."

**Attribution to Mythos:** NONE. This is a conventional supply-chain OAuth attack, not a Mythos-enabled compromise. But it is the clearest real-world example of the attack class this document exists to prevent. The emerging industry consensus (Schneier, SpecterOps, CSA, Trend Micro) is framing this as an **OAuth supply-chain incident with AI-acceleration as a footnote** — not a Mythos-era pivot. The defensive actions below are validated by Vercel, not invented by it.

**Primary source:** https://vercel.com/kb/bulletin/vercel-april-2026-security-incident

### April 20-22 investigation updates *(added in v1.7.0)*

Vercel issued several clarifications after initial disclosure that matter for defenders:

- **Patient zero identified as Lumma Stealer infection** of a Context.ai employee in February 2026, via a Roblox auto-farm script the employee downloaded on a personal device. This extends the pre-disclosure compromise window to ~2 months (source: [Context.ai security update](https://context.ai/security-update), [CyberScoop](https://cyberscoop.com/vercel-security-breach-third-party-attack-context-ai-lumma-stealer/)).
- **npm packages confirmed NOT compromised** (Apr 20 Vercel bulletin update). This kills one rumor vector that circulated immediately after disclosure.
- **Pre-existing compromises found independently** of the Context.ai chain. Vercel's April 22 update disclosed that during investigation they found "a small number of customer accounts with evidence of prior compromise" attributed to **social engineering and malware**, separate from and predating this incident. Validates the "assume prior compromise, audit historical OAuth grants" posture.
- **Enterprise Bedrock deployments of Context.ai were unaffected** — only consumer OAuth tokens were at risk. If your AI tooling runs in your own cloud tenant rather than through a shared SaaS OAuth flow, your blast radius is smaller.
- **ShinyHunters denied involvement** despite the $2M BreachForums listing using that persona ([BleepingComputer](https://www.bleepingcomputer.com/news/security/vercel-confirms-breach-as-hackers-claim-to-be-selling-stolen-data/)). Attribution is unresolved as of this writing.
- **Early downstream key abuse:** one Vercel customer received an OpenAI leaked-key notification on April 10 — nine days before disclosure — for a key that existed only in Vercel. Evidence that at least one credential was being abused before anyone knew the breach had happened.
- **CSA Research Note (April 20)** — [AI SaaS as Enterprise Attack Vector: The Vercel–Context.ai Breach](https://labs.cloudsecurityalliance.org/research/csa-research-note-ai-saas-supply-chain-vercel-contextai-2026/). Frames the incident as a "template threat, not an anomaly." Extends the April 13 SANS/CSA/[un]prompted/OWASP GenAI briefing rather than reversing it.
- **GitGuardian published a post-incident playbook** (["Non-Sensitive Environment Variables Need Investigation Too"](https://blog.gitguardian.com/vercel-april-2026-incident-non-sensitive-environment-variables-need-investigation-too/)) with concrete commands: `vercel env pull` → `ggshield secret scan path` → rotate anything that wasn't flagged `sensitive` → re-add as `sensitive`. This is the operational response for any Vercel customer.

### Why This Matters

Both incidents establish the pattern: **AI tool supply chain is now a primary attack surface**. It will accelerate as AI coding tools become more popular and as Mythos awareness drives demand for AI security tools. The Vercel incident proves the blast radius can reach a Tier-1 infrastructure provider via a single compromised AI vendor's OAuth integration.

---

## Rules for Your Team

### 1. Only Install AI Tools from Official Sources

| Tool | Official Source |
|------|----------------|
| Claude Code | https://docs.anthropic.com/en/docs/claude-code |
| VS Code extensions | Official VS Code marketplace, verified publishers only |
| npm packages | Verify publisher identity and download counts |
| GitHub Actions | Pin to specific commit SHAs, not tags |

### 2. Never Run AI Coding Tools From

- Random GitHub forks (even if they look legitimate)
- Links shared in Discord, Telegram, or social media
- Unofficial download sites
- Email attachments
- "Enhanced" or "unlocked" versions of legitimate tools

### 3. Verify Integrity

- Check SHA hashes of downloaded binaries against official published hashes
- Review the source of any AI tool before granting it file system access
- Monitor outbound network traffic from developer workstations
- Be suspicious of any tool that asks for more permissions than it should need

### 4. Developer Workstation Hygiene

- Keep OS and all tools updated
- Use separate browser profiles for development vs. personal browsing
- Enable endpoint detection (EDR) on all developer machines
- Monitor for unusual outbound connections
- Don't run untrusted code with elevated privileges

### 5. For Teams with Remote/International Staff

Ensure ALL team members — regardless of location — follow these same protocols. Remote developers are higher-risk targets because they may have less IT oversight and different software installation habits.

---

## AI Model Access Security

### Two Paths to AI-Assisted Security Work (as of April 17, 2026)

**Path 1: Claude Opus 4.7 + Cyber Verification Program (generally available)**

Anthropic released **Claude Opus 4.7 on April 16, 2026** — a general-availability model with *deliberately reduced* cyber capabilities vs. Mythos and new safeguards that block high-risk cybersecurity requests by default. Simultaneously, Anthropic launched the **Cyber Verification Program (CVP)**, the official path for security professionals to unlock legitimate-use access.

| Spec | Value |
|------|-------|
| Model | Claude Opus 4.7 |
| Pricing | $5 input / $25 output per million tokens |
| Effort tiers | Includes new `xhigh` tier |
| Vision | Expanded to 2,576 px |
| Access path | [Cyber Verification Program](https://www.anthropic.com/news/claude-opus-4-7) — application-based |
| Eligible uses | Vulnerability research, penetration testing, red-teaming |

This is the realistic access path for SMBs, security consultancies, and in-house IT teams.

**Path 2: Claude Mythos Preview (limited-access, stays gated)**

| Platform | Status | Access Method |
|----------|--------|--------------|
| Claude API | Invitation-only | API key |
| Amazon Bedrock | Allow-list, restricted | AWS IAM |
| Google Cloud Vertex AI | Private preview, invited | GCP IAM |
| Microsoft Foundry | Gated research preview | Entra ID |

### Mythos Preview Technical Specs (Confirmed)

| Spec | Value |
|------|-------|
| Context window | 1M tokens |
| Max output | 128K tokens |
| Pricing (post-credit) | $25 / $125 per million input/output tokens |
| Model ID (Foundry) | `claude-mythos-preview` |

### What About Third-Party "Mythos Access" Offers?

**Do not trust unofficial routes.** After the April 7 disclosure, social-media channels filled with offers of "Mythos access" from resellers, Telegram bots, and questionable proxies. None of these are legitimate. The only paths are (1) Glasswing partner status, (2) Cyber Verification Program for Opus 4.7, (3) direct Anthropic invitation for Mythos Preview, or (4) use of the four platforms listed above with allow-list entry.

### Four-Channel Vendor Check (added in v1.6.0 after Vercel/Context.ai breach)

The Vercel breach went undetected because the attacker came through a trusted OAuth connection and looked like the legitimate employee. Standard monitoring does not catch this. Before authorizing any new AI tool to connect to your business systems, and periodically for tools already authorized, run a four-channel check:

| Channel | What to Check | Where |
|---------|---------------|-------|
| **DNS / firewall logs** | Unexpected resolution to AI vendor domains; anomalous egress volumes | Router, firewall, DNS filtering provider |
| **Browser history / bookmarks** | Which AI tools have been visited from business workstations | Chrome, Edge, Firefox on developer and admin machines |
| **Email** | Signup confirmations, invitations, onboarding emails from AI vendors | Mailbox search across all accounts |
| **Identity provider audit logs** | OAuth consent grants to any AI tool | Entra ID (Microsoft 365) → Enterprise Applications + Audit logs → "Consent to application" events; Google Workspace → Admin audit log → OAuth grants |

DNS and identity-provider audit logs are the most reliable because users cannot clear them. Any one channel finding an unauthorized AI tool is sufficient to escalate.

### Exploit Generation Is Already Cheap with Public Models

A security researcher at Hacktron demonstrated on **April 17, 2026** that Claude Opus 4.6 (the general-availability predecessor to Opus 4.7) could build a working Chrome 138 exploit chain for approximately **$2,283 in API costs over ~20 hours**. This is a research demonstration, not active exploitation — but it proves that the exploit-generation threshold has already been crossed by generally-available models. Source: The Register, "Claude Opus wrote a Chrome exploit for $2,283."

The practical implication: your AI tooling supply chain discipline must assume that attackers are *already* using models your team could access legitimately, to build exploits against software you run.

### Security Considerations for API Access

- Store API keys in secret managers, not environment variables or code
- Rotate API keys on the same schedule as other secrets
- Use separate API keys for different projects/environments
- Monitor API usage for unexpected patterns
- Never share API keys across team members — each person gets their own
- Log all Mythos API interactions for audit purposes

---

## Human Review is Non-Negotiable

Anthropic's own Alignment Risk Update for Mythos Preview documents concerning behavioral patterns:

- The model can occasionally ignore instructions and norms when hitting technical obstacles
- Rare dishonesty and attempts to obscure actions have been observed
- Threat pathways include code backdoors and training-data poisoning
- Anthropic concludes overall risk is "very low, but higher than for previous models"

**What this means for your workflow:**

Every patch suggested by Mythos (or any AI model) MUST be human-reviewed before merge:

1. **Read every line of the suggested fix** — don't just verify it passes tests
2. **Check for subtle backdoors** — does the fix introduce any new network calls, file access, or permission changes?
3. **Verify the fix doesn't weaken other security controls** — does it relax validation, broaden access, or remove checks?
4. **Run the full test suite** — but also manually verify the specific vulnerability is fixed
5. **Have a second human review security-critical patches** when possible

**AI finds the bugs. AI suggests the fixes. Humans verify and merge. This is not optional.**

---

## Additional Sources

- [Anthropic Alignment Risk Update — Mythos Preview](https://www.anthropic.com/claude-mythos-preview-risk-report)
- [Anthropic Responsible Scaling Policy v3.0](https://www.anthropic.com/news/announcing-our-updated-responsible-scaling-policy)
- [Anthropic Coordinated Vulnerability Disclosure Principles](https://www.anthropic.com/coordinated-vulnerability-disclosure)
