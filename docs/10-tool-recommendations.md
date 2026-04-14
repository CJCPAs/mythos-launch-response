# Tool Recommendations

**Honest assessments. No sponsorships. No affiliate links.**

These are tools that address the specific threats raised by the Mythos disclosure. Organized by need, with free and paid options.

---

## Disclosure

We have no financial relationship with any vendor listed here. These are our assessments based on public information, personal experience, and community reputation. Your needs may differ. Evaluate before purchasing.

---

## Password Management

| Tool | Cost | Notes |
|------|------|-------|
| **Bitwarden** | Free (personal), $4/user/mo (teams) | Open source. Self-hostable. Best free option. |
| **1Password** | $8/user/mo (business) | Excellent team admin features. Better onboarding. Not open source. |
| **KeePassXC** | Free | Local-only, open source. No cloud sync (pro or con depending on your threat model). |

**Our take:** Bitwarden for most SMBs. 1Password if you need strong team management. The important thing is using one at all — which one matters less.

---

## Endpoint Detection and Response (EDR)

Traditional antivirus cannot detect AI-discovered zero-day exploits. EDR watches for malicious behavior patterns.

| Tool | Cost | Notes |
|------|------|-------|
| **CrowdStrike Falcon Go** | ~$5/endpoint/mo | Strong threat intelligence. Good for small teams. Cloud-native. |
| **SentinelOne Singularity** | ~$6/endpoint/mo | Simpler interface. Good autonomous response. |
| **Microsoft Defender for Business** | $3/user/mo | Integrated with Microsoft 365. Decent if you're already in the Microsoft ecosystem. |
| **Huntress** | ~$4/endpoint/mo | Built specifically for SMBs. Managed threat hunting included. |

**Our take:** Any of these is dramatically better than traditional antivirus. Huntress is especially good for SMBs without security staff.

---

## Multi-Factor Authentication (MFA)

| Tool | Cost | Notes |
|------|------|-------|
| **Google Authenticator** | Free | Simple TOTP app. No cloud backup (secure but inconvenient if you lose your phone). |
| **Microsoft Authenticator** | Free | Push notifications + TOTP. Cloud backup available. |
| **Authy** | Free | Cloud backup, multi-device sync. Convenient but broader attack surface. |
| **YubiKey** | $50-75/key (one-time) | Hardware security key. Phishing-proof. The gold standard. |

**Our take:** YubiKeys for anyone with access to financial systems or admin accounts. Authenticator apps for everyone else. SMS codes only as absolute last resort.

---

## Email Security

| Tool | Cost | Notes |
|------|------|-------|
| **Google Workspace** (built-in) | Included | Turn on Advanced Protection for high-risk users. Enable phishing protections. |
| **Microsoft 365** (built-in) | Included | Enable Safe Links, Safe Attachments, anti-phishing policies. |
| **Proofpoint Essentials** | $2-4/user/mo | Dedicated email security layer. Good phishing detection. |
| **DMARC/DKIM/SPF** | Free to configure | Not a product — a set of DNS records. Your IT person or email provider can set them up. Use dmarcian.com for monitoring. |

