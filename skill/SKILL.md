---
name: mythos-readiness
description: Mythos cybersecurity readiness and response execution engine. Use when asked to "prepare for Mythos", "security readiness", "Mythos audit", "Day Zero scan", "run security baseline", "check Mythos readiness", "security hardening", "run the Mythos playbook", "pre-Mythos check", "Mythos response", or when discussing Mythos/Glasswing preparedness. Orchestrates Phase 0 baseline verification through Phase 7 remediation using automated scripts, scanning tools, and 19-prompt series.
---

# Mythos Readiness and Response Engine

Two-mode security orchestration skill for the post-Mythos threat landscape.

**Mode A — Pre-Mythos Readiness:** Walk through baseline verification, stack hardening, and scanning with current tools to prepare for Mythos-class access.

**Mode B — Day 1 Response:** Execute the 19-prompt Mythos scanning series with auto-filled stack context, finding aggregation, triage, and remediation tracking.

## Step 0: Determine Mode and Collect Context

Ask the user:

> Are you preparing for Mythos (readiness mode), or do you have access and are ready to scan (Day 1 mode)?

Then collect stack context (used across all phases):

```
I need to understand your environment to personalize the scan. Please tell me:

1. What operating system(s) do you run? (Windows 11, macOS, Ubuntu, etc.)
2. What's your primary email/identity platform? (Microsoft 365, Google Workspace, other)
3. Do you have a website? What does it run on? (WordPress, Next.js, Shopify, custom, etc.)
4. What cloud services do you use? (AWS, Vercel, Supabase, Cloudflare, none, etc.)
5. Do you have internet-facing servers or applications? (describe)
6. What's your team size? (just you, 2-10, 10-50, 50+)
7. Do you handle sensitive data? (financial, health, legal, PII — which types?)
8. Do you have a password manager deployed? (which one, or none)
9. Do you have MFA enabled on your email? (yes/no/not sure)
```

Store responses as the `STACK_CONTEXT`. Inject into all subsequent prompts and reference loading.

## Step 1: Load References by Stack

Based on `STACK_CONTEXT`, read ONLY the relevant references:

| User's Stack | Load These References |
|-------------|----------------------|
| Any (always) | `references/phase-0-baseline.md` |
| Microsoft 365 / Outlook / Teams | `references/stack-microsoft-365.md` |
| Google Workspace / Gmail | `references/stack-google-workspace.md` |
| WordPress | `references/stack-wordpress.md` |
| AWS | `references/stack-aws.md` |
| Windows workstations | `references/stack-windows.md` |
| Linux servers | `references/stack-linux.md` |
| Next.js / Vercel | `references/stack-nextjs-vercel.md` |
| Supabase | `references/stack-supabase.md` |
| Cloudflare | `references/stack-cloudflare.md` |
| Docker / containers | `references/stack-docker.md` |
| VPN / remote access | `references/stack-vpn.md` |
| Network equipment | `references/stack-network.md` |
| Handles passwords/banking/credentials | `references/stack-credentials.md` |

## Step 2: Create Progress Tracker

Create a TodoWrite checklist personalized to the user's stack. Only include items relevant to their environment.

### Mode A (Readiness) Checklist Template:

```
Phase 0: Baseline Verification
- [ ] Patch currency check (all systems)
- [ ] MFA verification (all critical accounts)
- [ ] Password audit (haveibeenpwned + manager deployment)
- [ ] Backup verification (3-2-1 rule + test restore)
- [ ] [Stack-specific items based on STACK_CONTEXT]

Phase 1: Stack Hardening
- [ ] [Items from loaded stack references]

Phase 2: Pre-Scanning with Current Tools
- [ ] Run Snyk code scan (if custom code exists)
- [ ] Run Snyk SCA scan (if dependencies exist)
- [ ] Run Snyk IaC scan (if infrastructure-as-code exists)
- [ ] Run audit scripts (Windows/Linux/network as applicable)

Phase 3: Readiness Verification
- [ ] Self-assessment scorecard completed
- [ ] All CRITICAL items from Phase 0 resolved
- [ ] Scanning environment prepared (if planning for Day 1)
- [ ] Vendor security inquiries sent
```

### Mode B (Day 1) Checklist Template:

```
Phase 0: Re-verify Baseline
- [ ] Patch currency confirmed
- [ ] MFA confirmed on all critical accounts

Phase 1: Triage (Hour 1)
- [ ] Run Prompt 1.1 — Full Codebase Triage
- [ ] Run Prompt 1.2 — Dependency Deep Scan
- [ ] Run Prompt 1.3 — Architecture Threat Model

Phase 2: Auth & AuthZ (Hours 2-4)
- [ ] Run Prompt 2.1 — Authentication Flow Audit
- [ ] Run Prompt 2.2 — Authorization Deep Dive

Phase 3: Injection & Input (Hours 4-6)
- [ ] Run Prompt 3.1 — Injection Vulnerability Sweep
- [ ] Run Prompt 3.2 — File Upload and Processing

Phase 4: Business Logic (Hours 6-8)
- [ ] Run Prompt 4.1 — Business Logic Bugs
- [ ] Run Prompt 4.2 — Data Exposure Audit

Phase 5: Infrastructure (Hours 8-10)
- [ ] Run Prompt 5.1 — Configuration Security Review
- [ ] Run Prompt 5.2 — Network Attack Surface

Phase 6: Validation (Hours 10-12)
- [ ] Run Prompt 6.1 — Finding Validation (per finding)
- [ ] Run Prompt 6.2 — Exploit Chain Construction

Phase 7: Remediation
- [ ] Run Prompt 7.1 — Fix Generation (per finding)
- [ ] Run Prompt 7.2 — Post-Fix Verification
- [ ] All CRITICAL findings mitigated
- [ ] All HIGH findings mitigated
- [ ] Post-remediation rescan complete
```

