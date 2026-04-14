# Windows Workstation Security Hardening Guide

**For organizations managing Windows desktops and laptops in the post-Mythos era.**

This is the machine your employees sit at every day. It runs their email, their browser, their accounting software, and their files. If an attacker owns a workstation, they own everything that employee can access — and from there they move laterally across your network.

Mythos found privilege escalation exploits in the Linux kernel for under $2,000. Windows is a larger target with a larger attack surface. Assume similar exploits exist.

---

## 1. Windows Update — The Non-Negotiable

### Verify Auto-Update Is Working (Not Just Enabled)

```powershell
# Check Windows Update status
Get-WindowsUpdateLog
Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 10

# Check last update date
(Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 1).InstalledOn

# If last update is more than 14 days old, something is broken
```

- [ ] **Windows Update set to automatic** — Settings → Update & Security → Windows Update → Advanced options → Automatic
- [ ] **Active Hours configured** so updates install outside work hours
- [ ] **Verify updates are actually installing** — check the date of the last installed update on every machine
- [ ] **Windows version is supported** — Windows 10 reaches end-of-support October 2025. If you're still on it, upgrade to Windows 11.
- [ ] **Feature updates installed** within 60 days of release
- [ ] **Reboot pending updates applied** — machines that "need to restart" aren't protected

### Driver and Firmware Updates

- [ ] **BIOS/UEFI firmware current** — check manufacturer's support site (Dell, HP, Lenovo)
- [ ] **Intel/AMD microcode current** — delivered via Windows Update, but verify
- [ ] **GPU drivers current** — NVIDIA is a Glasswing partner, expect accelerated driver patches

---

## 2. Endpoint Protection

### Windows Security (Built-in)

Windows 11 includes Microsoft Defender, which is significantly better than its reputation suggests. At minimum:

- [ ] **Real-time protection ON**
  ```powershell
  Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled
  # Must return True
  ```
- [ ] **Cloud-delivered protection ON** (sends suspicious files to Microsoft for analysis)
- [ ] **Automatic sample submission ON**
- [ ] **Tamper Protection ON** (prevents malware from disabling Defender)
  ```powershell
  Get-MpComputerStatus | Select-Object IsTamperProtected
  ```
- [ ] **Controlled Folder Access ON** (ransomware protection — blocks unauthorized apps from writing to Documents, Desktop, etc.)
  ```powershell
  Set-MpPreference -EnableControlledFolderAccess Enabled
  ```
- [ ] **Attack Surface Reduction (ASR) rules enabled**
  ```powershell
  # Enable key ASR rules
  # Block Office apps from creating child processes
  Add-MpPreference -AttackSurfaceReductionRules_Ids D4F940AB-401B-4EFC-AADC-AD5F3C50688A -AttackSurfaceReductionRules_Actions Enabled
  # Block executable content from email and webmail
  Add-MpPreference -AttackSurfaceReductionRules_Ids BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550 -AttackSurfaceReductionRules_Actions Enabled
  # Block credential stealing from Windows LSASS
  Add-MpPreference -AttackSurfaceReductionRules_Ids 9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2 -AttackSurfaceReductionRules_Actions Enabled
  ```

### Or: Third-Party EDR

