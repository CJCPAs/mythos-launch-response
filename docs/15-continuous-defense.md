# Phase 5: Continuous Defense

**Timeline: Permanent. This is the new normal.**

Periodic vulnerability management is dead. In the AI vulnerability era, defense must be continuous.

---

## 5.1 The New Security Posture

Old model: Scan quarterly, patch monthly, pen-test annually.

New model: Scan continuously, patch within hours, AI-assisted review on every commit.

### Core Principles

1. **Assume your defenses will be ground through.** AI doesn't get tired. Friction-based security (obscurity, complexity, tedium) no longer works as a primary defense.

2. **Patch windows must shrink to near-zero.** When AI can convert a published CVE into a working exploit in minutes, your 70-day patch window is 70 days of exposure.

3. **Defense in depth still matters - but differently.** Layer defenses so that breaching one layer doesn't give access to everything. But make each layer genuinely hard, not just tedious.

4. **Detection must be AI-powered too.** Static rule-based detection won't catch novel exploit chains. Your monitoring needs behavioral analysis.

---

## 5.2 CI/CD Security Integration

Add security scanning to every pull request:

```yaml
# .github/workflows/security-scan.yml
name: Security Scan
on: [pull_request]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run npm audit
        run: npm audit --production --audit-level=high
      
      - name: Run Semgrep
        uses: returntocorp/semgrep-action@v1
        with:
          config: >-
            p/security-audit
            p/nodejs
            p/typescript
      
      - name: Check for secrets
        uses: trufflesecurity/trufflehog@main
        with:
          extra_args: --only-verified
```

### Future: AI-Assisted PR Review

When Mythos-class models become available via API:

```yaml
      - name: AI Security Review
        run: |
          # Send changed files to Mythos for security review
          # Block PR if Critical or High findings
          # Auto-comment findings on the PR
```

---

## 5.3 Runtime Monitoring

### What to Monitor

- Failed authentication attempts (volume and pattern)
- Unusual API call patterns (scanning behavior)
- Database query anomalies (new query patterns, bulk data access)
- Error rate spikes (may indicate fuzzing or exploit attempts)
- Outbound network connections from servers (data exfiltration)
- File system changes in production (webshell deployment)

### Tools to Consider

- **Cloudflare WAF + Bot Management** - front-line defense
- **Supabase Logs** - database access patterns
- **Vercel Logs** - serverless function behavior
- **PostHog** - user behavior anomalies (you already have this)
- **CrowdStrike / SentinelOne** - endpoint detection
- **Wiz** - cloud security posture management

---

## 5.4 Regular Scan Schedule

| Frequency | Scope | Model |
|-----------|-------|-------|
| Every PR | Changed files only | Best available (Opus 4.6+) |
| Weekly | Full application scan | Best available |
| Monthly | Infrastructure + dependencies | Best available |
| Quarterly | Full red-team exercise | Mythos-class if available |
| On any CVE affecting your stack | Targeted scan of affected components | Immediately |

---

## 5.5 Team Security Culture

- Every developer should understand the OWASP Top 10
- Security findings should be celebrated, not hidden
- Post-mortems should be blameless and focused on systemic fixes
- Keep a running log of every vulnerability found and fixed
- Share relevant findings with the community (after fixing)

---

## 5.6 Staying Informed

The landscape is changing weekly. Stay current:

- Follow Anthropic's security blog and Glasswing updates
- Monitor CISA's Known Exploited Vulnerabilities catalog
- Join relevant ISACs (Information Sharing and Analysis Centers) for your industry
- Attend security conferences or follow their proceedings (RSA, DEF CON, Black Hat)
- Follow security researchers on social media for early warnings

---

This is not a checklist you complete once. This is how you operate from now on.