## Step 3: Execute Phase 0 — Baseline Verification

Read `references/phase-0-baseline.md` and walk through each check interactively.

For each check:
1. Explain what you're checking and why
2. Provide the exact command or action
3. Ask the user for the result (or run the command if possible)
4. Record PASS / FAIL / WARN
5. If FAIL on a critical item, stop and fix before proceeding

**Completion gate:** Do NOT proceed to Phase 1 until all Phase 0 CRITICAL items pass.

## Step 4: Execute Stack Hardening (Mode A) or Scanning (Mode B)

### Mode A: Walk through each loaded stack reference interactively

For each stack guide:
1. Present the checklist items one section at a time
2. Provide exact commands, configurations, or admin console paths
3. Wait for user confirmation before marking complete
4. Track progress in TodoWrite

### Mode B: Execute the 19-prompt series

For each prompt in the series:
1. Auto-fill `[BRACKETED PLACEHOLDERS]` with `STACK_CONTEXT`
2. Present the filled prompt to the user (or run directly if in Claude Code with the codebase)
3. Collect findings
4. Add each finding to a running findings list with severity
5. After each prompt completes, update TodoWrite progress

## Step 5: Finding Aggregation (Mode B)

After scanning phases complete, aggregate all findings:

```markdown
# Findings Summary

## CRITICAL (Fix immediately)
| # | Finding | System | Prompt | Exploitability |
|---|---------|--------|--------|---------------|

## HIGH (Fix within 48 hours)
| # | Finding | System | Prompt | Exploitability |
|---|---------|--------|--------|---------------|

## MEDIUM (Fix within 7 days)
| # | Finding | System | Prompt | Exploitability |
|---|---------|--------|--------|---------------|

## LOW (Next maintenance window)
| # | Finding | System | Prompt | Exploitability |
|---|---------|--------|--------|---------------|
```

Deduplicate findings that appear in multiple prompts. Flag any findings that could be chained together.

## Step 6: Remediation Tracking

For each CRITICAL and HIGH finding:
1. Generate a fix using Prompt 7.1 (auto-filled with finding details)
2. Present the fix for human review (**mandatory** — never auto-apply)
3. Track fix status: Proposed → Reviewed → Applied → Verified

## Step 7: Final Report

Generate a scan report:

```markdown
# Mythos [Readiness/Scan] Report — [Date]

## Environment
[STACK_CONTEXT summary]

## Scope
[What was checked/scanned]

## Results
| Severity | Count | Mitigated | Remaining |
|----------|:-----:|:---------:|:---------:|
| CRITICAL | | | |
| HIGH | | | |
| MEDIUM | | | |
| LOW | | | |

## Key Findings
[Top 5 most significant findings]

## Actions Taken
[What was fixed during this session]

## Remaining Work
[What still needs attention]

## Next Steps
[Recommended follow-up actions and timeline]

## Self-Assessment Score
Before: ___/25
After: ___/25
```

## Tool Integration Points

When available in the environment, use these tools at the specified phases:

### Snyk MCP (Phase 2 Pre-Scanning)
- `snyk_code_scan` — run on all custom code
- `snyk_sca_scan` — run on all dependencies
- `snyk_iac_scan` — run on Dockerfiles, Terraform, CloudFormation
- `snyk_container_scan` — run on production container images

### Trail of Bits Skills (Phase 1-6)

| Phase | Skill | Purpose |
|-------|-------|---------|
| 0 | `/securityinsecure-defaults` | Detect fail-open defaults |
| 1 | `/securityaudit-prep-assistant` | Prepare codebase for review |
| 1-5 | `/securityfind-bugs` | Find bugs in code |
| 1-5 | `/securitysecurity-review` | Full security review |
| 1-5 | `/securitycodeql` | Deep data flow analysis |
| 1-5 | `/semgrep` | Static analysis |
| 6 | `/securityfp-check` | Validate findings |
| 6 | `/securityvariant-analysis` | Find similar bugs |
| 7 | `/securitydifferential-review` | Review patches |

### Audit Scripts (Phase 0)
If the mythos-launch-response repo is cloned locally:
- Windows: `powershell -ExecutionPolicy Bypass -File scripts/audit-windows.ps1`
- Linux: `sudo bash scripts/audit-linux.sh`
- Network: `bash scripts/audit-network.sh [IP] [DOMAIN]`
- Dependencies: `bash scripts/audit-dependencies.sh [PROJECT_PATH]`

## Safety Boundaries

1. **Never auto-apply fixes.** Present all remediation for human review.
2. **Never scan production systems directly.** Use isolated environments for active scanning.
3. **Never store or display credentials.** Audit their existence, not their values.
4. **Never run exploits outside isolated containers.**
5. **Stop and escalate** if you discover evidence of active compromise — do not continue scanning.
6. **Track credit spend** if using Mythos API — alert the user at 50% and 80% of budget.
