# Mythos Readiness: Windows Workstation Security Audit
# Run as Administrator for full results
# Usage: powershell -ExecutionPolicy Bypass -File audit-windows.ps1

$ErrorActionPreference = "SilentlyContinue"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " MYTHOS READINESS: WINDOWS AUDIT" -ForegroundColor Cyan
Write-Host " $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$pass = 0
$fail = 0
$warn = 0

function Report($status, $message) {
    switch ($status) {
        "PASS" { Write-Host "  [PASS] $message" -ForegroundColor Green; $script:pass++ }
        "FAIL" { Write-Host "  [FAIL] $message" -ForegroundColor Red; $script:fail++ }
        "WARN" { Write-Host "  [WARN] $message" -ForegroundColor Yellow; $script:warn++ }
        "INFO" { Write-Host "  [INFO] $message" -ForegroundColor Gray }
    }
}

# ── 1. WINDOWS UPDATE ──────────────────────────────────────
Write-Host "1. WINDOWS UPDATE" -ForegroundColor White
$lastHotfix = Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 1
if ($lastHotfix) {
    $daysSince = (New-TimeSpan -Start $lastHotfix.InstalledOn -End (Get-Date)).Days
    if ($daysSince -le 14) {
        Report "PASS" "Last update installed $daysSince days ago ($($lastHotfix.HotFixID) on $($lastHotfix.InstalledOn.ToString('yyyy-MM-dd')))"
    } elseif ($daysSince -le 30) {
        Report "WARN" "Last update $daysSince days ago — should be within 14 days"
    } else {
        Report "FAIL" "Last update $daysSince days ago — critically behind on patches"
    }
} else {
    Report "FAIL" "Could not determine last update date"
}

$osVersion = (Get-CimInstance Win32_OperatingSystem).Caption
Report "INFO" "OS: $osVersion"

$buildNumber = [System.Environment]::OSVersion.Version.Build
if ($buildNumber -ge 22621) {
    Report "PASS" "Running Windows 11 (build $buildNumber)"
} elseif ($buildNumber -ge 19041) {
    Report "WARN" "Running Windows 10 (build $buildNumber) — EOL October 2025, plan upgrade"
} else {
    Report "FAIL" "Running unsupported Windows version (build $buildNumber)"
}

# ── 2. BITLOCKER ENCRYPTION ────────────────────────────────
Write-Host "`n2. DISK ENCRYPTION (BitLocker)" -ForegroundColor White
$bitlocker = Get-BitLockerVolume -ErrorAction SilentlyContinue
if ($bitlocker) {
    foreach ($vol in $bitlocker) {
        if ($vol.ProtectionStatus -eq "On" -and $vol.VolumeStatus -eq "FullyEncrypted") {
            Report "PASS" "Drive $($vol.MountPoint) encrypted ($($vol.EncryptionMethod))"
        } elseif ($vol.VolumeStatus -eq "EncryptionInProgress") {
            Report "WARN" "Drive $($vol.MountPoint) encryption in progress ($($vol.EncryptionPercentage)%)"
        } else {
            Report "FAIL" "Drive $($vol.MountPoint) NOT encrypted (Status: $($vol.ProtectionStatus))"
        }
    }
} else {
    Report "FAIL" "BitLocker not available or not enabled on any drive"
}

# ── 3. WINDOWS DEFENDER ────────────────────────────────────
Write-Host "`n3. ENDPOINT PROTECTION (Windows Defender)" -ForegroundColor White
$defender = Get-MpComputerStatus -ErrorAction SilentlyContinue
if ($defender) {
    if ($defender.RealTimeProtectionEnabled) {
        Report "PASS" "Real-time protection enabled"
    } else {
        Report "FAIL" "Real-time protection DISABLED"
    }

    if ($defender.IsTamperProtected) {
        Report "PASS" "Tamper protection enabled"
    } else {
        Report "FAIL" "Tamper protection DISABLED — malware can disable Defender"
    }

    if ($defender.AntivirusSignatureAge -le 3) {
        Report "PASS" "Antivirus signatures $($defender.AntivirusSignatureAge) days old"
    } else {
        Report "WARN" "Antivirus signatures $($defender.AntivirusSignatureAge) days old — should be within 3 days"
    }

    $amService = Get-Service -Name WinDefend -ErrorAction SilentlyContinue
    if ($amService -and $amService.Status -eq "Running") {
        Report "PASS" "Defender service running"
    } else {
        Report "FAIL" "Defender service not running"
    }
} else {
    Report "WARN" "Could not query Defender status — may have third-party AV"
}

# Check Controlled Folder Access
$cfa = (Get-MpPreference).EnableControlledFolderAccess
if ($cfa -eq 1) {
    Report "PASS" "Controlled Folder Access enabled (ransomware protection)"
} else {
    Report "WARN" "Controlled Folder Access NOT enabled — consider enabling for ransomware protection"
}

# ── 4. WINDOWS FIREWALL ───────────────────────────────────
Write-Host "`n4. WINDOWS FIREWALL" -ForegroundColor White
$profiles = Get-NetFirewallProfile
foreach ($p in $profiles) {
    if ($p.Enabled) {
        Report "PASS" "$($p.Name) profile: Firewall ON"
    } else {
        Report "FAIL" "$($p.Name) profile: Firewall OFF"
    }
}

# Check for inbound RDP rules
$rdpRules = Get-NetFirewallRule -Direction Inbound -Enabled True -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName -like "*Remote Desktop*" -or $_.DisplayName -like "*RDP*" }
if ($rdpRules) {
    Report "WARN" "Inbound RDP rules found ($($rdpRules.Count) rules) — verify these are intentional and VPN-restricted"
} else {
    Report "PASS" "No inbound RDP rules enabled"
}

