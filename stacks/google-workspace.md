# Google Workspace Security Hardening Guide

**For organizations using Google Workspace for email, files, and identity in the post-Mythos era.**

Google Workspace (formerly G Suite) runs email, docs, and identity for millions of small businesses. Google is a Glasswing founding partner — they're scanning their code. But your configuration is on you.

---

## 1. Identity and Authentication

### MFA Enforcement

- [ ] **Enforce 2-Step Verification for all users**
  - Admin console → Security → 2-Step Verification → Enforcement → Turn on enforcement
  - Set enrollment period (grace period for users to set up MFA)
  - After grace period: users without MFA are locked out
- [ ] **Require phishing-resistant MFA for admins** (security keys)
  - Admin console → Security → 2-Step Verification → Allowed methods → Security keys only (for admin OU)
- [ ] **Disable less secure app access** (legacy protocols that bypass MFA)
  - Admin console → Security → Less secure apps → Disable access for all users

### Advanced Protection Program

For high-risk users (CEO, CFO, controller, anyone with financial authority):

- [ ] Enroll in Google Advanced Protection Program
  - Requires hardware security keys (YubiKey or Titan)
  - Blocks all third-party app access unless explicitly allowed
  - Enhanced download scanning in Chrome
  - Strictest account recovery process

### Admin Account Security

- [ ] Super Admin accounts have hardware security keys (not TOTP)
- [ ] Super Admin accounts are dedicated (not daily-use accounts)
- [ ] Review admin roles: Admin console → Account → Admin roles
- [ ] Remove unnecessary admin privileges — use least-privilege roles
- [ ] Verify recovery options on Super Admin accounts are secured

### User Access Review

- [ ] Disable suspended/inactive user accounts
  - Admin console → Users → Filter by "Last sign in"
- [ ] Review third-party app access:
  - Admin console → Security → API Controls → App Access Control
  - Block high-risk apps, review all authorized apps
- [ ] Review OAuth app grants users have approved
  - Admin console → Reporting → Accounts → Third-party app OAuth tokens

---

## 2. Email Security (Gmail)

### Anti-Phishing and Malware

- [ ] **Advanced phishing and malware protection** enabled:
  - Admin console → Apps → Google Workspace → Gmail → Safety
  - Attachments: Enable "Protect against encrypted attachments from untrusted senders"
  - Links and external images: Enable "Identify links behind shortened URLs" and "Scan linked images"
  - Spoofing: Enable all spoofing protection options
- [ ] **External email warning** enabled — shows banner on emails from outside org
- [ ] **Enhanced pre-delivery message scanning** enabled

### DMARC / DKIM / SPF

- [ ] **SPF record** in DNS:
  ```
  v=spf1 include:_spf.google.com -all
  ```
- [ ] **DKIM signing** enabled:
  - Admin console → Apps → Google Workspace → Gmail → Authenticate email → Generate new record → Add to DNS → Start authentication
- [ ] **DMARC record** in DNS:
  ```
  v=DMARC1; p=reject; rua=mailto:dmarc-reports@yourdomain.com; pct=100
  ```

### Email Routing Audit

- [ ] No unauthorized email forwarding rules:
  - Admin console → Apps → Google Workspace → Gmail → Routing → Review all rules
- [ ] No mailbox delegation to unknown accounts
- [ ] Audit email auto-forwarding:
  - Admin console → Apps → Google Workspace → Gmail → Auto-forwarding → Disable auto-forwarding (recommended) or monitor

---

## 3. File Security (Google Drive)

### Sharing Controls

- [ ] **External sharing** restricted:
  - Admin console → Apps → Google Workspace → Drive → Sharing settings
  - Recommended: "Allowlisted domains" or "Users in [org] only"
- [ ] **Link sharing default** set to "Restricted" (not "Anyone with the link")
- [ ] **Shared drive creation** restricted to admins
- [ ] **Guest access** to shared drives disabled or restricted

### File Audit

- [ ] Review externally shared files:
  - Drive audit log: Admin console → Reporting → Audit and investigation → Drive log events
  - Filter: Visibility = "Shared externally"
- [ ] Review files shared with "Anyone on the internet"
- [ ] Revoke stale external sharing (files shared with former clients, partners, etc.)

### Data Loss Prevention (DLP)

- [ ] DLP rules configured for sensitive data patterns:
  - Admin console → Security → Data Protection → Manage rules
  - Block or warn on: SSN patterns, credit card numbers, tax ID patterns
  - Apply to Gmail and Drive

---

## 4. Device Management

- [ ] **Endpoint management** enabled:
  - Admin console → Devices → Mobile & endpoints → Settings
  - Require screen lock on all devices
  - Enable device approval (admin must approve new devices)
  - Enable remote wipe capability
- [ ] **Context-Aware Access** policies (if on Enterprise plan):
  - Block access from unmanaged devices to sensitive apps
  - Require device encryption
  - Require OS minimum version

---

## 5. Monitoring and Alerts

- [ ] **Alert Center** configured:
  - Admin console → Security → Alert Center
  - Enable alerts for: suspicious login activity, government-backed attacks, Gmail phishing, device compromised
- [ ] **Admin audit log** reviewed monthly:
  - Admin console → Reporting → Audit and investigation → Admin log events
  - Look for: role changes, new users, policy changes, app authorizations
- [ ] **Login audit** monitored:
  - Filter for: suspicious logins, failed attempts, logins from new locations
- [ ] **Security investigation tool** used for incident response:
  - Admin console → Security → Security investigation tool

---

## 6. Google-Specific Protections

- [ ] **Password Alert** Chrome extension deployed — warns users when they type their Google password on non-Google sites
- [ ] **Chrome Browser Cloud Management** configured (if using Chrome fleet)
- [ ] **Google Vault** enabled for email retention and eDiscovery (if on Business Plus or Enterprise)
- [ ] **Security Sandbox** enabled for Gmail (Enterprise only) — opens suspicious attachments in a sandbox

---

## 7. Mythos-Specific Concerns

Google is a Glasswing founding partner. Chrome (the world's dominant browser) and Android are being scanned by Mythos. Expect accelerated security patches through July 2026.

But:
- Google patches **their code**, not your **configuration**
- A perfectly patched Gmail is still compromised if a user granted OAuth access to a malicious app
- Chrome patches will ship faster — verify auto-update is working on all machines

**Auto-update Chrome. Audit your OAuth grants. Enforce MFA. That's the floor.**

---

## Quick Wins (Do Today)

1. Enforce 2-Step Verification for all users — Admin console, one toggle
2. Disable less secure app access — Admin console, one toggle
3. Check DMARC record — one DNS lookup
4. Audit external Drive sharing — one report
5. Enable external email warning banner — Admin console, one toggle

---

*This guide covers Google Workspace Business and Enterprise plans. Some features require specific tiers.*
