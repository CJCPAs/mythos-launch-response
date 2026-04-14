# Google Workspace Hardening Reference

## Critical Checks

1. **2-Step Verification enforced** — Admin console → Security → 2-Step Verification → Enforcement On
2. **Less secure app access disabled** — Admin console → Security → Less secure apps → Disable
3. **Advanced Protection** enrolled for high-risk users (CEO, CFO, controller)
4. **Anti-phishing protections** enabled — Admin → Apps → Gmail → Safety → all protections on
5. **DMARC/DKIM/SPF** configured:
   - SPF: `v=spf1 include:_spf.google.com -all`
   - DKIM: Admin → Apps → Gmail → Authenticate email → Generate + enable
   - DMARC: `v=DMARC1; p=reject; rua=mailto:dmarc@domain.com`
6. **External sharing restricted** — Admin → Apps → Drive → Sharing settings
7. **OAuth app grants reviewed** — Admin → Security → API Controls → App Access Control
8. **Auto-forwarding disabled or monitored** — Admin → Apps → Gmail → Auto-forwarding
9. **DLP rules** configured for sensitive data patterns (SSN, credit card, tax ID)
10. **Alert Center** configured for suspicious login, phishing, device compromise

## Mythos Context

Google is a Glasswing partner. Chrome and Android patches will accelerate through July 2026. Verify Chrome auto-update on all machines. Review OAuth grants — a compromised third-party app bypasses all other security.
