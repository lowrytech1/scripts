# Script to configure SCHANNEL event logging by B.Lowry - 2025
# Sets EventLogging to 0x0007 (log all events - informational, success, warnings, and errors)

#Requires -RunAsAdministrator

# Create registry backup before making changes
$backupFolder = "C:\1ts"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = "$backupFolder\HKLM_SCHANNEL_$timestamp.reg"

# Ensure backup folder exists
if (-not (Test-Path -Path $backupFolder)) {
    try {
        New-Item -Path $backupFolder -ItemType Directory -Force | Out-Null
        Write-Host "Created backup directory: $backupFolder" -ForegroundColor Green
    } catch {
        Write-Error "Failed to create backup directory: $_"
        exit 1
    }
}

# Create registry backup
try {
    Write-Host "Creating registry backup to $backupFile..."
    $regPath = "HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL"
    reg export $regPath $backupFile /y | Out-Null
    
    if (Test-Path -Path $backupFile) {
        Write-Host "Registry backup created successfully." -ForegroundColor Green
    } else {
        Write-Warning "Registry backup file not found after export."
    }
} catch {
    Write-Error "Failed to create registry backup: $_"
    # Continue with script - we'll warn but not exit
}

# Define registry path and value to set
$registryPath = "HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL"
$valueName = "EventLogging"
$value = 7  # 0x0007 for logging all events

try {
    # Check if the registry path exists
    if (-not (Test-Path $registryPath)) {
        Write-Host "Registry path not found. Creating it now..."
        New-Item -Path $registryPath -Force | Out-Null
    }

    # Set the registry value
    Write-Host "Setting SCHANNEL EventLogging to 0x0007 (log all events)..."
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $value -Type DWord -Force
    
    # Verify the change was made successfully
    $currentValue = (Get-ItemProperty -Path $registryPath -Name $valueName).$valueName
    
    if ($currentValue -eq $value) {
        Write-Host "Successfully configured SCHANNEL logging to capture all events (0x0007)." -ForegroundColor Green
    } else {
        Write-Warning "Verification failed. Current value is 0x$('{0:X}' -f $currentValue) instead of 0x0007."
    }
} catch {
    Write-Error "Failed to modify the registry: $_"
    exit 1
}

Write-Host "`nConfiguration complete. You need to restart the system for changes to take full effect."