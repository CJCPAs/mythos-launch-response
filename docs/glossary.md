# Glossary

Technical terms used in this repo, explained in plain English.

---

| Term | Plain English |
|------|-------------|
| **Air-gapped** | Physically disconnected from all networks. A backup drive sitting unplugged in a safe is air-gapped. No hacker can reach it remotely because there's literally no wire or wireless connection. |
| **Authentication** | Proving who you are. Logging in with a password is authentication. |
| **Authorization** | Proving you're allowed to do something. Being logged in (authentication) doesn't mean you can access the admin panel (authorization). These are different checks. |
| **C2 / Command and Control** | The communication channel an attacker uses to send commands to compromised systems. Like a walkie-talkie between the hacker and the malware they planted. |
| **CIS Benchmark** | A set of security configuration guidelines published by the Center for Internet Security. Like a building code, but for computer systems. Freely available checklists. |
| **CORS** | Cross-Origin Resource Sharing. Browser security rules that control which websites can request data from your website. Misconfigured CORS can let attackers steal your users' data. |
| **CVE** | Common Vulnerabilities and Exposures. A unique ID number assigned to each known security flaw (like CVE-2026-4747). Used worldwide to track and communicate about specific bugs. |
| **DMARC / DKIM / SPF** | Three email security standards that work together to prevent people from sending fake emails that appear to come from your domain. Like a verified return address on a letter. |
| **DNS** | Domain Name System. The internet's phone book — translates website names (google.com) into IP addresses (142.250.80.46). DNS filtering blocks connections to known-malicious domains. |
| **EDR** | Endpoint Detection and Response. Security software that watches for suspicious behavior patterns, not just known viruses. Like having a security guard who watches for unusual activity, not just checking IDs against a list. |
| **Exploit** | A piece of code or technique that takes advantage of a vulnerability to do something unauthorized. The vulnerability is the unlocked window; the exploit is climbing through it. |
| **Heap spray** | An attack technique that fills computer memory with malicious code, like flooding a parking lot so any random parking space you land in has the attacker's code waiting. |
| **HSTS** | HTTP Strict Transport Security. A setting that tells browsers to always use encrypted connections to your website, even if someone types http:// instead of https://. |
| **IDOR** | Insecure Direct Object Reference. When changing a number in a URL (like /user/123 to /user/124) lets you see someone else's data. A shockingly common bug. |
| **JIT** | Just-In-Time compilation. When a browser converts website code into machine instructions on the fly for speed. The conversion process itself can have vulnerabilities. |
| **JWT** | JSON Web Token. A common way for websites to remember you're logged in. It's like a stamped wristband at a concert — the server gives you one, and you show it to get access. |
| **KASLR** | Kernel Address Space Layout Randomization. A defense that randomizes where important code lives in memory, like shuffling the rooms in a house so an intruder doesn't know which door leads where. Mythos demonstrated bypassing this defense. |
| **Lateral movement** | When an attacker who has compromised one system uses it to reach other systems on the same network. Like a burglar who gets into one apartment and then moves through connected hallways. Network segmentation prevents this. |
| **MDR** | Managed Detection and Response. A service where a security company monitors your systems 24/7 and responds to threats on your behalf. Like hiring an alarm company with armed response. |
| **MFA** | Multi-Factor Authentication. Requiring two different proofs of identity (like a password AND a code from your phone). Even if your password is stolen, your account stays protected. |
| **MTTD / MTTR** | Mean Time To Detect / Mean Time To Respond. How long it takes to notice you've been attacked and how long it takes to contain it. In the post-Mythos world, these matter more than prevention alone. |
| **N-day** | A vulnerability that has been publicly disclosed but not yet patched everywhere. "N days" since disclosure. Mythos compresses the time attackers need to weaponize N-days from weeks to hours. |
| **NDR** | Network Detection and Response. Security tools that watch network traffic for signs of attack. Important because network traffic "cannot be retroactively altered" — even if an attacker deletes logs on your computer, the network traffic was already recorded. |
| **NIST CSF** | National Institute of Standards and Technology Cybersecurity Framework. A widely-used framework organizing security into five functions: Identify, Protect, Detect, Respond, Recover. |
| **OWASP Top 10** | A list of the 10 most critical web application security risks, published by the Open Web Application Security Project. Updated periodically. The standard checklist for web security. |
| **Patch** | A software update that fixes a security vulnerability. "Patching" means applying these updates. In the Mythos era, patching speed is critical — hours matter, not weeks. |
| **Pentest** | Penetration test. Hiring a professional to try to hack into your systems (with your permission) to find weaknesses before real attackers do. |
| **Privilege escalation** | When an attacker goes from limited access to full control. Like a hotel guest figuring out how to get a master key. Mythos demonstrated doing this on Linux for under $2,000. |
| **RCE** | Remote Code Execution. An attacker can run any command on your computer from across the internet. The most dangerous type of vulnerability. |
| **RDP** | Remote Desktop Protocol. A Windows feature that lets you control a computer remotely. Extremely dangerous if exposed to the internet — one of the most exploited attack vectors. |
| **RLS** | Row-Level Security. A database feature (used by Supabase/PostgreSQL) where each row of data has rules about who can read or modify it. Like each file in a filing cabinet having its own lock. |
| **ROP chain** | Return-Oriented Programming. An attack technique where the attacker strings together small pieces of existing code to build an attack, like assembling a sentence from words cut out of a magazine. Mythos built a 20-gadget ROP chain for the FreeBSD exploit. |
| **Sandbox** | An isolated environment where software runs with restricted access. Browsers use sandboxes to prevent websites from accessing your files. Mythos reportedly escaped its own sandbox during testing. |
| **SIEM** | Security Information and Event Management. Software that collects and analyzes security logs from across your systems in one place. Like a control room with cameras from every part of the building. |
| **SSRF** | Server-Side Request Forgery. Tricking your server into making requests to internal systems on the attacker's behalf, like calling an employee-only phone extension through the front desk. |
| **TLS** | Transport Layer Security. The encryption that protects data in transit (the "S" in HTTPS). When you see the padlock icon in your browser, TLS is working. Mythos found weaknesses in some TLS implementations. |
| **WAF** | Web Application Firewall. A filter that sits in front of your website and blocks malicious requests before they reach your application. Can serve as "virtual patching" while waiting for a real fix. |
| **Zero Trust** | A security approach that assumes no user, device, or network should be trusted by default — even if they're inside your office. Every access request is verified every time. |
| **Zero-day** | A security flaw that nobody knows about yet — not even the people who made the software. "Zero days" since the vendor learned about it. Mythos discovered thousands of these. |

---

*Don't see a term? Open an issue or PR to add it.*
