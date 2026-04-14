# Cloudflare Hardening Reference

## Critical Checks

1. WAF OWASP ruleset enabled — increase Paranoia Level to 2+
2. Rate limiting on login endpoints (5/min per IP) and API endpoints (60/min per IP)
3. Full (Strict) SSL mode enabled
4. HSTS enabled with preload
5. Minimum TLS 1.2
6. DNSSEC enabled
7. SPF/DKIM/DMARC configured
8. Zero Trust for admin panels
9. Bot Fight Mode enabled

## Hardening Actions

1. Increase OWASP Paranoia Level from 1 to 2 (or 3 if tolerable)
2. Lower Anomaly Score Threshold from 40+ to 25+
3. Set action on high scores to Block (not log)
4. Add custom WAF rules for common exploit patterns
5. Enable Zero Trust for all admin panels
6. Set session durations appropriately
7. Enable device posture checks
8. Review DNS for stale records pointing to decommissioned infrastructure
9. Remove wildcard DNS records unless intentional
10. Challenge suspicious automated traffic

## Mythos Context
AI-driven attacks will send well-formed requests that pass basic WAF rules. They won't trigger rate limits if distributed across IPs. WAF rules need to evolve from pattern-matching to behavioral analysis.
