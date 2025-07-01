# Change email of O365 Group using Exchange Online PowerShell module by B.Lowry
# Check if Exchange Online PowerShell module is installed
$moduleInstalled = Get-Module -ListAvailable -Name ExchangeOnlineManagement
if (-not $moduleInstalled) {
    Write-Host "Exchange Online PowerShell module not found. Installing..." -ForegroundColor Yellow
    try {
        Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber -Scope CurrentUser
        Write-Host "Module installed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error installing module: $($_.Exception.Message)" -ForegroundColor Red
        exit
    }
}

# Import the module
try {
    Import-Module ExchangeOnlineManagement
    Write-Host "Exchange Online PowerShell module imported successfully" -ForegroundColor Green
}
catch {
    Write-Host "Error importing module: $($_.Exception.Message)" -ForegroundColor Red
    exit
}

# Connect to Exchange Online
Connect-ExchangeOnline

# Get current group details and change email
$groupName = Read-Host "Enter the display name of the Office 365 group"
try {
    $group = Get-UnifiedGroup -Identity $groupName -ErrorAction Stop
    $newEmail = Read-Host "Enter the new email address"
    
    # Ask if the new address should be primary
    $setPrimary = Read-Host "Do you want to set this as the primary email address? (Y/N)"
    
    if ($setPrimary.ToUpper() -eq 'Y') {
        # Set as primary SMTP address
        Set-UnifiedGroup -Identity $groupName -PrimarySmtpAddress $newEmail
        Write-Host "Successfully set '$newEmail' as primary email address for group '$groupName'" -ForegroundColor Green
    } else {
        # Add as secondary email address
        $emailAddresses = $group.EmailAddresses
        $emailAddresses += "smtp:$newEmail"
        Set-UnifiedGroup -Identity $groupName -EmailAddresses $emailAddresses
        Write-Host "Successfully added '$newEmail' as secondary email address for group '$groupName'" -ForegroundColor Green
    }
} 
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    Disconnect-ExchangeOnline -Confirm:$false
}
