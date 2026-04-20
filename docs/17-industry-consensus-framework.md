# Industry Consensus Framework

**Date:** April 17, 2026
**Audience:** Security leaders, IT directors, business owners making investment decisions
**Status:** Synthesized from SANS, CSA, [un]prompted, OWASP GenAI Security Project joint emergency briefing (April 14, 2026) and the SANS "BugBusters" webcast (April 16, 2026)

---

## Why This Document Exists

In the ten days following the April 7 Mythos/Glasswing announcement, major security training organizations, industry analysts, and independent experts converged on a surprisingly consistent set of practical actions. This doc consolidates that consensus so you don't have to read 40 blog posts to find the signal.

The emerging consensus: **this accelerates existing risk, it does not invent new risk.** The actions required are things mature security programs were *already* doing — just now at machine speed, and now non-negotiable.

---

## Source of Record

On April 14, 2026, four organizations jointly released an emergency strategy briefing:

- **SANS Institute** (security training, 15 months of hands-on AI vuln discovery experience)
- **Cloud Security Alliance** (250-CISO guidance document, "AI Vulnerability Storm")
- **[un]prompted** (AI-focused policy research)
- **OWASP GenAI Security Project**

The briefing includes a 13-item risk register mapped to **OWASP LLM Top 10 2025, OWASP Agentic Top 10 2026, MITRE ATLAS, and NIST CSF 2.0**, plus an 11-item priority-action table and 10 CISO diagnostic questions.