# ── 5. SMBv1 ──────────────────────────────────────────────
Write-Host "`n5. LEGACY PROTOCOLS" -ForegroundColor White
$smb1 = (Get-SmbServerConfiguration).EnableSMB1Protocol
if ($smb1) {
    Report "FAIL" "SMBv1 ENABLED — disable immediately (WannaCry attack vector)"
} else {
    Report "PASS" "SMBv1 disabled"
}

# ── 6. LOCAL ACCOUNTS ─────────────────────────────────────
Write-Host "`n6. LOCAL ACCOUNTS" -ForegroundColor White
$adminAccount = Get-LocalUser -Name "Administrator" -ErrorAction SilentlyContinue
if ($adminAccount) {
    if ($adminAccount.Enabled) {
        Report "WARN" "Default Administrator account is ENABLED — consider disabling"
    } else {
        Report "PASS" "Default Administrator account disabled"
    }
}

$guestAccount = Get-LocalUser -Name "Guest" -ErrorAction SilentlyContinue
if ($guestAccount -and $guestAccount.Enabled) {
    Report "FAIL" "Guest account ENABLED — disable it"
} else {
    Report "PASS" "Guest account disabled"
}

$localAdmins = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue
if ($localAdmins) {
    Report "INFO" "Local admin accounts: $($localAdmins.Count)"
    foreach ($admin in $localAdmins) {
        Report "INFO" "  - $($admin.Name) ($($admin.ObjectClass))"
    }
}

# ── 7. SECURE BOOT ────────────────────────────────────────
Write-Host "`n7. FIRMWARE SECURITY" -ForegroundColor White
try {
    $secureBoot = Confirm-SecureBootUEFI
    if ($secureBoot) {
        Report "PASS" "Secure Boot enabled"
    } else {
        Report "FAIL" "Secure Boot NOT enabled"
    }
} catch {
    Report "WARN" "Could not determine Secure Boot status (may not be UEFI)"
}

# ── 8. SCREEN LOCK ────────────────────────────────────────
Write-Host "`n8. SCREEN LOCK" -ForegroundColor White
$screenSaver = Get-ItemProperty "HKCU:\Control Panel\Desktop" -Name ScreenSaverIsSecure -ErrorAction SilentlyContinue
if ($screenSaver -and $screenSaver.ScreenSaverIsSecure -eq "1") {
    Report "PASS" "Screen saver requires password"
} else {
    Report "WARN" "Screen saver password protection not confirmed — verify manual lock policy"
}

# ── 9. POWERSHELL LOGGING ─────────────────────────────────
Write-Host "`n9. SECURITY LOGGING" -ForegroundColor White
$psLogging = Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name EnableScriptBlockLogging -ErrorAction SilentlyContinue
if ($psLogging -and $psLogging.EnableScriptBlockLogging -eq 1) {
    Report "PASS" "PowerShell script block logging enabled"
} else {
    Report "WARN" "PowerShell script block logging NOT enabled — attackers use PowerShell extensively"
}

# ── 10. NETWORK ───────────────────────────────────────────
Write-Host "`n10. NETWORK CONFIGURATION" -ForegroundColor White
$netProfiles = Get-NetConnectionProfile
foreach ($np in $netProfiles) {
    if ($np.NetworkCategory -eq "Public") {
        Report "INFO" "Network '$($np.Name)' set to Public (most restrictive)"
    } elseif ($np.NetworkCategory -eq "Private") {
        Report "INFO" "Network '$($np.Name)' set to Private"
    } elseif ($np.NetworkCategory -eq "DomainAuthenticated") {
        Report "INFO" "Network '$($np.Name)' set to Domain"
    }
}

# ── 11. INSTALLED SOFTWARE ────────────────────────────────
Write-Host "`n11. SOFTWARE INVENTORY" -ForegroundColor White
$software = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Where-Object { $_.DisplayName } |
    Select-Object DisplayName, DisplayVersion, Publisher |
    Sort-Object DisplayName
Report "INFO" "Installed applications: $($software.Count)"
Report "INFO" "Review the full list for unauthorized software:"
$software | Select-Object -First 20 | ForEach-Object {
    Report "INFO" "  - $($_.DisplayName) ($($_.DisplayVersion))"
}
if ($software.Count -gt 20) {
    Report "INFO" "  ... and $($software.Count - 20) more (run Get-ItemProperty for full list)"
}

# ── SUMMARY ───────────────────────────────────────────────
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " AUDIT SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PASS: $pass" -ForegroundColor Green
Write-Host "  FAIL: $fail" -ForegroundColor Red
Write-Host "  WARN: $warn" -ForegroundColor Yellow
Write-Host ""

if ($fail -eq 0 -and $warn -eq 0) {
    Write-Host "  STATUS: STRONG — All checks passed" -ForegroundColor Green
} elseif ($fail -eq 0) {
    Write-Host "  STATUS: GOOD — No failures, $warn warnings to review" -ForegroundColor Yellow
} elseif ($fail -le 2) {
    Write-Host "  STATUS: NEEDS ATTENTION — $fail failures to fix" -ForegroundColor Yellow
} else {
    Write-Host "  STATUS: CRITICAL — $fail failures require immediate action" -ForegroundColor Red
}

Write-Host "`n  Full guide: https://github.com/CJCPAs/mythos-launch-response/blob/main/stacks/windows-workstations.md" -ForegroundColor Gray
Write-Host ""
