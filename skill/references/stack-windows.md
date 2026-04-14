# Windows Workstation Hardening Reference

## Critical Checks (PowerShell)

```powershell
# 1. Update status
(Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 1).InstalledOn

# 2. BitLocker
Get-BitLockerVolume | Select-Object MountPoint, VolumeStatus, ProtectionStatus

# 3. Defender status
Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, IsTamperProtected

# 4. Firewall
Get-NetFirewallProfile | Select-Object Name, Enabled

# 5. SMBv1
(Get-SmbServerConfiguration).EnableSMB1Protocol  # Must be False

# 6. Secure Boot
Confirm-SecureBootUEFI  # Must be True
```

## Hardening Actions

1. Enable BitLocker on all drives (AES-256)
2. Enable Controlled Folder Access: `Set-MpPreference -EnableControlledFolderAccess Enabled`
3. Disable SMBv1: `Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force`
4. Disable default Administrator account: `Disable-LocalUser -Name "Administrator"`
5. Disable macros in Office (Group Policy or per-app Trust Center)
6. Enable PowerShell script block logging (Group Policy)
7. Enable ASR rules (block Office child processes, email executables, credential stealing)
8. Remove local admin rights from daily-use accounts
9. Set screen lock to 5 minutes

## Mythos Context
Microsoft is Glasswing partner. Windows patches will accelerate through July 2026. Configuration is user responsibility.
