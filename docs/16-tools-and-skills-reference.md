# Tools and Skills Reference

**Every tool referenced in this repo, organized by when to use it.**

---

## Audit Scripts (Included in This Repo)

Run these first. They're in the `scripts/` directory.

| Script | Platform | What It Checks |
|--------|----------|---------------|
| `audit-windows.ps1` | Windows | Updates, BitLocker, Defender, firewall, SMBv1, Secure Boot, accounts, PowerShell logging |
| `audit-linux.sh` | Linux | Kernel, updates, ports, SSH config, firewall, SUID binaries, users, cron, fail2ban |
| `audit-network.sh` | Any (external) | Port exposure, email security (SPF/DKIM/DMARC), TLS certificate, HTTP security headers |
| `audit-dependencies.sh` | Any (project) | npm audit, pip audit, Docker scan, secrets scan, .gitignore safety, system packages |
| `check-cisa-kev.sh` | Any | Latest CISA Known Exploited Vulnerabilities, Mythos CVE tracking, due date monitoring |

```bash
# Run Linux audit
sudo bash scripts/audit-linux.sh

# Run network audit (provide your public IP and domain)
bash scripts/audit-network.sh 203.0.113.50 yourdomain.com

# Run dependency audit on a project
bash scripts/audit-dependencies.sh /path/to/your/project

# Check CISA KEV catalog (optionally filter by vendor)
bash scripts/check-cisa-kev.sh microsoft
```

```powershell
# Run Windows audit (as Administrator)
powershell -ExecutionPolicy Bypass -File scripts\audit-windows.ps1
```

---

## Trail of Bits Security Skills (for Claude Code Users)

