# SMALL BUSINESS RESPONSE PLAN: THE POST-MYTHOS THREAT LANDSCAPE

**Date:** April 11, 2026 (last updated April 17, 2026)
**Prepared by:** [mythos-launch-response](https://github.com/CJCPAs/mythos-launch-response) community
**Audience:** Small and medium businesses (1-250 employees)
**License:** CC BY 4.0 — share freely
**Version:** 1.4

---

## NOTICE TO READER

On April 7, 2026, Anthropic (an AI company) disclosed that their AI model "Claude Mythos Preview" can autonomously discover and exploit security vulnerabilities in every major operating system and web browser. This document explains what this means for your business and what you should do about it.

**This is not hype. This is not theoretical.** The U.S. Treasury Secretary and Federal Reserve Chair have held emergency meetings with bank CEOs. The IMF has expressed concern. Major tech companies have formed an emergency coalition (Project Glasswing) to patch vulnerabilities before attackers exploit them.

**Small businesses are not directly protected by these efforts.** This plan is for you.

---

## 1. WHAT HAPPENED (Plain Language)

### The Short Version

An AI system proved it can find security holes in software — holes that human experts missed for up to 27 years — and build working attacks automatically, at a cost of as little as **$50 per vulnerability**. Previously, this kind of work required elite hackers or nation-state intelligence agencies with million-dollar budgets.

### Why This Matters to Your Business

| Before | After |
|--------|-------|
| Hackers needed rare expertise to find new vulnerabilities | AI can find them cheaply and quickly |
| Small businesses were low-priority targets | AI enables attacking thousands of businesses simultaneously |
| You had days or weeks to install security updates | Attacks can now be developed within hours of a vulnerability being found |
| Most attacks used old, known techniques | Fresh, previously unknown attacks become affordable |
| Human hackers had limited bandwidth | AI-assisted attackers can operate at machine speed and scale |

### The Bottom Line

**The cost of attacking you just dropped dramatically. Your defenses need to rise proportionally.**

---

## 2. RISK ASSESSMENT: ARE YOU A TARGET?

### Who Should Be Most Concerned

**HIGH RISK — Act Immediately:**
- Businesses handling financial data (accounting firms, bookkeepers, financial advisors)
- Healthcare providers (patient records, HIPAA obligations)
- Legal firms (client privileged information)
- Businesses processing credit card payments
- Anyone with internet-facing servers or applications
- Businesses using legacy/outdated software that can't be updated

**MEDIUM RISK — Act Within 30 Days:**
- Businesses with remote employees accessing company resources
- Businesses using cloud services for sensitive data
- Retail businesses with point-of-sale systems
- Businesses relying on email for sensitive communications

**ALL BUSINESSES — Act Within 90 Days:**
- If you use computers, you are affected. The vulnerabilities discovered span every major operating system and web browser.

---

## 3. IMMEDIATE ACTIONS (This Week)

These cost little or nothing and dramatically reduce your risk.

### 3.1 Turn On Automatic Updates — EVERYWHERE

**Why:** AI can now generate attacks for newly discovered vulnerabilities within hours. You cannot afford to delay updates.

**What to do:**
- [ ] **Windows:** Settings > Update & Security > Enable automatic updates
- [ ] **Mac:** System Preferences > Software Update > Enable automatic updates
- [ ] **Browsers:** Chrome, Firefox, Edge, Safari — all should auto-update (verify settings)
- [ ] **Phones/tablets:** Enable automatic app and OS updates
- [ ] **Business software:** Contact vendors to confirm auto-update is enabled
- [ ] **Router/firewall firmware:** Check for updates monthly (many don't auto-update)

**A note on auto-updates for businesses with specialized software:** Auto-updates for operating systems and browsers are almost always the right call. However, if you run line-of-business applications (industry-specific software, custom integrations, or legacy systems), be aware that OS updates can occasionally break compatibility. If your business depends on specialized software, work with your IT provider to test critical updates in a staging environment before deploying to all machines. The risk of a bad update breaking your workflow is real — but the risk of an unpatched zero-day is usually worse. Don't use this caveat as a reason to avoid patching entirely.

### 3.2 Enable Multi-Factor Authentication (MFA) on Everything

**Why:** Even if a password is stolen, MFA prevents unauthorized access. It's the single most effective defense.

**Priority order:**
- [ ] **Email accounts** (this is #1 — email is the keys to the kingdom)
- [ ] **Banking and financial services**
- [ ] **Cloud storage** (Google Drive, Dropbox, OneDrive, etc.)
- [ ] **Accounting/ERP software**
- [ ] **Social media accounts** (used for business impersonation attacks)
- [ ] **VPN or remote access**
- [ ] **Domain registrar** (prevents website hijacking)

**Best options (in order):** Hardware security key > Authenticator app (Google/Microsoft Authenticator) > SMS codes (last resort)

### 3.3 Password Audit

**Why:** AI-assisted attackers will exploit credential reuse at scale.

- [ ] **Deploy a password manager** for the entire organization (Bitwarden, 1Password, etc. — $3-8/user/month)
- [ ] **Eliminate all password reuse** — every account gets a unique password
- [ ] **Minimum 16 characters** for all passwords
- [ ] **Check for compromised passwords** at haveibeenpwned.com
- [ ] **Disable any unused accounts** across all services

### 3.4 Identify Your Internet-Facing Assets

**Why:** Anything accessible from the internet is your front door. AI-assisted attackers will scan and probe every door.

- [ ] **List every service accessible from the internet** (website, email server, VPN, remote desktop, security cameras, etc.)
- [ ] **Ask:** Does each of these NEED to be internet-facing? If not, take it offline or put it behind a VPN.
- [ ] **Disable Remote Desktop Protocol (RDP)** if exposed to the internet — this is one of the most exploited attack vectors
- [ ] **Review firewall rules** — close any ports that aren't actively needed

---

## 4. SHORT-TERM ACTIONS (Weeks 2-8)

### 4.1 Backup Your Data (Properly)

**Why:** When attacks become cheaper, ransomware becomes cheaper. Your backups are your last line of defense.

**The 3-2-1 Rule:**
- **3** copies of your data
- **2** different types of storage (e.g., cloud + external hard drive)
- **1** copy completely disconnected from your network (air-gapped)

**Action items:**
- [ ] **Verify your backups actually work** — restore a file or folder to test
- [ ] **Set up an air-gapped backup** — an external drive stored offsite, disconnected from everything
- [ ] **Use separate credentials for backup systems** — backup accounts should NOT use the same passwords or domain accounts as your production environment. If an attacker compromises your main credentials, your backups should still be safe.
- [ ] **Keep backup storage off your domain** — backup drives or cloud storage should not be joined to your company network/domain
- [ ] **Automate daily backups** for critical data
- [ ] **Encrypt your backups** with a strong password
- [ ] **Document your recovery procedure** — who does what if everything goes down?

### 4.2 Email Security

**Why:** AI makes phishing emails indistinguishable from legitimate ones. Traditional "look for typos" advice is now useless.

**New rules:**
- [ ] **Verify financial requests through a separate channel** — if someone emails asking for a wire transfer, call them at a known number to confirm
- [ ] **Enable advanced email filtering** — ask your email provider about AI-based phishing detection
- [ ] **Implement DMARC/DKIM/SPF** on your email domain — prevents email spoofing of your business (your IT person or email provider can set this up)
- [ ] **Train staff:** The rule is now "verify everything sensitive through a second channel" — not "look for suspicious emails"

### 4.3 Network Basics

- [ ] **Separate your guest Wi-Fi** from your business network
- [ ] **Change default passwords** on ALL network equipment (routers, switches, printers, security cameras)
- [ ] **Segment sensitive systems** — your accounting system should not be on the same network segment as your lobby Wi-Fi

### 4.4 Develop an Incident Response Plan

You need to know what to do BEFORE something happens. A basic plan:

1. **Who is in charge?** Designate one person as incident commander.
2. **Who do we call?**
   - IT support / managed service provider
   - Cyber insurance carrier (if applicable)
   - Legal counsel
   - Law enforcement (FBI IC3: ic3.gov)
3. **How do we contain it?** Know how to disconnect systems from the network.
4. **How do we communicate?** Have a phone tree that doesn't depend on email (in case email is compromised).
5. **What are our legal obligations?** Know your state's data breach notification laws.

---

## 5. MEDIUM-TERM ACTIONS (Months 2-6)

### 5.1 Get Cyber Insurance (or Review Existing Coverage)

**Critical context:** Forrester Research warns that cyber insurers will likely add exclusions for AI-discovered vulnerabilities that aren't remediated within defined timeframes. Insurance repricing will be "abrupt, not gradual."

**Action items:**
- [ ] **If you don't have cyber insurance:** Get it now, before premiums adjust
- [ ] **If you do:** Review your policy for exclusions around unpatched vulnerabilities, AI-related incidents, and "acts of war" clauses
- [ ] **Document your security improvements** — this directly affects your premiums
- [ ] **Ask your carrier** what their response plan is for AI-accelerated threats

### 5.2 Vendor Assessment

Your vendors are your attack surface.

- [ ] **List every third-party service** that has access to your data
- [ ] **Ask critical vendors:** What is your patch cadence? Do you have a vulnerability management program?
- [ ] **Review contracts** for breach notification obligations
- [ ] **Identify single points of failure** — what happens if your cloud provider or SaaS tool is compromised?

### 5.3 Consider Managed Security Services

If you don't have dedicated IT security staff (most SMBs don't), consider:

- [ ] **Managed Detection and Response (MDR)** — 24/7 security monitoring ($3,000-$10,000/year for SMB)
- [ ] **Endpoint Detection and Response (EDR)** — advanced endpoint protection beyond traditional antivirus ($5-15/device/month)
- [ ] **Managed firewall services** — professional firewall management
- [ ] **Virtual CISO services** — part-time security leadership ($2,000-$5,000/month)

### 5.4 Staff Training (Updated for AI Threats)

Traditional security awareness training is insufficient. Update training to cover:

- [ ] **AI-generated phishing** — perfect grammar, perfect context, indistinguishable from real emails
- [ ] **Voice deepfakes** — an AI can clone your boss's voice from a 3-second sample
- [ ] **Video deepfakes** — verify unusual video call requests through a separate channel
- [ ] **Social engineering at scale** — AI enables personalized attacks against every employee simultaneously
- [ ] **The new rule: "Verify, don't trust"** — establish out-of-band verification for ANY sensitive request

---

## 6. WHAT TO WATCH FOR

### Signs You May Be Compromised

- Unexpected password reset emails
- Accounts locked out without your action
- Unfamiliar devices appearing in your account activity
- Unusual network traffic or slow system performance
- Files encrypted or renamed with strange extensions (ransomware)
- Unexpected software installed on your systems
- Emails sent from your accounts that you didn't write
- Unusual financial transactions

### Information Sources to Monitor

| Source | What | How Often |
|--------|------|-----------|
| CISA.gov/alerts | Government cybersecurity advisories | Weekly |
| Your software vendors | Security update announcements | As released |
| Your cyber insurance carrier | Policy updates, guidance | Monthly |
| Your IT provider / MSP | Threat briefings | Monthly |
| haveibeenpwned.com | Credential compromise monitoring | Monthly |

---

## 7. COST GUIDE

### Costs of Defense

| Action | Cost | Priority |
|--------|------|----------|
| Enable auto-updates everywhere | FREE | Do now |
| Enable MFA everywhere | FREE - $6/user/month | Do now |
| Password manager (team) | $3-8/user/month | Do now |
| External backup drive (air-gapped) | $100-500 one-time | Week 1 |
| Cloud backup service | $10-50/month | Week 1 |
| DMARC/DKIM/SPF setup | FREE - $500 | Week 2 |
| EDR (replaces basic antivirus) | $5-15/device/month | Month 1 |
| Staff security training | $20-50/user/year | Month 1 |
| Cyber insurance | $1,000-5,000/year (varies by industry) | Month 1 |
| MDR (managed detection) | $3,000-10,000/year | Month 2 |
| Penetration test | $5,000-20,000 (annual) | Month 3 |
| Virtual CISO | $2,000-5,000/month | Month 3 |

**Total minimum defensible posture:** ~$5,000-15,000/year for a 10-person business

### Costs of NOT Defending

| Incident | Average Cost (SMB) |
|----------|-------------------|
| Ransomware attack | $150,000 - $500,000 |
| Business email compromise | $25,000 - $200,000 per incident |
| Data breach (with notification) | $120,000 - $400,000 |
| Business downtime (per day) | $10,000 - $50,000 |
| Regulatory fine (HIPAA, PCI, etc.) | $50,000 - $1,500,000 |
| Reputation damage | Incalculable |

**The math is clear: defense costs are a fraction of incident costs.**

---

## 8. FREQUENTLY ASKED QUESTIONS

### "Am I really a target?"

Yes. AI enables mass targeting. Attackers don't need to specifically choose your business — they can scan and attack thousands of businesses simultaneously. You don't have to be valuable enough to target individually; you just have to be vulnerable enough to attack cheaply.

### "I use Mac/Linux, am I safe?"

No. Mythos found vulnerabilities in EVERY major operating system. No platform is exempt.

### "I have antivirus software, isn't that enough?"

No. Traditional antivirus catches known threats. AI-discovered zero-day vulnerabilities are, by definition, unknown. You need Endpoint Detection and Response (EDR) that detects malicious behavior patterns, not just known signatures.

### "I'm too small for hackers to bother with."

This was already a myth. It's now dangerously false. AI makes the cost of attacking small businesses approach zero. The FBI's IC3 reports that small businesses account for the majority of cybercrime victims by count.

### "Should I panic?"

No. You should act. The defensive measures in this plan are practical, affordable, and effective. The businesses that will be hit hardest are the ones that do nothing.

### "What is Project Glasswing? Will it protect me?"

Project Glasswing is Anthropic's coalition with major tech companies to patch vulnerabilities in major software (Windows, macOS, Linux, Chrome, Firefox, etc.). It WILL help you indirectly by making the platforms you use more secure. It will NOT scan your specific systems, protect your custom software, or shorten your patch cycles.

### "When will AI-assisted attacks actually happen?"

They already are. AI-enhanced phishing and social engineering have been documented since 2024. Fully autonomous AI-driven exploitation at Mythos scale is likely within months to a few years for capable threat actors. Don't wait for the first headline.

---

## 9. RESOURCES

| Resource | URL | Purpose |
|----------|-----|---------|
| CISA Cybersecurity Guidance | cisa.gov/cybersecurity | Government advisories and guidance |
| FBI Internet Crime Complaint Center | ic3.gov | Report cybercrime |
| Have I Been Pwned | haveibeenpwned.com | Check for compromised credentials |
| NIST Cybersecurity Framework | nist.gov/cyberframework | Comprehensive security framework |
| SBA Cybersecurity Guide | sba.gov/cybersecurity | Small business specific guidance |
| FTC Cybersecurity Resources | ftc.gov/cybersecurity | Regulatory guidance for businesses |

---

## 10. HOW THIS MAPS TO INDUSTRY CONSENSUS

On April 14, 2026, SANS Institute, the Cloud Security Alliance, [un]prompted, and OWASP GenAI Security Project jointly released an emergency strategy briefing with 11 priority actions for post-Mythos security. The full framework is in [docs/17-industry-consensus-framework.md](17-industry-consensus-framework.md). For an SMB, the 11 actions collapse to **five practical moves**, each backed by a section of this plan:

| Framework Action | This Plan's Section | Why It Maps |
|------------------|---------------------|-------------|
| **PA1** Point AI agents at your code | §3.4 + [14-defensive-ai-scanning.md](14-defensive-ai-scanning.md) | Free AI security reviews with generally-available models |
| **PA2 + PA4** Require AI adoption / governance | §5.3 Managed Security Services | For most SMBs, "AI adoption" = hiring an MDR that already uses it |
| **PA5 + PA6** Continuous patching + updated risk models | §3.1 Auto-updates + §6 What to Watch For | Auto-updates are your continuous-patching program |
| **PA7 + PA8** Inventory + hardening | §3.4 Internet-facing inventory + §4.3 Network segmentation + §4.4 IR plan | Builds what industry consensus now mandates |
| **PA9 + PA10** Deception + automated response | [18-honeytokens-deception.md](18-honeytokens-deception.md) + §5.3 MDR | 90-day deployment path with free tools |

**One practical implication:** industry consensus now treats **honeytokens as a required capability**, not optional. See [docs/18-honeytokens-deception.md](18-honeytokens-deception.md) for a free starter deployment you can complete this month.

**What industry consensus says about AI access:** Anthropic launched Claude Opus 4.7 and the Cyber Verification Program on April 16, 2026. For SMBs who want to do AI-assisted security work, the CVP is the real path — Opus 4.7 costs $5/$25 per million tokens and is officially blessed for vulnerability research and pentesting. See [docs/12-supply-chain-safety.md](12-supply-chain-safety.md) for the full breakdown.

---

## 11. ABOUT THIS DOCUMENT

This response plan was developed as a community resource because small businesses deserve access to clear, actionable security guidance. It is based on analysis of:

- Anthropic's official Mythos Preview and Project Glasswing disclosures
- U.S. government and regulatory responses
- Independent security research (AISLE, Wiz, Check Point, Corelight, Elisity)
- Industry analysis (Forrester Research, Fortune, SecurityWeek)
- Expert commentary (Bruce Schneier, Alissa Valentina Knight, and others)
- NIST Cybersecurity Framework 2.0 and NIST IR 8596 (AI Cybersecurity Profile)

**This document may be freely shared.** We believe every small business deserves access to clear, actionable security guidance.

---

*mythos-launch-response | Community Security Resource*
*Last updated: April 17, 2026*
*Review cycle: Monthly or upon significant threat landscape change*
