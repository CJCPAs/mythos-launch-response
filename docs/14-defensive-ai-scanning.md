# Phase 3: Defensive AI Scanning (Pre-Mythos)

**Timeline: Start now. Use the best models you have access to.**

You don't need Mythos to start scanning. Claude Opus 4.6 can find vulnerabilities - it just can't autonomously build exploits. For defensive purposes, finding is what matters.

---

## 3.1 Claude Code Defensive Scan Prompts

Run these via Claude Code pointed at your codebase. Each prompt should be run as a separate session focused on a specific attack surface.

### Authentication & Authorization
```
Review the entire authentication flow in this codebase. Trace every path from 
login to session creation to authorization checks. Identify:
1. Any way to bypass authentication entirely
2. Race conditions in session or token handling
3. Missing authorization checks on any API route
4. Token expiration or refresh vulnerabilities
5. Any path where a user could escalate privileges

For each finding, provide the exact file, line number, and a proof-of-concept 
description of how the vulnerability could be exploited.
```

### Database Security (Supabase/Postgres)
```
Audit every database interaction in this codebase. For each table and RLS policy:
1. Can an authenticated user access rows belonging to other users?
2. Can an anonymous user access any data they shouldn't?
3. Are there any SQL injection vectors (even through ORMs)?
4. Are there any Security Definer functions that bypass RLS?
5. Are there missing RLS policies on any table?
6. Can any edge function be called without proper authentication?

Test each finding by describing the exact API call or query that would 
demonstrate the vulnerability.
```

### Input Validation & Injection
```
Find every point in this codebase where user input enters the system - form 
fields, URL parameters, headers, file uploads, webhook payloads, API request 
bodies. For each input point:
1. Is the input validated and sanitized?
2. Could it be used for SQL injection, XSS, SSRF, or command injection?
3. Are file uploads restricted by type, size, and content?
4. Are webhook signatures verified?
5. Could malformed input cause a crash or denial of service?
```

### Secrets & Data Exposure
```
Scan this entire codebase for:
1. Hardcoded secrets, API keys, passwords, or tokens
2. Secrets that could leak through error messages or stack traces
3. Sensitive data exposed in client-side JavaScript bundles
4. Logging that captures sensitive user data
5. API responses that return more data than the client needs
6. Debug endpoints or development code left in production
```

### Infrastructure Configuration
```
Review all infrastructure configuration files (Dockerfile, docker-compose, 
vercel.json, cloudflare configs, nginx configs, environment variable handling):
1. Are containers running as root?
2. Are unnecessary ports exposed?
3. Are CORS policies overly permissive?
4. Are security headers set correctly (CSP, HSTS, X-Frame-Options)?
5. Are rate limits configured on all public endpoints?
6. Is TLS configured correctly?
```

### Third-Party Integration Security
```
Review every third-party integration (payment processors, email services, 
authentication providers, API connections). For each:
1. Are webhook signatures verified before processing?
2. Are API keys stored securely with minimal permissions?
3. Is data encrypted in transit to/from the third party?
4. Could a compromised third-party account be used to access your system?
5. Are there fallback or retry mechanisms that could be exploited?
```

---

## 3.2 Automated Scanning Tools (Non-AI)

Layer these on top of AI-assisted review:

```bash
# Static analysis for Node.js/TypeScript
npx eslint --ext .ts,.tsx . --rule 'security/*: error'

# Semgrep - free, pattern-based code scanning
# Install: pip install semgrep
semgrep --config=auto ./src

# npm audit for dependency vulnerabilities
npm audit --production --audit-level=critical

# TruffleHog for secrets in git history
trufflehog git file://./ --only-verified

# OWASP ZAP for dynamic scanning (run against staging)
# docker run -t owasp/zap2docker-stable zap-baseline.py -t https://your-staging-url
```

---

## 3.3 Interpreting Results

Not every finding is critical. Prioritize by:

1. **Critical** - Unauthenticated access to sensitive data, RCE, auth bypass. Fix immediately.
2. **High** - Authenticated privilege escalation, data leakage, injection vectors. Fix within 48 hours.
3. **Medium** - Missing security headers, verbose error messages, weak rate limits. Fix within 1 week.
4. **Low** - Informational findings, best practice violations. Schedule for next sprint.

Document every finding, even ones you decide not to fix immediately. When you get Mythos access, you'll want to re-verify that your "Low" findings aren't actually exploitable.

---

**Next:** [Phase 4 - Mythos Access Playbook](./04-mythos-access-playbook.md)
