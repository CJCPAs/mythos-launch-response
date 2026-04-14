# Microsoft 365 Hardening Reference

## Critical Checks

1. **Security Defaults or Conditional Access** — MFA must be enforced, not optional
   - Azure Portal → Azure AD → Properties → Security Defaults
   - Or Conditional Access with MFA required for all users on all apps
2. **Block legacy authentication** — POP3/IMAP/SMTP AUTH bypass MFA
   - Conditional Access → Client apps → Block Exchange ActiveSync + Other
3. **Safe Links + Safe Attachments** enabled in Defender
4. **DMARC/DKIM/SPF** configured:
   - SPF: `v=spf1 include:spf.protection.outlook.com -all`
   - DKIM: Defender → Policies → DKIM → Enable
   - DMARC: `v=DMARC1; p=reject; rua=mailto:dmarc@domain.com`
5. **Mail forwarding rules audited** (PowerShell):
   ```
   Get-Mailbox -ResultSize Unlimited | Where-Object {$_.ForwardingSmtpAddress -ne $null}
   ```
6. **External sharing restricted** in SharePoint/OneDrive
7. **Admin accounts** — dedicated, cloud-only, no mailbox, MFA with hardware key
8. **Secure Score** reviewed weekly at security.microsoft.com

## Mythos Context

Microsoft is a Glasswing partner. Patches will ship faster through July 2026. Ensure auto-updates are consuming them. Configuration is the user's responsibility.
