# Mythos Readiness Skill for Claude Code

**An interactive security co-pilot that walks you through the entire Mythos response — from baseline verification to Day 1 scanning.**

This skill turns the repo's documentation into an executable, personalized, step-by-step workflow inside Claude Code.

---

## What It Does

**Mode A — Pre-Mythos Readiness:**
- Asks about your stack (OS, email, website, cloud, team size, data types)
- Loads ONLY the hardening guides relevant to your environment
- Creates a personalized checklist tracked in real-time
- Walks through Phase 0 baseline verification interactively (patches, MFA, credentials, backups, network)
- Won't let you skip critical items — completion gates enforce basics-first
- Integrates Snyk scans and Trail of Bits security skills at the right phases
- Runs audit scripts where possible
- Generates a readiness report with before/after self-assessment score

**Mode B — Day 1 Response (when you get Mythos access):**
- Re-verifies your baseline
- Auto-fills all 19 scanning prompts with your stack context (fill in details once, not 19 times)
- Executes the prompt series in priority order
- Aggregates findings across all prompts into a single deduplicated list
- Auto-categorizes findings by severity
- Generates fix suggestions (human review mandatory — never auto-applies)
- Tracks remediation status
- Produces a final scan report

---

## How to Install

### Option 1: Copy to your Claude Code skills directory

```bash
# Clone the repo
git clone https://github.com/CJCPAs/mythos-launch-response.git

# Copy the skill to your Claude Code skills directory
cp -r mythos-launch-response/skill ~/.claude/skills/mythos-readiness
```

### Option 2: Symlink (stays updated when you git pull)

```bash
git clone https://github.com/CJCPAs/mythos-launch-response.git
ln -s $(pwd)/mythos-launch-response/skill ~/.claude/skills/mythos-readiness
```

### Verify Installation

The skill should appear in your Claude Code skills list as:

```
mythos-readiness: Mythos cybersecurity readiness and response execution engine...
```

---

## How to Use

### Invoke the skill

Say any of these to Claude Code:

- `/mythos-readiness`
- "Prepare for Mythos"
- "Run security readiness check"
- "Mythos audit"
- "Run the Mythos playbook"
- "Check our Mythos readiness"
- "Day Zero scan"
- "Run security baseline"

### What happens next

1. Claude asks: readiness mode or Day 1 mode?
2. Claude collects your stack context (9 questions about your environment)
3. Claude loads only the relevant references for your stack
4. Claude creates a personalized checklist
5. Claude walks you through each check interactively
6. You fix issues as they're found
7. Claude generates a report when complete

---

## Skill Structure

```
skill/
├── SKILL.md                          Main orchestration (2 modes, 7 steps)
└── references/
    ├── phase-0-baseline.md           Baseline verification (patches, MFA, creds, backups, network)
    ├── stack-credentials.md          Password, MFA, banking, recovery, breach response
    ├── stack-microsoft-365.md        Microsoft 365 / Azure AD hardening
    ├── stack-google-workspace.md     Google Workspace hardening
    ├── stack-windows.md              Windows workstation hardening
    ├── stack-linux.md                Linux server hardening
    ├── stack-wordpress.md            WordPress hardening
    ├── stack-aws.md                  AWS hardening
    ├── stack-docker.md               Docker / container hardening
    ├── stack-supabase.md             Supabase hardening
    ├── stack-nextjs-vercel.md        Next.js / Vercel hardening
    ├── stack-cloudflare.md           Cloudflare hardening
    ├── stack-vpn.md                  VPN / remote access hardening
    └── stack-network.md              Network equipment hardening
```

References are loaded **conditionally** — if you don't use AWS, the AWS reference never loads. This keeps Claude's context focused on what matters for your specific environment.

---

## Tool Integration

The skill orchestrates these tools when available in your environment:

| Tool | When Used | Required? |
|------|-----------|:---------:|
| **Snyk MCP** (code, SCA, IaC, container) | Phase 2 pre-scanning | No |
| **Trail of Bits skills** (find-bugs, security-review, etc.) | Phases 1-6 | No |
| **Repo audit scripts** (audit-windows.ps1, audit-linux.sh, etc.) | Phase 0 baseline | No |

The skill works without any of these — it falls back to interactive checklist guidance. The tools make it faster and more thorough.

---

## Safety

- Never auto-applies fixes — all remediation requires human review
- Never scans production systems directly — uses isolated environments
- Never stores or displays credentials — audits their existence, not values
- Stops and escalates on evidence of active compromise
- Tracks API credit spend if using Mythos (alerts at 50% and 80% of budget)
