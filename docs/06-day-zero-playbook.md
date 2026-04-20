# Day Zero Playbook: When You Get Mythos-Class Access

**Date:** April 11, 2026 (last updated April 17, 2026)
**Audience:** Organizations preparing for access to Mythos-class vulnerability discovery tools

---

## Philosophy

When you get access to AI-powered vulnerability discovery, you'll have limited time and credits. Every dollar needs to count.

**As of April 17, 2026, there are three realistic access paths:**

1. **Claude Opus 4.7 + Cyber Verification Program** (the most likely path for SMBs and independent security consultants) — officially launched April 16, 2026. Application-based. $5/$25 per million tokens. Opus 4.7 has *deliberately reduced* cyber capability vs. Mythos but is the real-world tool most defenders will use. [Anthropic announcement](https://www.anthropic.com/news/claude-opus-4-7).
2. **Glasswing partner access** (restricted) — the 12 named partners plus ~40 unnamed organizations. Not accepting new applications.
3. **Mythos Preview direct access** (invitation-only) — via Claude API, Amazon Bedrock, Google Cloud Vertex AI, or Microsoft Foundry with allow-list entry.

This playbook is written to work for all three — the prompts and priority order are the same. Mythos finds more, faster, but Opus 4.7 and even Opus 4.6 have crossed the threshold: Hacktron demonstrated on April 17 that Opus 4.6 can build a working Chrome exploit chain for $2,283 over ~20 hours. The capability is real with generally-available models; Mythos is an acceleration, not a gate.

**Priority order:**
1. **Internet-facing assets first** — highest exposure
2. **Systems holding sensitive data second** — highest impact if breached
3. **Custom/niche software third** — not covered by Glasswing
4. **Commodity software last** — already being scanned by Glasswing partners

**Do NOT waste credits scanning Windows or Chrome.** Microsoft and Google are doing that. **Scan what nobody else is scanning for you.**

---

## 1. Pre-Access Readiness Checklist

Complete this BEFORE access arrives so Day Zero is pure execution:

### Environment
- [ ] Isolated scanning environment ready (VM or container)
- [ ] Network-isolated test lab for validating exploits (NEVER test on production)
- [ ] API credentials / access method documented
- [ ] Credit or usage budget allocated

### Targets
- [ ] Full software inventory completed
- [ ] Source code or binaries for custom applications staged
- [ ] Configuration files for critical systems documented
- [ ] Network topology documented
- [ ] Credential inventory current

### Response
- [ ] Remediation team identified (who fixes what)
- [ ] Emergency change window pre-approved
- [ ] Rollback procedures documented for every critical system
- [ ] Incident response plan reviewed and ready

---

## 2. The Anthropic Red Team Scaffold

This is adapted from [the methodology Anthropic's Frontier Red Team uses](https://red.anthropic.com/2026/mythos-preview/). These are the actual prompts.

### Prompt 1: File Ranking

```
Review the following source code repository. For each file, assign a score 
from 1 to 5 based on how likely it is to contain a security vulnerability:

1 = No possible vulnerability (constants, types, static config)
2 = Low likelihood (pure UI components, static content)
3 = Medium (business logic, data transformation)
4 = High (authentication, authorization, data access)
5 = Critical (raw input parsing, file handling, network-facing, auth flows)

Output a sorted list, highest score first, with a one-line rationale for each.
```

### Prompt 2: Parallel Vulnerability Scanning

Run this on every file scoring 4-5, in parallel:

```
You are performing a security audit of the following source code file. Your task 
is to find any security vulnerability in this code.

Approach:
1. Read the code carefully and hypothesize what vulnerabilities might exist
2. Consider the file in context of the broader application
3. Think about edge cases, race conditions, and unexpected inputs
4. Consider both the code itself and how it interacts with external systems

If you find a vulnerability:
- Describe it precisely
- Rate its severity (Critical / High / Medium / Low)
- Provide a proof-of-concept showing how it could be exploited
- Suggest a specific fix

If you find no vulnerability, state that clearly.
```

### Prompt 3: Validation Pass (Filter False Positives)

For every finding, run a second agent:

```
I have received the following security vulnerability report. Please review it 
and determine:

1. Is this vulnerability real and reproducible?
2. Is the severity rating accurate?
3. Is the proof-of-concept valid?
4. Is this an important vulnerability that affects real users, or a minor 
   edge case?
```

### Prompt 4: Exploit Validation (Critical/High Only)

```
The following vulnerability has been identified in our codebase. Please attempt 
to develop a working proof-of-concept exploit that demonstrates the impact.

Do NOT execute this against any production system. Work only within this 
isolated container.
```

---

## 3. Execution Sequence

### Hour 0-1: Validate Access

- Confirm credentials / API access works
- Run a trivial test scan on known-safe code
- Verify output format and severity ratings
- Confirm credit consumption rate
- Document any usage limits or rate limits

### Hour 1-4: Priority 1 — Your Highest-Risk Custom Asset

Your most internet-facing, most critical, least-likely-to-be-scanned-by-anyone-else system.

**Scan focus:**
- Authentication bypass / credential issues
- Path traversal / file access
- SQL injection / data access
- Privilege escalation
- Remote code execution
- API endpoint vulnerabilities
- Session management flaws
- Business logic bugs

**Immediate action if CRITICAL found:** Take system offline or behind VPN while you fix it.

### Hour 4-8: Priority 2 — Client/Customer-Facing Applications

Any application that touches sensitive data or faces external users.

**Scan focus:**
- Access control / authorization flaws
- Authentication flow bypass
- Data exposure via improper access control
- Dependency vulnerabilities

### Hour 8-12: Priority 3 — Infrastructure Layer

- Network device configurations
- VPN / remote access setup
- Email server configuration
- Custom scripts and automation
- Third-party integrations

### Hour 12-16: Priority 4 — Configuration Verification

Glasswing partners scan the CODE but not YOUR CONFIGURATION of that code.

- OS security settings and hardening
- Cloud IAM policies
- Firewall rule review
- Browser extension audit

---

## 4. Triage Framework

| Severity | Response | Timeline |
|----------|----------|----------|
| **CRITICAL** (RCE, auth bypass, internet-facing) | Isolate immediately. Patch within 24 hours. | IMMEDIATE |
| **HIGH** (privilege escalation, data exposure) | Restrict access. Compensating controls. Patch within 48 hours. | Same day |
| **MEDIUM** (requires local access, limited impact) | Schedule patch. Document compensating controls. | Within 7 days |
| **LOW** (theoretical, unlikely conditions) | Log and plan. Next maintenance window. | Within 30 days |

### Critical Finding Decision Tree

```
CRITICAL vulnerability found
    │
    ├── Internet-facing? → YES → Take offline NOW. Fix. Bring back.
    │                    → NO  → Network isolation. Emergency patch.
    │
    ├── Active exploitation evidence? → YES → INCIDENT RESPONSE ACTIVATED
    │                                → NO  → Standard patch timeline
    │
    └── Sensitive data at risk? → YES → Assess notification obligations
                               → NO  → Standard remediation
```

---

## 5. Finding Documentation Template

For each vulnerability discovered:

```markdown
## [SEVERITY] Finding Title

| Field | Value |
|-------|-------|
| System | |
| File/Component | |
| CWE | |
| Exploitability | Remote / Local / Adjacent |
| Data at Risk | |

### Description
[What was found]

### Impact
[What an attacker could do]

### Remediation
[What to fix]

### Status
- [ ] Verified
- [ ] Compensating control in place
- [ ] Patch developed
- [ ] Patch tested
- [ ] Patch deployed
- [ ] Post-remediation verification
```

---

## 6. Post-Scan Milestones

| Milestone | Target |
|-----------|--------|
| Access validated | Hour 0 |
| Highest-risk asset scanned | Hour 4 |
| Critical findings triaged | Hour 6 |
| All critical findings mitigated | Day 2 |
| All high findings mitigated | Week 1 |
| Full infrastructure scanned | Day 2 |
| Complete finding report documented | Day 3 |
| All medium findings mitigated | Week 2 |
| Post-remediation rescan | Week 3 |
| Clean posture (or documented accepted risk) | Week 4 |

---

## 7. Access Pathways to Monitor

| Pathway | Status (as of April 2026) |
|---------|--------------------------|
| **Cyber Verification Program** | Forthcoming — apply immediately when available |
| **Claude for Open Source** | Open for open source maintainers |
| **Future Claude Opus** | TBD — will include gated security capabilities |
| **Third-party security firms** | Some pentest firms may gain Glasswing access |
| **Open-source AI tools** | AISLE and others building discovery scaffolds on existing models |

---

*This playbook is ready to execute. When access arrives, start at Section 2.*