If you use Claude Code, these skills from [Trail of Bits](https://github.com/trailofbits/skills) provide deep security analysis. Install them following the Trail of Bits instructions, then invoke via slash command.

### Phase 0: Baseline Verification

| Skill | What It Does | Invoke |
|-------|-------------|--------|
| `security:insecure-defaults` | Detects fail-open defaults, hardcoded secrets, weak auth, permissive configs | `/securityinsecure-defaults` |
| `security:audit-prep-assistant` | Prepares codebase for security review using Trail of Bits' checklist | `/securityaudit-prep-assistant` |
| `code-maturity-assessor` | Trail of Bits 9-category security maturity framework | `/code-maturity-assessor` |
| `security:supply-chain-risk-auditor` | Identifies dependencies at risk of exploitation or takeover | `/securitysupply-chain-risk-auditor` |
| `security:gha-security-review` | Reviews GitHub Actions workflows for security vulnerabilities | `/securitygha-security-review` |
| `security:claude-settings-audit` | Recommends Claude Code permission settings for the repo | `/securityclaude-settings-audit` |

### Phase 1-5: Active Scanning

| Skill | What It Does | Invoke |
|-------|-------------|--------|
| `security:find-bugs` | Find bugs, vulnerabilities, and code quality issues in local changes | `/securityfind-bugs` |
| `security:security-review` | Full security code review for vulnerabilities | `/securitysecurity-review` |
| `security:sharp-edges` | Identifies error-prone APIs and dangerous design patterns | `/securitysharp-edges` |
| `security:codeql` | Interprocedural data flow and taint tracking (deep analysis) | `/securitycodeql` |
| `semgrep` | Parallel static analysis across multiple rule sets | `/semgrep` |
| `security:audit-context-building` | Ultra-granular line-by-line analysis for architectural context | `/securityaudit-context-building` |
| `security:entry-point-analyzer` | Identifies all state-changing entry points for audit targeting | `/securityentry-point-analyzer` |
| `security-advisor-universal` | Comprehensive security audit for any codebase | `/security-advisor-universal` |

### Phase 6: Validation

| Skill | What It Does | Invoke |
|-------|-------------|--------|
| `security:fp-check` | Verifies suspected bugs to eliminate false positives — produces TRUE POSITIVE or FALSE POSITIVE verdict | `/securityfp-check` |
| `security:variant-analysis` | After finding one bug, hunts for similar patterns across the codebase | `/securityvariant-analysis` |
| `security:differential-review` | Security-focused review of code changes — use when reviewing Mythos-suggested patches | `/securitydifferential-review` |

### Specialized

| Skill | When to Use |
|-------|------------|
| `security:constant-time-analysis` | If your code handles cryptographic operations |
| `security:property-based-testing` | For thorough testing of complex business logic |
| `security:mutation-testing` | To assess how well your test suite catches bugs |
| `security:sarif-parsing` | To process CodeQL or Semgrep SARIF output |
| `security:semgrep-rule-creator` | To write custom detection rules for your codebase |

---

## Snyk MCP Tools (for Claude Code Users)

If your Claude Code environment has Snyk MCP configured, these tools are available:

| Tool | Purpose | Command |
|------|---------|---------|
| `snyk_code_scan` | SAST — finds vulnerabilities in first-party code | Invoked via Claude Code MCP |
| `snyk_sca_scan` | Dependency scanning — finds vulnerable packages | Invoked via Claude Code MCP |
| `snyk_iac_scan` | IaC scanning — Terraform, CloudFormation, Dockerfiles, K8s | Invoked via Claude Code MCP |
| `snyk_container_scan` | Container image vulnerability scanning | Invoked via Claude Code MCP |
| `snyk_sbom_scan` | Software Bill of Materials generation | Invoked via Claude Code MCP |

**Best practice:** Run Snyk scans on all code before Mythos scanning. Fix what Snyk finds first — don't waste Mythos credits on issues current tools can catch.

---

## Open Source Scanning Tools

Install and run these independently:

### Code Analysis

| Tool | What | Install | Use For |
|------|------|---------|---------|
| **Semgrep** | Pattern-based static analysis | `pip install semgrep` | Multi-language code scanning |
| **TruffleHog** | Secrets detection in code + git history | `brew install trufflehog` | Finding leaked credentials |
| **Bandit** | Python security linter | `pip install bandit` | Python projects |
| **ESLint Security** | JS/TS security rules | `npm i eslint-plugin-security` | JavaScript/TypeScript |
| **Brakeman** | Ruby/Rails security scanner | `gem install brakeman` | Ruby projects |

### Privilege Escalation and Post-Compromise Assessment (Advanced)

These tools go beyond baseline configuration checks. They identify how an attacker who already has a foothold could escalate privileges and move laterally. Use in test environments or with EDR exceptions — most endpoint protection will block these tools.

| Tool | What | Install | Use For |
|------|------|---------|---------|
| **PEASS-ng** (LinPEAS / WinPEAS) | Privilege escalation path scanner for Linux, Windows, and macOS | [github.com/peass-ng/PEASS-ng](https://github.com/peass-ng/PEASS-ng) | Finding misconfigurations an attacker could use to go from regular user to admin/root. Checks hundreds of escalation vectors: writable services, weak permissions, stored credentials, kernel exploits, scheduled task abuse, and more. |
| **BloodHound** | Active Directory attack path mapper | [github.com/BloodHoundAD](https://github.com/BloodHoundAD/BloodHound) | Visualizing AD privilege escalation paths. Not relevant unless you have on-prem Active Directory. |

**Important:** These are offensive security tools used defensively. They will trigger EDR alerts. Run them in isolated test environments, not on production machines, unless you've coordinated with your security team to whitelist them.

### Infrastructure and Network

| Tool | What | Install | Use For |
|------|------|---------|---------|
| **nmap** | Port scanning | `apt install nmap` | Finding exposed services |
| **Trivy** | Vuln scanner (containers, filesystems, repos) | `brew install trivy` | Container + dependency scanning |
| **Grype** | Container image vulnerability scanner | `brew install grype` | Fast container scanning |
| **OpenVAS/Greenbone** | Network vulnerability scanner | Docker image | Network-wide scanning |
| **OWASP ZAP** | Web app dynamic scanner | Docker image | Testing running web apps |
| **WPScan** | WordPress vulnerability scanner | `gem install wpscan` | WordPress sites |
| **testssl.sh** | TLS configuration testing | `git clone testssl.sh` | Verifying TLS setup |

### Dependency Auditing

| Tool | What | Install | Use For |
|------|------|---------|---------|
| **npm audit** | Node.js dependency audit | Built into npm | Node.js projects |
| **pip-audit** | Python dependency audit | `pip install pip-audit` | Python projects |
| **cargo audit** | Rust dependency audit | `cargo install cargo-audit` | Rust projects |
| **bundler-audit** | Ruby dependency audit | `gem install bundler-audit` | Ruby projects |

---

## Free External Verification Services

No installation required — use via web browser:

| Service | URL | What It Checks |
|---------|-----|---------------|
| **Qualys SSL Labs** | ssllabs.com/ssltest | TLS config, ciphers, certificate chain, protocol support |
| **SecurityHeaders.com** | securityheaders.com | HTTP security headers (CSP, HSTS, X-Frame-Options) |
| **MXToolbox** | mxtoolbox.com | SPF, DKIM, DMARC, mail server config, DNS health |
| **Have I Been Pwned** | haveibeenpwned.com | Email addresses in known data breaches |
| **Shodan** | shodan.io | What's publicly visible about your IP address |
| **Censys** | search.censys.io | Internet-wide scanning data for your assets |
| **VirusTotal** | virustotal.com | File, URL, and domain reputation |
| **DNSViz** | dnsviz.net | DNSSEC validation chain visualization |

---

## Recommended Scanning Sequence

### Pre-Mythos (Do Now)

1. Run repo audit scripts (Windows, Linux, network, dependencies)
2. Run Snyk scans (code, SCA, IaC, container)
3. Run Trail of Bits baseline skills (insecure-defaults, supply-chain-risk-auditor, audit-prep-assistant)
4. Run external verification services (SSL Labs, SecurityHeaders, MXToolbox, HIBP)
5. Fix everything found
6. Rescan to verify fixes

### Mythos Day 1

1. Run Phase 0 prompts (baseline re-verification)
2. Run Phase 1-5 prompts (deep scanning with Mythos)
3. Validate findings with Trail of Bits fp-check
4. Hunt variants with Trail of Bits variant-analysis
5. Review patches with Trail of Bits differential-review
6. Rescan after fixes with Snyk + Mythos

---

*This reference is updated as new tools become available. Contributions welcome.*