If you want more than Defender, replace (don't stack) with a proper EDR:

| EDR | Cost | Notes |
|-----|------|-------|
| CrowdStrike Falcon Go | ~$5/endpoint/mo | Best threat intelligence |
| SentinelOne | ~$6/endpoint/mo | Best autonomous response |
| Huntress | ~$4/endpoint/mo | Best for SMBs without security staff |
| Microsoft Defender for Business | $3/user/mo | If already in M365 ecosystem |

**Pick ONE. Running multiple endpoint agents causes conflicts and gaps.**

---

## 3. Disk Encryption

### BitLocker

If a laptop is stolen, BitLocker prevents the thief from reading the hard drive.

- [ ] **BitLocker enabled on ALL drives**
  ```powershell
  # Check BitLocker status
  Get-BitLockerVolume | Select-Object MountPoint, VolumeStatus, EncryptionPercentage, ProtectionStatus
  
  # Enable BitLocker on C: drive
  Enable-BitLocker -MountPoint "C:" -EncryptionMethod XtsAes256 -RecoveryPasswordProtector
  ```
- [ ] **Recovery keys backed up** — to Azure AD, Active Directory, or printed and stored in a safe (NOT on the same machine)
- [ ] **Encryption method is AES-256** (not the older AES-128)
- [ ] **All portable devices (laptops, USB drives) encrypted**

---

## 4. Local Account Security

### Local Admin

- [ ] **Default Administrator account disabled**
  ```powershell
  Get-LocalUser -Name "Administrator" | Select-Object Name, Enabled
  # If Enabled = True:
  Disable-LocalUser -Name "Administrator"
  ```
- [ ] **Local admin password is unique per machine** (not the same password on every workstation)
- [ ] **LAPS (Local Administrator Password Solution)** deployed if managing multiple machines — gives each machine a unique, rotating local admin password
- [ ] **Users do NOT have local admin rights** for daily work — they use standard accounts and elevate only when needed

### User Accounts

- [ ] **Each employee has their own account** (no shared logins)
- [ ] **Accounts of former employees disabled immediately upon departure**
- [ ] **Screen lock enabled** — 5 minutes of inactivity → lock screen
  ```powershell
  # Set via Group Policy or registry
  # Computer Configuration → Windows Settings → Security Settings → Local Policies → Security Options
  # Interactive logon: Machine inactivity limit = 300 seconds
  ```
- [ ] **Password/PIN required to unlock**

---

## 5. Windows Firewall

Yes, it matters, even behind a network firewall.

- [ ] **Windows Firewall ON for all profiles** (Domain, Private, Public)
  ```powershell
  Get-NetFirewallProfile | Select-Object Name, Enabled
  # All three must be True
  ```
- [ ] **Default inbound action: Block**
- [ ] **Review inbound allow rules** — remove any that aren't actively needed
  ```powershell
  # List all enabled inbound allow rules
  Get-NetFirewallRule -Direction Inbound -Enabled True -Action Allow | 
    Select-Object DisplayName, Profile | Format-Table -AutoSize
  ```
- [ ] **No rules allowing inbound RDP (port 3389) from any source**
  ```powershell
  # Check for RDP rules
  Get-NetFirewallRule -Direction Inbound -Enabled True | 
    Where-Object { $_.DisplayName -like "*Remote Desktop*" }
  ```
- [ ] **File and printer sharing disabled** on Public profile
- [ ] **Network discovery disabled** on Public profile

---

## 6. Application Security

### Browser Hardening

- [ ] **Chrome/Edge/Firefox auto-update verified** (most common exploit target after the OS itself)
- [ ] **Browser extensions audited** — remove any you don't actively use
  - Chrome: chrome://extensions
  - Edge: edge://extensions
  - Each extension is a potential attack vector
- [ ] **Password saving in browsers disabled** if using a password manager (avoid duplicate credential stores)
- [ ] **Pop-up blocker enabled**
- [ ] **Safe Browsing / SmartScreen enabled**

### Office Security

- [ ] **Macro execution disabled by default** — macros are the #1 malware delivery vector in Office
  - Group Policy: User Configuration → Administrative Templates → Microsoft Office → Security Settings → VBA Macro Notification → Disable all macros except digitally signed
  - Or per-app: File → Options → Trust Center → Macro Settings → Disable all macros with notification
- [ ] **Protected View enabled** for files from the internet
- [ ] **Block macros from running in Office files from the internet** (Windows 11 does this by default with Mark of the Web)

### Software Inventory

- [ ] **Audit installed software** — remove anything that shouldn't be there
  ```powershell
  Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | 
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | 
    Sort-Object DisplayName | Format-Table -AutoSize
  ```
- [ ] **Remove unused software** — every installed application is attack surface
- [ ] **No unauthorized remote access tools** (TeamViewer, AnyDesk, LogMeIn) unless IT-approved

---

## 7. Network Settings

- [ ] **Network profile set correctly** — office network should be Private, everything else Public
  ```powershell
  Get-NetConnectionProfile | Select-Object Name, NetworkCategory
  ```
- [ ] **SMBv1 disabled** (legacy protocol with known vulnerabilities — WannaCry used SMBv1)
  ```powershell
  # Check SMBv1 status
  Get-SmbServerConfiguration | Select-Object EnableSMB1Protocol
  
  # Disable SMBv1
  Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force
  ```
- [ ] **DNS set to filtered provider** if not handled by network firewall
  - Cloudflare for Families: 1.1.1.3 (malware blocking)
  - Quad9: 9.9.9.9 (malware blocking)
- [ ] **Wi-Fi set to "forget" networks automatically** — don't auto-connect to networks you've joined once

---

## 8. Logging and Monitoring

- [ ] **PowerShell script block logging enabled** (catches malicious PowerShell — the most common post-exploitation tool)
  ```powershell
  # Enable via Group Policy:
  # Computer Configuration → Administrative Templates → Windows Components → 
  # Windows PowerShell → Turn on PowerShell Script Block Logging → Enabled
  ```
- [ ] **Windows Event Forwarding** configured to send security logs to a central location (if you have multiple machines)
- [ ] **Audit logon events enabled**
  ```powershell
  # Enable via Local Security Policy or Group Policy:
  # Security Settings → Local Policies → Audit Policy → 
  # Audit logon events → Success, Failure
  ```
- [ ] **Check for unusual scheduled tasks**
  ```powershell
  Get-ScheduledTask | Where-Object {$_.State -ne "Disabled"} | 
    Select-Object TaskName, TaskPath, State | Format-Table -AutoSize
  ```

---

## 9. Physical Security

Often overlooked, always relevant:

- [ ] **BIOS/UEFI password set** (prevents boot device changes)
- [ ] **Secure Boot enabled** (prevents bootkit malware)
  ```powershell
  Confirm-SecureBootUEFI
  # Must return True
  ```
- [ ] **USB boot disabled** in BIOS (prevents boot-from-USB attacks)
- [ ] **Laptop cable locks** for machines in shared/public spaces
- [ ] **Screen privacy filters** for machines handling sensitive data in open environments

---

## 10. Mythos-Specific Concerns

Microsoft is a Glasswing founding partner. They are actively scanning Windows with Mythos. Expect:

- Accelerated Windows security updates through July 2026
- Possible out-of-band (emergency) patches for Mythos-discovered flaws
- Browser patches for Edge (Chromium-based, benefits from Google's Glasswing work too)

But:

- Windows patches fix the **code**. Your **configuration** is yours.
- A fully patched Windows machine with no BitLocker, no firewall, local admin for every user, and macros enabled is still trivially compromisable
- The patches protect you from the vulnerability. Your configuration determines whether you're exposed to exploitation.

---

## Quick Wins (Do Today)

1. Run `Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 1` — when was the last update?
2. Run `Get-BitLockerVolume` — is your drive encrypted?
3. Run `Get-MpComputerStatus` — is real-time protection on? Tamper protection on?
4. Run `Get-NetFirewallProfile` — is the firewall on for all profiles?
5. Disable macros in Office — one Group Policy or per-app setting

---

*This guide covers Windows 11. Windows 10 reaches end-of-support October 2025 — if you're still on it, upgrade is a security priority.*