- [SANS press release](https://cloudsecurityalliance.org/press-releases/2026/04/14/sans-institute-cloud-security-alliance-un-prompted-and-owasp-genai-security-project-release-emergency-strategy-briefing-as-ai-driven-vulnerability-discovery-compresses-exploit-timelines-from-weeks-to-hours)
- [CSA "Mythos-Ready" CISO briefing PDF](https://labs.cloudsecurityalliance.org/wp-content/uploads/2026/04/mythosreadyv92.pdf)
- [SANS BugBusters webcast](https://www.youtube.com/watch?v=X0aik3eCTdU) (presenters: Ed Skoudis, Joshua Wright, Chris Elgee — aired April 16, 2026)

---

## The 11 Priority Actions

| # | Action | Horizon | Severity | SMB Translation |
|:-:|--------|---------|:--------:|-----------------|
| **PA1** | **Point Agents at Your Code and Pipelines** — AI-driven review of code and dependencies before merge | This week | — | If you write any code: run an AI security review on your repo this week. See [docs/14-defensive-ai-scanning.md](14-defensive-ai-scanning.md) for copy-paste prompts. |
| **PA2** | **Require AI Agent Adoption** — Defenders at human speed cannot stop attackers at machine speed | This week | — | If your IT team isn't using AI for review, they will lose ground. This is no longer optional. |
| **PA3** | **Defend Your Agents** — Audit prompts, tool definitions, kill switches, scope boundaries | This month | **CRITICAL** | If you run any AI agents (Copilot, Claude Code, custom chatbots), audit what they can reach. Prompt injection is the new SQL injection. |
| **PA4** | **Establish Innovation and Acceleration Governance** — Cross-functional fast-tracking of defensive tech | This week | — | Create a one-page rule: security-improving tools skip standard procurement. Time-to-deploy matters more than perfect vendor review. |
| **PA5** | **Prepare for Continuous Patching** — Capacity for massive global patch volume | This week | **CRITICAL** | Your 30-day patch cadence is dead. Budget for either faster patching or segmentation that makes patching less urgent. |
| **PA6** | **Update Risk Models and Reporting** — "Pre-AI assumptions about patch windows and exploit scarcity are dead" | This week | **CRITICAL** | If your risk register still assumes "low-probability / high-impact" for unpatched CVEs, rewrite it. Probability just moved up. |
| **PA7** | **Inventory and Reduce Attack Surface** — Asset discovery, decommission unmaintained systems | This month | HIGH | You cannot defend what you cannot see. If you don't have an asset inventory, build one this month. |
| **PA8** | **Harden Your Environment** — Egress filtering, segmentation, phishing-resistant MFA | This month | HIGH | Hardware security keys for admins. Network segmentation between business and sensitive systems. Block outbound traffic by default. |
| **PA9** | **Build a Deception Capability** — Honeytokens + machine-speed containment | Next 90 days | — | Plant fake credentials and documents that alert you if an attacker touches them. Free tools like Canarytokens work. |
| **PA10** | **Build an Automated Response Capability** — Behavioral playbooks executing containment autonomously | Next 90 days | — | When something weird happens, your systems should isolate first and ask questions later. Manual response is too slow. |
| **PA11** | **Stand Up VulnOps** — "Build a permanent Vulnerability Operations function. Staff it and automate it exactly like DevOps, but dedicated to autonomous zero-day discovery and automated remediation pipelines." | Next 6-12 months | — | Vulnerability management becomes a permanent, funded function — not an annual pentest or a ticket queue. |

**Note:** The SANS landing page lists PA11 as a 12-month horizon; the CSA "Mythos-Ready" briefing lists it as 6 months. Treat 6-12 months as the range.

---

## The SMB Version of This Framework

If you run a business under 100 people without a dedicated security team, the above 11 actions collapse to **five** practical moves:

1. **This week — Run AI-assisted code and system review.** Use the [prompts in docs/14](14-defensive-ai-scanning.md) or the [Mythos Prompt Series](08-mythos-prompt-series.md) adapted for Opus 4.7.
2. **This week — Rewrite your "it probably won't happen to us" assumption.** You are a target because targeting is now cheap.
3. **This month — Inventory and harden.** List every system, decommission what isn't needed, enforce MFA, segment sensitive data.
4. **Next 90 days — Plant a honeytoken.** Free tier at [canarytokens.org](https://www.canarytokens.org). If anyone trips it, you know.
5. **Next 6 months — Pick a VulnOps partner or process.** For most SMBs this is a managed security service (MDR), not an in-house function. Pick one.

---

## What AI Is Good At (SANS, 15 Months of Hands-On Experience)

SANS is basing claims on 15 months of real penetration-testing experience using AI assistance, and their specific finding is that AI excels at **logic bugs**, not just memory corruption:

- **IDOR** (Insecure Direct Object Reference — "I changed the ID in the URL and saw someone else's data")
- **BOLA** (Broken Object Level Authorization — same idea, API version)
- **Race conditions** (two requests arriving at the same time cause unintended state)
- **Authorization flaws** (permission checks that look right but aren't)

**What this means for your code:** If you built a web app or API in the last five years, AI review will almost certainly find real issues. The SANS quote: "We found critical vulnerabilities in production code that was already tested thoroughly by humans."

---

## CSA's "This Week / 45 Days / 12 Months" Framework

The Cloud Security Alliance "Mythos-Ready" briefing, led by contributors including former CISA Director Jen Easterly and Bruce Schneier, organizes response by time horizon:

### This Week
- Point AI agents at your code
- Require AI agent adoption internally
- Establish acceleration governance
- Prepare for continuous patching
- Update risk models

### 45 Days
- Defend your agents
- Inventory and reduce attack surface
- Harden environment

### 12 Months
- Deception capability
- Automated response
- **Permanent VulnOps function**

CSA's core concept: **VulnOps** — vulnerability management as a permanent, funded organizational capability, staffed and automated like DevOps. This is the single most consequential shift in how the industry thinks about vulnerability management since the CVE system was created.

---

## How This Framework Maps to This Repo

| Framework Action | Repo Resource |
|------------------|---------------|
| PA1 (AI code review) | [14-defensive-ai-scanning.md](14-defensive-ai-scanning.md), [08-mythos-prompt-series.md](08-mythos-prompt-series.md) |
| PA2 (Agent adoption) | [skill/](../skill/) — our interactive Claude Code skill |
| PA3 (Defend agents) | [12-supply-chain-safety.md](12-supply-chain-safety.md) |
| PA5 (Continuous patching) | [05-pre-access-patch-strategy.md](05-pre-access-patch-strategy.md), [13-patch-wave-monitoring.md](13-patch-wave-monitoring.md) |
| PA6 (Risk model update) | [09-self-assessment.md](09-self-assessment.md) |
| PA7 (Attack surface) | [02-smb-response-plan.md](02-smb-response-plan.md) §3.4 |
| PA8 (Harden) | 13 stack guides in [stacks/](../stacks/) |
| PA9 (Deception) | (Roadmap — honeytoken guide is open for contribution) |
| PA10 (Automated response) | [15-continuous-defense.md](15-continuous-defense.md) |
| PA11 (VulnOps) | [15-continuous-defense.md](15-continuous-defense.md) + engage an MDR for SMBs |

---

## What Industry Consensus Does NOT Require

Also worth noting what the consensus is **not** saying:

- **Not:** Panic, lockdown, or shutting down internet-facing services
- **Not:** Immediate migration to a specific vendor
- **Not:** Gutting existing security programs and rebuilding from scratch
- **Not:** Waiting for Mythos access before acting (Hacktron demonstrated April 17 that Opus 4.6 can already build working exploits for $2,283)
- **Not:** Assuming existing tools are worthless (they still catch known patterns; Mythos changes the discovery-volume equation, not the value of detection)

---

## The Emerging Consensus in One Sentence

**Build vulnerability operations as a permanent, funded, AI-augmented function — not a quarterly project — because the economics of finding bugs permanently changed and the economics of patching them did not.**

---

*This framework is synthesized from multiple primary sources and is current as of April 17, 2026. The SANS/CSA joint briefing is the most authoritative document; this doc is a secondary navigator. Read the primaries when you can.*