**Our take:** Configure DMARC/DKIM/SPF first (it's free). Then maximize your existing Google/Microsoft security settings. Add Proofpoint if you handle highly sensitive data.

---

## Vulnerability Scanning

| Tool | Cost | Notes |
|------|------|-------|
| **OpenVAS / Greenbone** | Free (open source) | Network vulnerability scanner. Requires Linux. Powerful but complex. |
| **Qualys FreeScan** | Free (limited) | External scan of your public-facing systems. Good for a quick check. |
| **OWASP ZAP** | Free (open source) | Web application scanner. Good for testing your own web apps. |
| **Snyk** | Free tier available | Dependency and code scanning. Excellent for developers. |
| **Nmap** | Free (open source) | Port scanner. Essential for knowing what's exposed. |

**Our take:** Run Nmap against your own public IPs today — it's free and tells you what's exposed. Use Snyk if you have custom code. These don't have Mythos-class capability, but they catch the low-hanging fruit attackers exploit first.

---

## DNS Filtering

Blocks connections to known-malicious domains. Prevents malware from "phoning home."

| Tool | Cost | Notes |
|------|------|-------|
| **Cloudflare Gateway** | Free (up to 50 users) | Easy setup. Change your DNS to Cloudflare's filtered resolvers. |
| **NextDNS** | Free (limited), $2/mo | Highly configurable. Good privacy features. |
| **Cisco Umbrella** | $2-3/user/mo | Enterprise-grade. Good reporting. |

**Our take:** Cloudflare Gateway's free tier is genuinely useful for small offices. Takes 10 minutes to set up.

---

## Backup Solutions

| Tool | Cost | Notes |
|------|------|-------|
| **Backblaze B2** + **rclone** | ~$6/TB/mo | Cheap cloud storage + free sync tool. Requires technical setup. |
| **Veeam Backup** | $5-10/endpoint/mo | Professional backup with good restore testing features. |
| **Acronis Cyber Protect** | $5-9/endpoint/mo | Backup + basic security in one package. |
| **External hard drive** (air-gapped) | $50-150 one-time | The simplest air-gapped backup. Buy a drive, copy your data, unplug it, store it offsite. |

**Our take:** The specific product matters less than the strategy. Follow the 3-2-1 rule: 3 copies, 2 different media, 1 offsite. Make sure at least one copy is air-gapped. TEST YOUR RESTORES.

---

## Network Segmentation

| Tool | Cost | Notes |
|------|------|-------|
| **Your existing router/firewall** | Free (already own it) | Most business routers support VLANs. Separate guest, business, and sensitive networks. |
| **Ubiquiti UniFi** | $200-500 (hardware) | Affordable prosumer gear that supports VLANs and firewall rules. |
| **pfSense / OPNsense** | Free (open source) | Professional-grade firewall on commodity hardware. Requires technical skill. |

**Our take:** Start with what you have. Most business routers can create a separate guest network and a separate sensitive data network. You don't need enterprise gear to get meaningful segmentation.

---

## Managed Detection and Response (MDR)

24/7 monitoring by security professionals. For when you don't have dedicated security staff.

| Tool | Cost | Notes |
|------|------|-------|
| **Huntress** | ~$4/endpoint/mo | Built for SMBs. Managed threat hunting. Human analysts review alerts. |
| **Arctic Wolf** | Custom pricing | Concierge-style MDR. Good for organizations with no security staff. |
| **CrowdStrike Falcon Complete** | Premium pricing | Full managed service from CrowdStrike. Enterprise-grade. |

**Our take:** If you have zero security staff, MDR is the single most impactful purchase you can make. Huntress is the most SMB-friendly option.

---

## Web Application Firewall (WAF)

Sits in front of your website and blocks malicious requests. Can serve as "virtual patching."

| Tool | Cost | Notes |
|------|------|-------|
| **Cloudflare** (free plan) | Free | Basic WAF rules included in free plan. |
| **Cloudflare Pro** | $20/mo per domain | Managed WAF rules, DDoS protection. |
| **Vercel** (built-in) | Included | Automatic DDoS protection, WAF for Next.js apps. |
| **AWS WAF** | Pay-per-use | Flexible rules but requires configuration expertise. |

**Our take:** If your website is on Cloudflare or Vercel, you likely have basic WAF protection already. Verify it's enabled and review the rules.

---

## Credential Breach Monitoring

| Tool | Cost | Notes |
|------|------|-------|
| **Have I Been Pwned** | Free | Check if your email addresses appear in known data breaches. |
| **Firefox Monitor** | Free | Breach notification service built into Firefox. |
| **SpyCloud** | Paid (enterprise) | Automated credential monitoring for organizations. |

**Our take:** Check haveibeenpwned.com for every business email address today. It's free and takes 30 seconds per address.

---

## What NOT to Buy

| Product Type | Why Not |
|-------------|---------|
| **"AI-powered" security tools making Mythos claims** | If a vendor claims they have Mythos-class capabilities, they're almost certainly exaggerating. Mythos is not publicly available. Be skeptical of marketing hype riding the Mythos news cycle. |
| **Expensive enterprise SIEM for a 10-person office** | Overkill. An MDR service gives you the monitoring without the complexity. |
| **Multiple overlapping endpoint agents** | Running 3 security agents on one machine causes more problems than it solves. Pick one good EDR. |
| **"Dark web monitoring" as a standalone product** | Usually low-value alerts. Your breach monitoring comes free from HIBP. |

---

*Tool recommendations updated April 11, 2026. Pricing is approximate and may vary. If you have experience with tools we should add or reassess, contribute via PR.*
