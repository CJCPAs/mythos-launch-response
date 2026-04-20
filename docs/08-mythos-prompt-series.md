# Mythos Prompt Series: Day 1 Execution Prompts

**Date:** April 11, 2026 (last updated April 17, 2026)
**Purpose:** Copy-paste prompt series for systematic vulnerability discovery with Mythos-class models
**Adapted from:** [Anthropic Frontier Red Team methodology](https://red.anthropic.com/2026/mythos-preview/)

---

## Which Model Should You Run These Against?

These prompts are model-agnostic. They work with Mythos Preview (if you have it), Claude Opus 4.7 via the Cyber Verification Program (the realistic path for most SMBs — [launched April 16, 2026](https://www.anthropic.com/news/claude-opus-4-7)), or even Opus 4.6. You will get fewer findings with Opus 4.6 than with Mythos, but you will get real findings. As the SANS BugBusters webcast (April 16) put it: AI is good at finding IDOR, BOLA, race conditions, and authorization flaws — and that's true of all three model tiers.

Before you run any of this, read [docs/17-industry-consensus-framework.md](17-industry-consensus-framework.md) to understand where this scan fits in the broader SANS/CSA 11-priority-action framework (this covers PA1: Point AI agents at your code).

---

## How to Use This Document

These prompts are sequenced. Run them in order. Each phase builds on the previous.

**Before you start:**
- Have your source code in an isolated container (NOT connected to production)
- Have API access configured and tested
- Have a clean branch ready for security patches
- Have your team notified you're entering a security sprint
- **If you are using Opus 4.7 via Cyber Verification Program:** confirm your application is approved. Opus 4.7 blocks high-risk cybersecurity requests by default for users outside the CVP.

**Important:** Replace all `[BRACKETED TEXT]` with your actual values before running.

---

## Phase 0: Baseline Security Verification (Before Mythos)

**Run this BEFORE you touch Mythos.** Don't waste Mythos credits finding things that a patch or a benchmark scan would catch. Get current on all the basics first.

### Prompt 0.1 — Patch and Version Currency Check

```
I need you to verify that our entire stack is current on security patches and 
supported versions. This is a baseline hygiene check BEFORE we run deeper 
vulnerability scanning.

Our stack:
- Operating system(s): [Windows 11 / Ubuntu 24.04 / macOS Sequoia / etc.]
- Web server: [nginx / Apache / Caddy / none (serverless) / etc.]
- Runtime(s): [Node.js XX / Python 3.XX / Go X.XX / etc.]
- Framework(s): [Next.js XX / Django X.X / Express X / etc.]
- Database(s): [PostgreSQL XX / MySQL X / Supabase / MongoDB X / etc.]
- Cache/queue: [Redis X / RabbitMQ / none / etc.]
- Container: [Docker XX / Kubernetes X.XX / none / etc.]
- Cloud provider: [AWS / Vercel / GCP / Azure / Hetzner / etc.]
- Browser targets: [Chrome / Firefox / Edge / Safari — versions]

For each component:

1. **Is our version still receiving security updates?** Flag any EOL or 
   approaching-EOL software.
2. **What is the latest security patch available?** Compare to our version.
3. **Are there any unpatched CVEs in our exact version?** List each with 
   severity rating.
4. **Is our version affected by any Mythos-disclosed vulnerabilities?** 
   Check against known Glasswing-related CVEs:
   - CVE-2026-4747 (FreeBSD NFS)
   - OpenBSD TCP SACK (pending CVE)
   - FFmpeg H.264 (pending CVE)
   - Linux kernel CVE-2024-47711 + chain
   - Browser sandbox escapes (pending CVEs)
   - TLS/AES-GCM/SSH implementation weaknesses (pending CVEs)

Output a table:

| Component | Our Version | Latest Version | Security Patches Behind | Known CVEs | Mythos-Related | Action Needed |
|-----------|------------|---------------|:-----------------------:|:----------:|:--------------:|--------------|

Flag anything RED that needs immediate patching before we proceed.
```

### Prompt 0.2 — Security Standards Compliance Baseline

```
Audit our current security posture against established security standards and 
benchmarks. I need to know where we stand on the basics before we look for 
advanced vulnerabilities.

Check against these frameworks (applicable sections only — skip what doesn't 
apply to our stack):

**CIS Benchmarks (Center for Internet Security):**
- [ ] CIS Benchmark for [our OS]: password policies, file permissions, 
      network configuration, logging, audit settings
- [ ] CIS Benchmark for [our database]: authentication, access control, 
      encryption, logging
- [ ] CIS Benchmark for [our web server]: TLS config, header security, 
      access restrictions
- [ ] CIS Benchmark for Docker (if applicable): image security, runtime 
      config, daemon settings
- [ ] CIS Benchmark for Kubernetes (if applicable): RBAC, network policies, 
      pod security

**OWASP standards:**
- [ ] OWASP Top 10 (2021) — are all 10 categories addressed?
  - A01: Broken Access Control
  - A02: Cryptographic Failures
  - A03: Injection
  - A04: Insecure Design
  - A05: Security Misconfiguration
  - A06: Vulnerable and Outdated Components
  - A07: Identification and Authentication Failures
  - A08: Software and Data Integrity Failures
  - A09: Security Logging and Monitoring Failures
  - A10: Server-Side Request Forgery
- [ ] OWASP ASVS (Application Security Verification Standard) Level 1 
      minimum — are the baseline controls met?

**NIST Cybersecurity Framework 2.0 basics:**
- [ ] IDENTIFY: Do we have an asset inventory? Risk assessment?
- [ ] PROTECT: Access control, data security, maintenance, protective technology
- [ ] DETECT: Anomalies and events monitoring, continuous monitoring
- [ ] RESPOND: Response plan, communications, analysis, mitigation
- [ ] RECOVER: Recovery plan, improvements, communications

**Email security standards:**
- [ ] SPF record configured and valid?
- [ ] DKIM signing enabled?
- [ ] DMARC policy set (and not p=none)?
- [ ] MX records point to expected servers?

**TLS/SSL standards:**
- [ ] TLS 1.2+ enforced (TLS 1.0 and 1.1 disabled)?
- [ ] Strong cipher suites only (no RC4, DES, 3DES, NULL)?
- [ ] HSTS enabled with adequate max-age?
- [ ] Certificate valid and not approaching expiration?
- [ ] Certificate chain complete?

For each standard, output:

| Standard | Section | Status | Finding | Priority |
|----------|---------|:------:|---------|:--------:|
| CIS [OS] | 1.1.1 Password length | PASS/FAIL | Details | P0-P3 |

At the end, give me:
1. A compliance percentage for each framework
2. The top 10 most critical gaps
3. Specific commands or configuration changes to close each gap
```

### Prompt 0.3 — Credential and Access Hygiene Verification

```
Perform a comprehensive credential and access hygiene audit. These are the 
basics that, if wrong, make everything else irrelevant.

Check:

1. **Multi-Factor Authentication (MFA)**
   For each of these services, verify MFA is enabled:
   - [ ] Email provider (Google Workspace / Microsoft 365 / etc.)
   - [ ] Cloud hosting (AWS / GCP / Azure / Vercel / etc.)
   - [ ] Code repository (GitHub / GitLab / Bitbucket)
   - [ ] Database admin portals
   - [ ] Domain registrar
   - [ ] DNS provider
   - [ ] CDN / WAF provider
   - [ ] Payment processor (Stripe / etc.)
   - [ ] Accounting / ERP system
   - [ ] Password manager admin
   - [ ] CI/CD system
   - [ ] Monitoring / alerting system
   
   For any where MFA is NOT enabled, flag as CRITICAL.

2. **API Keys and Secrets**
   - List every API key, secret, and token in use
   - When was each last rotated? Flag any over 90 days old.
   - Are any keys overly permissioned? (admin keys used where read-only would suffice)
   - Are any keys shared between environments? (same key in dev and prod)
   - Are any keys committed to git? (check current code AND git history)

3. **User Accounts**
   - List all user accounts across all systems
   - Flag inactive accounts (no login in 90+ days)
   - Flag shared accounts (generic logins used by multiple people)
   - Flag accounts without MFA
   - Flag accounts with admin privileges — is each justified?
   - Flag any default accounts that haven't been disabled (admin/admin, root, etc.)

4. **Service Accounts**
   - List all service accounts and automated credentials
   - Are they scoped to minimum necessary permissions?
   - Do they have expiration dates?
   - Can they be used interactively? (should they be?)

5. **Password Policy**
   - What is the minimum password length enforced? (should be 16+)
   - Is password reuse prevented?
   - Is there a password breach check (HaveIBeenPwned integration)?
   - Is a password manager deployed organization-wide?

Output a risk-ranked table of every credential issue found, with specific 
remediation steps for each.
```

### Prompt 0.4 — Backup and Recovery Verification

```
Verify our backup and disaster recovery posture. If a Mythos-class exploit 
hits us tomorrow, can we recover?

Verify:

1. **Backup existence and coverage**
   - What data is backed up? List every data store.
   - What data is NOT backed up? Flag gaps.
   - What is the backup frequency? (daily? hourly? continuous?)
   - What is the retention period?

2. **Backup integrity**
   - When was the last test restore performed?
   - Did it succeed? How long did it take?
   - Are backups encrypted? With what algorithm? Where is the key stored?
   - Are backups stored in a different account/region/provider than production?
   - Is at least one backup air-gapped (physically disconnected)?
   - Do backup systems use separate credentials from production? (Not your domain admin accounts)
   - Is backup storage joined to or independent from your company domain/network?

3. **Recovery objectives**
   - What is the Recovery Time Objective (RTO)? How fast can we be operational?
   - What is the Recovery Point Objective (RPO)? How much data can we afford to lose?
   - Are these objectives documented and agreed upon?
   - Has the team practiced a full recovery?

4. **Ransomware resilience**
   - Can an attacker who compromises our production systems also reach our backups?
   - Are backup credentials separate from production credentials?
   - Is there an immutable/WORM backup copy that cannot be deleted even with admin access?
   - Do we have offline backups that would survive a complete cloud account compromise?

5. **Incident response readiness**
   - Is there a documented incident response plan?
   - Does the team know who to call? (IR firm, legal, insurance, law enforcement)
   - Is the plan accessible if email and internal systems are down?
   - When was the plan last tested/rehearsed?

For each gap found, provide:
- Risk level (what's the worst case if this isn't fixed)
- Specific remediation steps
- Estimated time to fix
```

### Phase 0 Completion Gate

**Do NOT proceed to Phase 1 until:**

- [ ] All critical patches applied (Prompt 0.1 RED items resolved)
- [ ] OWASP Top 10 basics addressed (Prompt 0.2 — no CRITICAL gaps)
- [ ] MFA enabled on all critical services (Prompt 0.3)
- [ ] All API keys less than 90 days old (Prompt 0.3)
- [ ] No default or shared credentials (Prompt 0.3)
- [ ] Backup restore tested within last 90 days (Prompt 0.4)
- [ ] Incident response plan documented and accessible (Prompt 0.4)

**Why this gate matters:** If you have an unpatched OS, no MFA on your email, and untested backups, Mythos scanning your custom code won't save you. Attackers take the easiest path. Fix the basics first, then use Mythos for what only Mythos can find.

---

## Phase 1: Reconnaissance and Triage (Hour 1)

### Prompt 1.1 — Full Codebase Triage

This is the first thing you run. It tells you where to focus.

```
You are performing a security audit of a production codebase. Your first task is 
to triage every file by vulnerability likelihood.

Repository context:
- Application type: [web app / API / mobile backend / CLI tool / etc.]
- Primary language: [TypeScript / Python / Go / etc.]
- Framework: [Next.js / Express / Django / FastAPI / etc.]
- Database: [PostgreSQL / MySQL / MongoDB / Supabase / etc.]
- Authentication: [JWT / session / OAuth / Supabase Auth / etc.]
- Deployment: [Vercel / AWS / Docker / bare metal / etc.]
- Internet-facing: [yes / no]
- Handles sensitive data: [yes — describe: financial records / PII / health data / etc.]

For every file in this repository, assign a vulnerability likelihood score:

1 = No vulnerability possible (constants, type definitions, static config, test fixtures)
2 = Low likelihood (pure UI components, static content, CSS, formatting)  
3 = Medium (business logic, data transformation, utility functions, validation)
4 = High (authentication, authorization, database queries, data access layers)
5 = Critical (raw input parsing, file upload/download, network-facing handlers, 
    payment processing, admin endpoints, auth token creation/validation, 
    direct SQL/ORM queries, webhook receivers, API key handling)

Output format — a table sorted by score (highest first):

| Score | File Path | One-Line Rationale | Attack Surface |
|-------|-----------|-------------------|----------------|

After the table, provide:
1. Your top 5 highest-risk files with a paragraph explaining WHY each is high-risk
2. The most likely attack chain you'd pursue if you were an attacker
3. Any architectural concerns visible from the file structure alone
```

### Prompt 1.2 — Dependency Deep Scan

```
Analyze every dependency in this project for security risk. Go beyond known CVEs — 
I want you to assess structural risk.

For each dependency, evaluate:
1. Does it have known CVEs? (check against your training data)
2. Is it actively maintained? (last release date, contributor count)
3. Does it have a small number of maintainers? (bus factor / supply chain risk)
4. Does it perform security-sensitive operations? (crypto, auth, parsing, network)
5. Does it have native/C bindings? (memory safety risk)
6. Is it a transitive dependency we might not know about?

Output format:

## Critical Risk Dependencies
[Any dependency with known CVEs or high structural risk]

## Elevated Risk Dependencies  
[Actively maintained but performs security-sensitive operations]

## Watch List
[Low maintainer count, infrequent updates, or approaching end-of-life]

## Clean
[No concerns identified]

For each Critical and Elevated risk dependency, recommend:
- Specific version to pin to
- Alternative packages if available
- Mitigations if no alternative exists
```

### Prompt 1.3 — Architecture Threat Model

```
Based on the codebase you've analyzed, construct a threat model.

Identify:

1. **Trust boundaries** — where does trusted input become untrusted? Where do 
   privilege levels change? Map every boundary.

2. **Data flows** — trace sensitive data (credentials, PII, financial data, tokens) 
   from entry to storage to retrieval to display. Identify every point where 
   the data crosses a trust boundary.

3. **Entry points** — every way an external actor can send input to this system:
   - HTTP endpoints (list each with method and auth requirement)
   - WebSocket connections
   - Webhook receivers
   - File upload endpoints
   - CLI arguments (if applicable)
   - Environment variables consumed at runtime
   - Database queries that accept user-influenced parameters

4. **Privilege levels** — map every role/permission level and what each can access.
   Identify any endpoint where privilege checks might be missing or bypassable.

5. **External dependencies** — every external service this system calls. For each:
   - What credentials are used?
   - Is the connection encrypted?
   - Is the response validated?
   - What happens if the service is compromised?

Output a structured threat model with a prioritized list of the 10 highest-risk 
areas to investigate first.
```

---

## Phase 2: Authentication and Authorization (Hours 2-4)

### Prompt 2.1 — Authentication Flow Audit

```
Perform an exhaustive security audit of every authentication flow in this codebase.

Examine each of the following. For each, tell me if it exists, how it works, and 
any vulnerabilities you find:

1. **Login flow**
   - How are credentials validated?
   - Is there rate limiting on login attempts?
   - Are timing side-channels possible? (can an attacker distinguish "user exists" 
     from "wrong password" based on response time?)
   - What happens on failed login? (error messages, lockout policy)
   - Is the password compared using constant-time comparison?

2. **Signup/registration flow**
   - Can an attacker enumerate existing users via the signup endpoint?
   - Is email verification required before account activation?
   - Are there restrictions on email domains or disposable emails?
   - Can an attacker create an admin account?

3. **Password reset flow**
   - Is the reset token cryptographically random and sufficiently long?
   - Does the token expire? How quickly?
   - Is the token single-use?
   - Can an attacker enumerate users via the reset endpoint?
   - Is the reset link transmitted securely?

4. **Session management**
   - How are sessions created? (JWT, server-side session, cookie)
   - What's the session lifetime? Is it appropriate for the data sensitivity?
   - Is session fixation possible?
   - Are sessions invalidated on password change?
   - Is refresh token rotation implemented?
   - Can sessions be hijacked via XSS? (HttpOnly, Secure, SameSite flags)

5. **OAuth/SSO flows** (if applicable)
   - Is the state parameter validated?
   - Are redirect URIs validated strictly?
   - Is the ID token verified properly?
   - Are scopes minimized?

6. **API key / token authentication** (if applicable)
   - How are API keys generated? (sufficient entropy?)
   - Are keys stored hashed?
   - Can keys be rotated without downtime?
   - Are keys scoped to minimum permissions?

7. **MFA** (if applicable)
   - Can MFA be bypassed by hitting a different endpoint?
   - Are backup codes generated securely?
   - Is there a race condition in TOTP validation?

For every vulnerability found, provide:
- Severity (Critical / High / Medium / Low)
- Proof of concept (how to exploit it)
- Specific fix with code example
```

### Prompt 2.2 — Authorization Deep Dive

```
Audit every authorization check in this codebase. I want you to find any way 
to access data or perform actions without proper permission.

For every endpoint/function that requires authorization:

1. **Is the auth check present?** Some endpoints may have been added without 
   authorization middleware. Check every route definition.

2. **Is the auth check correct?** Common mistakes:
   - Checking authentication (is someone logged in?) but not authorization 
     (are they allowed to do THIS?)
   - IDOR vulnerabilities — can user A access user B's resources by changing 
     an ID in the URL/request?
   - Missing checks on related resources (can access the parent but also 
     access children they shouldn't see?)
   - Role checks that use string comparison instead of proper role hierarchy
   - Admin endpoints protected only by obscurity (not linked in UI but 
     accessible via direct URL)

3. **Can the auth check be bypassed?**
   - HTTP method switching (POST protected but PUT isn't?)
   - Parameter pollution
   - Path traversal in resource identifiers
   - Race conditions between auth check and resource access
   - Case sensitivity issues in role names
   - GraphQL query depth / alias abuse (if applicable)

4. **Row-Level Security** (if using Supabase/PostgreSQL RLS):
   - Are RLS policies enabled on ALL tables with user data?
   - Can RLS be bypassed via SECURITY DEFINER functions?
   - Are RLS policies on related tables consistent?
   - Test: can an authenticated user craft a query that returns 
     another user's data?

Output a table of every endpoint with:
| Endpoint | Method | Auth Required | Auth Check Present | Auth Check Correct | Issues |
```

---

## Phase 3: Input Processing and Injection (Hours 4-6)

### Prompt 3.1 — Injection Vulnerability Sweep

```
Perform a comprehensive injection vulnerability analysis of this codebase.

Trace every path where external input reaches a dangerous sink. External input 
includes: HTTP request parameters, headers, body, cookies, URL path segments, 
file uploads, webhook payloads, WebSocket messages, and any data read from the 
database that originated from user input.

Check for:

1. **SQL Injection**
   - Any raw SQL with string concatenation or template literals?
   - Any ORM calls that accept raw SQL fragments?
   - Second-order SQL injection (stored data used in later queries)?
   - Are parameterized queries used EVERYWHERE?

2. **NoSQL Injection** (if MongoDB, etc.)
   - Can query operators ($gt, $ne, $regex) be injected via user input?
   - Are object inputs validated for unexpected keys?

3. **Command Injection**
   - Any calls to exec(), spawn(), system(), or shell commands?
   - Are arguments passed as arrays (safe) or strings (dangerous)?
   - Can environment variables be influenced by user input?

4. **Path Traversal**
   - Any file operations (read, write, delete) using user-controlled paths?
   - Is ../../../etc/passwd possible?
   - Are symlinks followed?

5. **XSS (Cross-Site Scripting)**
   - Is user input rendered in HTML without escaping?
   - Are there dangerouslySetInnerHTML / v-html / [innerHTML] usages?
   - Is user input reflected in JavaScript contexts?
   - Are CSP headers properly configured?

6. **SSRF (Server-Side Request Forgery)**
   - Does the server make HTTP requests to user-provided URLs?
   - Can an attacker reach internal services (169.254.169.254, localhost)?
   - Are URL protocols restricted (no file://, no gopher://)?

7. **Template Injection**
   - Are user inputs passed to template engines?
   - Can server-side template injection achieve RCE?

8. **Header Injection**
   - Can user input end up in HTTP response headers?
   - CRLF injection possible?

9. **LDAP / XML / XPath Injection** (if applicable)

For each finding:
- Show the exact code path from input to dangerous sink
- Provide a proof-of-concept payload
- Rate severity
- Provide the specific fix
```

### Prompt 3.2 — File Upload and Processing

```
Audit all file upload and file processing functionality.

For each file upload endpoint:

1. **Upload validation**
   - Is file type validated server-side (not just client-side)?
   - Is validation based on content inspection (magic bytes), not just extension?
   - Can a .php, .jsp, .aspx, or .py file be uploaded and executed?
   - Is there a file size limit enforced server-side?
   - Can the filename be manipulated (path traversal via filename)?
   - Are null bytes in filenames handled?

2. **Storage security**
   - Are uploaded files stored outside the web root?
   - Are files served with Content-Disposition: attachment?
   - Are files served with the correct Content-Type (not guessed)?
   - Is there access control on who can retrieve uploaded files?
   - Can uploaded file URLs be enumerated?

3. **Processing risks**
   - If images are processed (resize, thumbnail): are there image parsing 
     vulnerabilities? (ImageMagick, Sharp, Pillow)
   - If documents are processed (PDF, DOCX): is there SSRF or XXE risk?
   - If archives are processed (ZIP): is there zip bomb or zip slip risk?
   - Can processing be used for denial of service? (huge files, decompression bombs)

4. **Metadata leakage**
   - Are EXIF tags stripped from uploaded images?
   - Do uploaded files retain metadata that could leak user information?
```

---

## Phase 4: Business Logic and Data Exposure (Hours 6-8)

### Prompt 4.1 — Business Logic Bugs

```
Analyze the business logic of this application for logic flaws that automated 
scanners would miss. These are the bugs that survive 27 years of review because 
they aren't simple memory corruption or injection — they're logical errors.

Look for:

1. **Race conditions**
   - Can two concurrent requests cause double-spending, double-booking, 
     or duplicate resource creation?
   - Are financial operations atomic? (check-then-act patterns are vulnerable)
   - Is there a TOCTOU (time-of-check-to-time-of-use) gap anywhere?

2. **State machine violations**
   - Can application state transitions be forced out of order?
   - Can a cancelled order be shipped? Can a refund be issued twice?
   - Can a user re-enter a completed workflow?

3. **Numeric handling**
   - Integer overflow/underflow in financial calculations?
   - Floating-point precision issues in money handling?
   - Negative quantity / negative price exploitation?
   - Division by zero?
   - Currency conversion rounding exploitation?

4. **Access control logic**
   - Can a user escalate privileges by modifying their own profile?
   - Can a free-tier user access paid features by manipulating requests?
   - Can an invited user gain more access than intended?
   - Can a deleted/disabled account still access resources?

5. **Data consistency**
   - Can partial failures leave data in an inconsistent state?
   - Are database transactions used where needed?
   - Can referential integrity be violated through the API?

6. **Rate limiting and abuse**
   - Can an attacker exhaust resources (email sending, SMS, API calls)?
   - Is there rate limiting on expensive operations?
   - Can trial/free tier abuse circumvent payment?

7. **Information leakage through behavior**
   - Do error messages reveal internal state?
   - Can response timing reveal whether a resource exists?
   - Do different error codes reveal different internal conditions?
   - Can enumeration attacks extract the user list?

For each logic bug found, explain the full attack scenario from the attacker's 
perspective and provide a specific fix.
```

### Prompt 4.2 — Data Exposure Audit

```
Trace every piece of sensitive data in this application and verify it's protected 
at every stage: input, processing, storage, retrieval, display, and deletion.

Sensitive data categories to trace:
- Passwords and password hashes
- API keys and secrets
- Session tokens and JWTs
- Personal Identifiable Information (PII): names, emails, SSN, addresses
- Financial data: account numbers, transaction details, tax information
- Health data (if applicable)
- Client/customer data

For each category, verify:

1. **In transit:** Is TLS enforced? Are there any HTTP (non-HTTPS) endpoints?
2. **At rest:** Is sensitive data encrypted in the database? With what algorithm?
3. **In memory:** Are secrets cleared from memory after use?
4. **In logs:** Does logging inadvertently capture sensitive data? Check every 
   log statement for PII, tokens, or credentials.
5. **In errors:** Do error messages or stack traces expose sensitive data?
6. **In backups:** Are backups encrypted?
7. **In URLs:** Is sensitive data ever passed in URL query parameters? 
   (These appear in browser history, server logs, referer headers)
8. **In client-side storage:** Is sensitive data stored in localStorage, 
   sessionStorage, or cookies without proper flags?
9. **On deletion:** When a user requests data deletion, is the data actually 
   removed from all locations (database, backups, caches, logs)?
10. **In API responses:** Are API responses over-fetching data? Does any 
    endpoint return more fields than the client needs?

Produce a data flow diagram for each sensitive data category showing where 
it enters, where it's stored, and where it exits the system. Flag any point 
where protection is insufficient.
```

---

## Phase 5: Infrastructure and Configuration (Hours 8-10)

### Prompt 5.1 — Configuration Security Review

```
Review all configuration files, environment variable usage, and deployment 
configuration for security issues.

Check:

1. **Environment variables**
   - Are all secrets in environment variables (not hardcoded)?
   - Are there any .env files committed to git? Check git history too.
   - Are there default/fallback values for secrets that would work in production?
   - Do any environment variables contain connection strings with passwords?

2. **CORS configuration**
   - Is Access-Control-Allow-Origin set to "*"? (dangerous for authenticated APIs)
   - Are credentials allowed with a wildcard origin?
   - Is the origin validated against a whitelist?

3. **HTTP security headers**
   - Content-Security-Policy present and restrictive?
   - X-Frame-Options or frame-ancestors set?
   - X-Content-Type-Options: nosniff?
   - Strict-Transport-Security (HSTS) with appropriate max-age?
   - Referrer-Policy set?
   - Permissions-Policy set?

4. **TLS/SSL**
   - Is TLS 1.2+ enforced?
   - Are weak cipher suites disabled?
   - Is certificate pinning implemented (mobile apps)?

5. **Docker/container security** (if applicable)
   - Is the container running as root?
   - Are there unnecessary capabilities granted?
   - Is the base image up to date?
   - Are secrets baked into the image?

6. **CI/CD security**
   - Are secrets exposed in build logs?
   - Can a PR modify CI configuration to exfiltrate secrets?
   - Are deployment credentials scoped to minimum permissions?
   - Are GitHub Actions / CI runners using pinned action versions?

7. **Database configuration**
   - Is the database accessible from the internet?
   - Are default credentials changed?
   - Is SSL required for database connections?
   - Are connection pool limits set to prevent DoS?

For each issue, rate severity and provide the specific configuration change needed.
```

### Prompt 5.2 — Network Attack Surface

```
Based on the deployment configuration and code you've reviewed, map the complete 
network attack surface.

For every network-accessible service:

1. What port does it listen on?
2. Is it intended to be public? 
3. What authentication is required?
4. What's the most damaging action an unauthenticated attacker could take?
5. What's the most damaging action an authenticated low-privilege user could take?

Check specifically for:
- Database ports exposed to the internet (5432, 3306, 6379, 27017)
- Admin panels without VPN/IP restriction
- Debug endpoints left in production (/debug, /metrics, /health with sensitive data)
- GraphQL introspection enabled in production
- Swagger/OpenAPI docs exposed in production
- WebSocket endpoints without authentication
- gRPC reflection enabled in production
- Internal microservice endpoints reachable from the internet

Produce a network map showing every listening service, its authentication 
requirement, and your risk assessment.
```

---

## Phase 6: Validation and Exploitation (Hours 10-12)

### Prompt 6.1 — Finding Validation

Run this for EVERY finding from Phases 2-5:

```
I have received the following security vulnerability report. Please perform 
rigorous validation:

[PASTE THE FINDING HERE]

Determine:

1. **Is this vulnerability real and reproducible?**
   - Write the exact steps to reproduce, including specific HTTP requests, 
     payloads, or code paths
   - If you cannot produce concrete reproduction steps, it may be a false positive

2. **Is the severity rating accurate?**
   - Consider: Can it be exploited remotely? Does it require authentication? 
     Does it require user interaction? What data is at risk?
   - Re-rate using CVSS 3.1 methodology if the original rating seems off

3. **Is this actually exploitable in this specific deployment context?**
   - A SQL injection behind an admin-only endpoint with MFA is different from 
     one on a public signup form
   - Consider what compensating controls exist (WAF, rate limiting, network 
     segmentation)

4. **What is the realistic impact?**
   - Best case for the attacker: what's the maximum damage?
   - Most likely exploitation: what would a typical attacker achieve?
   - Is data exfiltration possible? How much data?

Rate your confidence in this finding: HIGH (definitely real), MEDIUM (likely real 
but needs manual verification), LOW (possibly false positive).

If confidence is LOW, explain what additional testing would confirm or deny it.
```

### Prompt 6.2 — Exploit Chain Construction (Critical/High Only)

```
The following Critical/High vulnerabilities have been confirmed in our codebase.

[PASTE ALL CONFIRMED CRITICAL AND HIGH FINDINGS]

Now analyze these findings as an attacker would:

1. **Can any of these be chained together?** 
   A Medium-severity information disclosure + a Medium-severity IDOR might 
   chain into a Critical data breach. Look for chains.

2. **What is the worst-case attack scenario?**
   Starting from zero access, what's the most damaging path through these 
   vulnerabilities? Map it step by step.

3. **What would a sophisticated attacker do first?**
   Not just "exploit the Critical bug" — consider which vulnerability gives 
   the best foothold, what reconnaissance steps come first, and how an 
   attacker would maintain persistence.

4. **Develop proof-of-concept exploits** for each Critical finding.
   These MUST work in our isolated test environment.
   Do NOT test against production.
   The PoC should demonstrate the actual impact, not just crash the service.

5. **For each exploit, document exactly what defensive measures would detect 
   or prevent it:**
   - Would our WAF catch this?
   - Would our logging capture this?
   - Would rate limiting prevent this?
   - Would network segmentation contain this?
```

---

## Phase 7: Remediation Guidance (Hours 12+)

### Prompt 7.1 — Fix Generation

Run this for each confirmed vulnerability:

```
Generate a production-ready fix for the following vulnerability:

[PASTE THE CONFIRMED FINDING WITH EXPLOIT]

Requirements for the fix:
1. The fix must be minimal — change only what's necessary to eliminate the 
   vulnerability. Do not refactor surrounding code.
2. The fix must not break existing functionality. If it could, flag what 
   tests should be run.
3. The fix must follow the existing code style and patterns in this codebase.
4. Include a regression test that proves:
   a. The vulnerability existed (test would have failed before the fix)
   b. The vulnerability is now eliminated (test passes after the fix)
5. If the fix requires a database migration, provide it.
6. If the fix requires configuration changes, specify them exactly.

Output:
- The exact code changes (as a diff)
- The regression test
- Any deployment notes or migration steps
- Confirmation that the fix addresses the root cause, not just the symptom
```

### Prompt 7.2 — Post-Fix Verification

After applying fixes, run this final sweep:

```
I have applied security patches based on our audit findings. Please perform a 
verification pass:

1. **Re-scan every file that was modified** — did the fix introduce any new 
   vulnerabilities?

2. **Re-test every finding that was marked as fixed** — is the vulnerability 
   actually eliminated, or just made harder to exploit?

3. **Check for regression** — did any fix break an adjacent security control?
   (Example: fixing an XSS by encoding output might break a CSP that relied 
   on the previous output format)

4. **Look for patterns** — if we had one SQL injection, are there similar 
   patterns elsewhere we missed? The same developer who wrote the vulnerable 
   code likely wrote similar code in other files.

5. **Assess overall posture change** — given the vulnerabilities we found and 
   fixed, and the architecture of this application, what's our current risk 
   level? What's the single highest remaining risk?

Output:
- Verification status for each fix (Confirmed Fixed / Still Vulnerable / New Issue)
- Any new findings discovered during re-scan
- Updated risk assessment
- Recommended next actions
```

---

## Quick Reference: Which Prompts for Which Scan

| If your priority is... | Run these prompts |
|------------------------|-------------------|
| **First time? Start here** | Phase 0 (all 4 prompts) — fix basics before scanning |
| **I have 2 hours** | 0.1 (patch check) → 1.1 (triage) → 2.1 (auth) → 6.1 (validate) |
| **I have 4 hours** | 0.1 → 0.3 (credentials) → 1.1 → 2.1 → 2.2 (authz) → 3.1 (injection) → 6.1 |
| **I have 8 hours** | Phase 0 → Phases 1-4 → 6.1 |
| **I have a full day** | All phases, 0-7 |
| **Supabase app** | 0.1 → 0.2 → 1.1 → 2.2 (focus on RLS) → 3.1 → 4.2 → [supabase.md](../stacks/supabase.md) |
| **API-only backend** | 0.1 → 0.3 → 1.1 → 2.1 → 2.2 → 3.1 → 5.2 (network) |
| **Post-breach triage** | 0.4 (backups!) → 4.2 (data exposure) → 2.1 (auth) → 5.2 (network) → 6.2 (chains) |
| **Just checking the basics** | Phase 0 only — 4 prompts, covers patches, standards, credentials, backups |

---

## Tips for Maximum Effectiveness

1. **Run prompts in parallel where possible.** Phases 2 and 3 are independent — run them simultaneously if your API rate limits allow.

2. **Feed context forward.** Include the triage output (Prompt 1.1) as context in all subsequent prompts — it helps the model prioritize.

3. **Be specific about your stack.** The more context you give about your specific deployment (cloud provider, framework version, database type), the more targeted the findings.

4. **Don't skip validation (Phase 6).** False positives waste time and erode trust. Always validate before patching.

5. **Fix Critical findings immediately.** Don't wait to finish the full scan. If Prompt 2.1 finds a critical auth bypass, stop and fix it before continuing to Prompt 3.1.

6. **Save your credits for what Glasswing doesn't cover.** Your custom business logic, your specific configurations, your niche third-party integrations — that's where Mythos adds value you can't get from vendor patches.

---

*These prompts will be updated as the Mythos model's capabilities and best practices become better understood. Contributions welcome.*
