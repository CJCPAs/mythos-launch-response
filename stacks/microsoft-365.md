# Microsoft 365 / Azure AD Security Hardening Guide

**For organizations using Microsoft 365 for email, files, and identity in the post-Mythos era.**

Microsoft 365 is the front door to most small businesses. If an attacker owns your M365 tenant, they own your email, your files, your contacts, and your identity. Harden it.

---

## 1. Identity and Access (Azure AD / Entra ID)

### MFA Enforcement — Non-Negotiable

MFA must be enforced, not just available. Check:

- [ ] **Security Defaults enabled** (minimum) — forces MFA for all users
  - Azure Portal → Azure Active Directory → Properties → Manage Security Defaults → Yes
- [ ] **Or Conditional Access policies** (better) if you have Azure AD Premium:
  - Require MFA for all users on all cloud apps
  - Require MFA for all admin roles always
  - Block legacy authentication protocols (they bypass MFA)

```
Conditional Access → New Policy:
  Users: All users
  Cloud apps: All cloud apps
  Conditions: None
  Grant: Require multi-factor authentication
  Session: Sign-in frequency = 24 hours
  Enable policy: On
```

- [ ] **Block legacy auth protocols** — this is critical. Legacy protocols (POP3, IMAP, SMTP AUTH) don't support MFA and are the #1 way attackers bypass it.
  - Conditional Access → New Policy → Conditions → Client apps → Check "Exchange ActiveSync clients" and "Other clients" → Block

### Admin Account Security

- [ ] All Global Admin accounts have MFA enforced (no exceptions)
- [ ] Global Admin accounts are cloud-only (not synced from on-prem AD)
- [ ] Global Admin accounts have no mailbox (reduces phishing risk)
- [ ] Separate admin accounts from daily-use accounts (admins log in with admin@... only for admin tasks)
- [ ] Emergency "break glass" admin account exists, documented, secured, and tested
- [ ] Review admin role assignments: Azure AD → Roles and administrators → check each role

### User Access Review

- [ ] Disable all inactive accounts (no sign-in in 90+ days)
  - Azure AD → Users → Sort by "Last sign-in" → Disable inactive
- [ ] Remove guest accounts that are no longer needed
- [ ] Review and remove app consent grants users have approved
  - Azure AD → Enterprise Applications → User consent → Review

---

## 2. Email Security (Exchange Online)

### Anti-Phishing

AI-generated phishing will be indistinguishable from legitimate email. Defense must be technical, not visual.

- [ ] **Safe Links** enabled — rewrites URLs to check at click time
  - Microsoft 365 Defender → Policies → Safe Links → Default policy → On
- [ ] **Safe Attachments** enabled — detonates attachments in sandbox
  - Microsoft 365 Defender → Policies → Safe Attachments → Default policy → On
- [ ] **Anti-phishing policy** configured:
  - Impersonation protection for key users (CEO, CFO, controller)
  - Impersonation protection for your domain
  - Mailbox intelligence enabled
  - First-contact safety tip enabled
- [ ] **External email tagging** enabled — prepends "[External]" to subject of outside emails
  - Exchange admin center → Mail flow → Rules → Create rule for external senders

### DMARC / DKIM / SPF

- [ ] **SPF record** published in DNS:
  ```
  v=spf1 include:spf.protection.outlook.com -all
  ```
- [ ] **DKIM** enabled for your domain:
  - Microsoft 365 Defender → Policies → DKIM → Select domain → Enable
- [ ] **DMARC record** published in DNS:
  ```
  v=DMARC1; p=reject; rua=mailto:dmarc-reports@yourdomain.com; pct=100
  ```
  Start with `p=quarantine` if nervous, move to `p=reject` within 30 days.

### Mailbox Audit

- [ ] Mailbox auditing is enabled (on by default since 2019, but verify)
- [ ] Audit log search is enabled in the compliance center
- [ ] Mail forwarding rules are reviewed — attackers create forwarding rules to exfiltrate email silently
  ```powershell
  # PowerShell: Find all mailbox forwarding rules
  Get-Mailbox -ResultSize Unlimited | Where-Object {$_.ForwardingSmtpAddress -ne $null} | 
    Select-Object Name, ForwardingSmtpAddress
  
  # Find all inbox rules that forward mail
  Get-Mailbox -ResultSize Unlimited | ForEach-Object {
    Get-InboxRule -Mailbox $_.UserPrincipalName | 
    Where-Object {$_.ForwardTo -or $_.ForwardAsAttachmentTo -or $_.RedirectTo}
  }
  ```

---

## 3. File Security (SharePoint / OneDrive)

- [ ] **External sharing** restricted to specific domains or disabled entirely
  - SharePoint admin center → Policies → Sharing → Most restrictive that works for your business
- [ ] **Anonymous sharing links** disabled or set to expire
- [ ] **DLP policies** configured for sensitive data (SSN, account numbers, tax IDs)
  - Microsoft Purview → Data Loss Prevention → Policies
- [ ] **Sensitivity labels** applied to confidential documents
- [ ] **File activity audit** — know who accessed what
  - Compliance center → Audit → Search for file and page activities

---

## 4. Device Security

- [ ] **Microsoft Intune** (if available) managing all devices
- [ ] **BitLocker** enabled on all Windows devices (full disk encryption)
- [ ] **Device compliance policies** — block access from non-compliant devices
- [ ] **Remote wipe capability** tested — can you wipe a lost laptop?
- [ ] **Windows Update for Business** configured — automated patching

---

## 5. Monitoring and Alerts

Set up these alerts in Microsoft 365 Defender:

- [ ] Alert on impossible travel (user logs in from two countries within an hour)
- [ ] Alert on mass file downloads (data exfiltration indicator)
- [ ] Alert on new inbox forwarding rules (attacker persistence)
- [ ] Alert on admin role changes (privilege escalation)
- [ ] Alert on failed MFA attempts (brute force indicator)
- [ ] Review Microsoft Secure Score weekly and act on recommendations
  - security.microsoft.com → Secure Score

---

## 6. Mythos-Specific Concerns

Microsoft is a Glasswing founding partner. They are actively scanning their own code with Mythos. But:

- Mythos scans Microsoft's **code**, not your **configuration**
- A perfectly patched Exchange Online is still vulnerable if you have no MFA, forwarding rules to attacker mailboxes, and external sharing enabled
- Microsoft patches will ship faster than usual through July 2026 — make sure auto-updates are consuming them

**Your configuration is your responsibility. Microsoft's code is theirs.**

---

## Quick Wins (Do Today)

1. Enable Security Defaults (if no Conditional Access) — 5 clicks
2. Block legacy authentication — 1 Conditional Access policy
3. Run the forwarding rule PowerShell audit — 2 commands
4. Check your DMARC record — 1 DNS lookup
5. Review Secure Score — 1 URL visit

---

*This guide covers Microsoft 365 Business and Enterprise plans. Some features require specific license tiers (Azure AD Premium, Defender for Office 365). Check your plan.*
