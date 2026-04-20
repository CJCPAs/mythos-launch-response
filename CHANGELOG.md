# Changelog

All notable updates to this project.

## [1.5.0] - 2026-04-17 (third refresh — gap-closing release)

### Added
- **NEW DOC: [18-honeytokens-deception.md](docs/18-honeytokens-deception.md)** — Maps directly to SANS Priority Action PA9 (Build a Deception Capability, next 90 days). Free-tool deployment guide (Thinkst Canarytokens, DIY DNS canaries). 5-honeytoken starter set for an SMB, deployable in an afternoon. 90-day deployment plan under $100. Rules for honeytokens that actually work. Why this matters more after Mythos (automated agentic attackers are more likely to trip canaries than careful human attackers). Closes the last major gap from the April 14 SANS/CSA framework.
- **SMB Response Plan §10 "How This Maps to Industry Consensus"** — Explicit cross-reference table collapsing the 11 SANS priority actions into five practical SMB moves, each linking to the relevant section of this plan or other repo doc. Tells a reader exactly where to go for each industry-mandated capability.

### Changed
- **Day Zero Playbook** — Philosophy section rewritten to acknowledge three realistic access paths: Opus 4.7 + Cyber Verification Program (most likely for SMBs), Glasswing partner access, or direct Mythos Preview invitation. Hacktron $2,283 Chrome exploit cited as evidence the capability is real even with generally-available models.
- **Mythos Prompt Series** — New "Which Model Should You Run These Against?" section clarifying the prompts are model-agnostic and work with Mythos, Opus 4.7 (via CVP), or Opus 4.6 — with fewer findings at lower tiers but real findings. Cross-references SANS AI-is-good-at list. Notes that Opus 4.7 blocks high-risk requests outside the CVP by default.
- **README** — Total file count updated (66 → 67), documentation count updated (19 → 21 reflecting docs 17 and 18), total lines updated (8,500+ → 8,800+). Document index extended with entry 18.
- **ROADMAP** — Full restructure: "Completed" section now reflects v1.5.0 reality (all intelligence integrations, industry framework, honeytokens). New "Near-Term Research and Intelligence" section with seven specific signals to monitor. Next content priorities clarified (Node.js, Python, healthcare/financial/legal addenda, translations).

### Known Gaps Still Open
- Claude Code skill (`skill/`) has not yet been updated to load docs 17 and 18. Next skill-release cycle.
- Day Zero Playbook references Opus 4.7/CVP in philosophy but doesn't yet rewrite the four Red Team scaffold prompts for non-Mythos models. Intentional — the prompts are model-agnostic as written.
- Node.js/Express and Python/Django/FastAPI stack guides still "help wanted."
- Visual diagrams (threat timeline, segmentation architecture, IR flowchart) still roadmap items.

## [1.4.0] - 2026-04-17 (second refresh)

### Added
- **NEW DOC: [17-industry-consensus-framework.md](docs/17-industry-consensus-framework.md)** — Synthesis of the SANS/CSA/[un]prompted/OWASP GenAI Security Project joint emergency briefing (April 14) and the SANS BugBusters webcast (April 16). Includes all 11 priority actions verbatim with SMB translations, CSA "This week / 45 days / 12 months" framework, and mapping to every relevant resource in this repo.
- **Intelligence Brief §7.5 "Key Developments Since Initial Disclosure"** — Covers Claude Opus 4.7 launch (Apr 16), Cyber Verification Program launch (Apr 16), UK banks expansion, Hacktron Chrome exploit demonstration ($2,283 with Opus 4.6), AISLE Open Analyzer release, Mexican government breach caveat, access-dynamics scoops, competitor response, and expert consensus status.
- **Threat Landscape Shift** — New attacker-profile rows covering single-hacker mass compromise (Mexican govt breach), documented LLM attack chain (Picus: 2,500 orgs / 106 countries / under one hour), and Hacktron $2,283 Chrome exploit proof.
- **Threat Landscape Shift** — New sections on UK AI Security Institute's independent 32-step attack confirmation and AISLE Open Analyzer release.
- **Supply Chain Safety** — New "Two Paths to AI-Assisted Security Work" section distinguishing Opus 4.7 + Cyber Verification Program (generally available, $5/$25 per M tokens) from Mythos Preview (stays gated). New section on Hacktron's $2,283 Chrome exploit demonstrating threshold crossing with generally-available models.
- **Sources and References** — 30+ new entries across five new categories: Real-World Incidents and Proof-of-Capability, Access Dynamics and Geopolitics, Industry Emergency Briefing, Expanded Expert Commentary, Vendor/Analyst Coverage, Government/CVE Tracking. Total sources now 70+.
- **README Key Dates table** — Added April 14 joint briefing, April 16 Opus 4.7 + CVP + SANS webcast + AISLE Open Analyzer, April 17 Hacktron demonstration.

### Changed
- Intelligence Brief date header now reflects "last updated April 17, 2026" and CISA SMB gap statement updated to confirm gap persists.
- Threat Landscape Shift date header reflects last-updated date.
- Sources and References bumped from "40 sources" to "55+ sources" (actual count now 70+ across all categories).
- README headline count updated.

## [1.3.0] - 2026-04-17 (first refresh)

### Added
- **Privilege Escalation and Post-Compromise Assessment** section in Tools & Skills Reference — PEASS-ng (LinPEAS / WinPEAS) and BloodHound with EDR caveats and appropriate-use guidance
- **Google/Microsoft AI fuzzing (2024-2025) row** in Threat Landscape Shift comparison chart — establishes AI-augmented vulnerability discovery as a predecessor capability
- **Backup credential separation guidance** in SMB Response Plan — backup accounts must not share credentials or domain with production
- **Auto-update caveat for line-of-business software** in SMB Response Plan — acknowledges legacy/specialized software compatibility risk

### Changed
- Threat Landscape Shift comparison chart restructured with explicit **Type column**
- Self-Assessment question 9 updated to require separate credentials AND domain-independent backup storage
- Phase 0.4 of Mythos Prompt Series adds backup credential and domain-separation checks
- Sandbox escape framing in README updated to "reportedly escaped"

### Fixed
- Removed stale `ModelUser123` repo URLs; all references point to `CJCPAs/mythos-launch-response`
- `.gitignore` hardened with secret-file patterns
- Dockerfile installs now use pinned versions for Trivy, Grype, TruffleHog

## [1.2.0] - 2026-04-14

### Added
- Stack-specific hardening guides: Windows Workstations, VPN / Remote Access, Network Equipment
- Credential Security stack guide
- Interactive Claude Code skill with 14 stack references
- Docker-based isolated scanning environment
- `check-cisa-kev.sh` audit script
- CONTRIBUTING, ROADMAP, STORY, and full DISCLAIMER content

## [1.1.0] - 2026-04-11

### Added
- Phase 0: Baseline Security Verification (4 prompts)
- Executive summary one-pager
- Self-assessment scorecard
- Glossary of technical terms
- Tool recommendations
- Vendor security inquiry email template

### Changed
- Prompt series expanded from 15 to 19 prompts across 8 phases

## [1.0.0] - 2026-04-11

### Added
- Initial release
- Intelligence Brief, Glasswing Dossier, SMB Response Plan, Technical Analysis, Threat Landscape Shift, Pre-Access Patch Strategy, Day Zero Playbook, Mythos Prompt Series, Sources & References, Supabase hardening guide
- CONTRIBUTING.md, LICENSE (CC BY 4.0)
