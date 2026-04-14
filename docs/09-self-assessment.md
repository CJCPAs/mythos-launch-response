# Security Self-Assessment Scorecard

**How ready is your organization for the post-Mythos threat landscape?**

Answer each question honestly. Yes = 1 point. No = 0 points.

---

## Basics (10 points)

These are non-negotiable. If you score below 8 here, stop and fix these before anything else.

| # | Question | Yes/No |
|:-:|----------|:------:|
| 1 | All operating systems are set to auto-update (and you've verified it, not just assumed it) | |
| 2 | All web browsers are set to auto-update | |
| 3 | Multi-factor authentication (MFA) is enabled on all email accounts | |
| 4 | MFA is enabled on all banking and financial accounts | |
| 5 | MFA is enabled on all cloud, hosting, and domain accounts | |
| 6 | A password manager is deployed for all employees | |
| 7 | No passwords are shared between people or reused across accounts | |
| 8 | Backups exist for all critical business data | |
| 9 | At least one backup is air-gapped AND uses separate credentials from your production environment (not your regular domain/admin accounts) | |
| 10 | A backup has been successfully test-restored in the last 90 days | |

**Your Basics score: ___ / 10**

---

## Intermediate (10 points)

These separate "we have some security" from "we take security seriously."

| # | Question | Yes/No |
|:-:|----------|:------:|
| 11 | All internet-facing services are inventoried (you have a written list) | |
| 12 | No Remote Desktop Protocol (RDP) is exposed directly to the internet | |
| 13 | Firewall rules have been reviewed in the last 90 days | |
| 14 | DMARC, DKIM, and SPF are configured on your email domain | |
| 15 | Endpoint Detection and Response (EDR) is deployed, not just traditional antivirus | |
| 16 | All API keys and secrets have been rotated in the last 90 days | |
| 17 | All inactive user accounts (no login in 90+ days) are disabled | |
| 18 | Guest Wi-Fi is on a separate network from business systems | |
| 19 | An incident response plan is documented and accessible offline | |
| 20 | An active cyber insurance policy is in place | |

**Your Intermediate score: ___ / 10**

---

## Advanced (5 points)

These represent a mature security posture.

| # | Question | Yes/No |
|:-:|----------|:------:|
| 21 | Sensitive systems are on a separate network segment from general office systems | |
| 22 | 24/7 security monitoring is active (MDR service or internal SOC) | |
| 23 | All critical vendors have been assessed for their security posture | |
| 24 | All staff completed security awareness training within the past 12 months | |
| 25 | A penetration test was completed within the past 12 months | |

**Your Advanced score: ___ / 5**

---

## Your Total Score: ___ / 25

### What Your Score Means

| Score | Rating | What to Do |
|:-----:|--------|-----------|
| **21-25** | **Strong.** You have a solid security foundation. Focus on continuous improvement, advanced monitoring, and preparing for Mythos-class scanning when available. |  Review the [Day Zero Playbook](06-day-zero-playbook.md) |
| **16-20** | **Good foundation.** Your basics are mostly covered. Close the gaps in your Intermediate section — each one represents a real attack path. | Work through the [SMB Response Plan](02-smb-response-plan.md) sections 4-5 |
| **10-15** | **Significant gaps.** You have some defenses but meaningful holes exist. Prioritize the Basics items you missed — they're the most impactful. | Work through the [SMB Response Plan](02-smb-response-plan.md) sections 3-4 |
| **5-9** | **Critical exposure.** Multiple fundamental defenses are missing. An AI-assisted attacker could compromise your systems with minimal effort. | Start with the [Executive Summary](00a-executive-summary.md) actions TODAY |
| **0-4** | **Immediate danger.** Stop reading this assessment and go enable MFA on your email right now. Then auto-updates. Then come back. | [Executive Summary](00a-executive-summary.md) — do the 5 free actions NOW |

---

## Priority Matrix

If you can't do everything, do the highest-impact items first:

| Priority | Items | Why |
|----------|-------|-----|
| **Do today** | Questions 1, 2, 3, 6 (auto-updates, email MFA, password manager) | Free. Prevents the most common attacks. |
| **Do this week** | Questions 4, 5, 7, 8, 9 (remaining MFA, passwords, backups) | Low cost. Covers credential theft and ransomware. |
| **Do this month** | Questions 10, 11, 12, 14, 15 (test backup, inventory, RDP, email security, EDR) | Moderate cost. Closes critical visibility and detection gaps. |
| **Do this quarter** | Questions 13, 16, 17, 18, 19, 20 (firewall, keys, accounts, segmentation, IR plan, insurance) | Requires planning. Builds operational maturity. |
| **Ongoing** | Questions 21-25 (advanced monitoring, vendor assessment, training, pentesting) | Investment. Represents mature security posture. |

---

## Re-Assessment Schedule

Run this scorecard:
- **Monthly** until you reach 20+
- **Quarterly** once you're above 20
- **Immediately** after any security incident or major system change
- **Upon any Glasswing-related CVE disclosure** that affects your stack

---

*Print this page. Score yourself honestly. Tape it to the wall. Improve the number.*
