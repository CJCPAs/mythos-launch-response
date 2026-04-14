# Cloudflare Security Hardening Guide

**For teams using Cloudflare WAF, Zero Trust, and DNS in the post-Mythos era.**

---

## 1. WAF Configuration

### OWASP Managed Ruleset
- **Paranoia Level:** Increase from 1 to 2 (or 3 if you can tolerate false positives)
- **Anomaly Score Threshold:** Lower from 40+ to 25+ for tighter detection
- **Action on high scores:** Block, not just log

### Custom WAF Rules

```
# Block common exploit patterns
(http.request.uri.query contains "UNION" and http.request.uri.query contains "SELECT")
or (http.request.uri.query contains "../")
or (http.request.uri.query contains "etc/passwd")
or (http.request.headers["user-agent"] contains "sqlmap")
```

### Rate Limiting
- Login endpoints: 5 requests/minute per IP
- API endpoints: 60 requests/minute per IP
- Webhooks: validate signatures, not just rate limit

---

## 2. Zero Trust Access

- [ ] All admin panels behind Zero Trust
- [ ] Application policies require identity verification
- [ ] Session durations are appropriate (not "forever")
- [ ] Device posture checks enabled where possible
- [ ] Access logs reviewed regularly

---

## 3. DNS Security

- [ ] DNSSEC enabled
- [ ] No stale DNS records pointing to decommissioned infrastructure
- [ ] SPF, DKIM, and DMARC configured for email domains
- [ ] No wildcard DNS records unless intentional

---

## 4. SSL/TLS

- [ ] Minimum TLS version set to 1.2 (or 1.3)
- [ ] Full (Strict) SSL mode enabled
- [ ] HSTS enabled with preload
- [ ] Certificate pinning considered for critical endpoints

---

## 5. Bot Management

- Enable Bot Fight Mode
- Configure Super Bot Fight Mode if on Business/Enterprise
- Review bot traffic analytics for patterns
- Challenge suspicious automated traffic

---

## 6. Post-Mythos Considerations

AI-driven attacks will:
- Send well-formed requests that pass basic WAF rules
- Chain multiple small requests into a larger exploit
- Adapt to your defenses in real-time
- Not trigger rate limits if distributed across IPs

Your WAF rules need to evolve from pattern-matching to behavioral analysis. Consider Cloudflare's AI-powered threat detection features as they become available.
