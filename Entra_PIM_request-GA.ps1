Clear-Host
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

# Add logging function at the start
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$logFile = Join-Path $scriptPath "PIM_GA_Request.log"

function Write-Log {
    param($Message, [ValidateSet('Info','Warning','Error')]$Level = 'Info')
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Add-Content -Path $logFile -Value $logMessage
    
    # Also write to console with color
    switch ($Level) {
        'Info' { Write-Host $logMessage }
        'Warning' { Write-Host $logMessage -ForegroundColor Yellow }
        'Error' { Write-Host $logMessage -ForegroundColor Red }
    }
}

Write-Log "Script started"

# Environment Variables:
$hostWidth = $Host.UI.RawUI.WindowSize.Width

# Ensure the Microsoft.Graph module is installed
try {
    if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
        Write-Log "Microsoft.Graph module not installed. Installing..." -Level Warning
        Install-Module -Name Microsoft.Graph -Force -Scope CurrentUser -ErrorAction Stop
        Write-Log "Microsoft.Graph module installed successfully"
    } else {
        Write-Log "Microsoft.Graph module is already installed"
    }
    Write-Host " Importing Microsoft.Graph module..."
    Import-Module Microsoft.Graph
} catch {
    Write-Log "Failed to install/import Microsoft.Graph module: $_" -Level Error
    exit 1
}

# Debugging entry
Write-Log "Module Installation Complete"

# Header
Write-Host "                                                                           "
Write-Host "   ************************************************************************"
Write-Host "   *                                                                      *"
Write-Host "   *                    Connecting to Azure\MS Graph...                   *"
Write-Host "   *                                                                      *"
Write-Host "   ************************************************************************"
Write-Host ""

# VERIFY MG CONNECTION, CONNECT IF NOT.
$IsConnected = Get-MgContext
if ($IsConnected) {
    Write-Log "Using established connection" -Level Info
} Else {
    # Connect to Azure
    Write-Log "Not connected. Connecting to Azure\Graph..." -Level Warning
    Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All" -NoWelcome
    $IsConnected
}
$IsConnected = Get-MgContext
If ( !$IsConnected) {
    Write-Log "Unable to connect to Azure" -Level Error
    exit   
} Else { 
    Write-Log "Connected to Azure\Graph" -Level Info
    Write-Log "You may now execute PowerShell cmdlets in Azure." -Level Info
}
Write-Host ("*" * $hostWidth) -ForegroundColor Red

Write-Host ""
Write-Host "This script will request Global Admin access for 4 hours."
Write-Host "This script is only for Brian Lowry. If you are not Brian Lowry, please stop now."
Write-Host ""
Write-Host ""

# Replace with your own user objectId if needed
$userId = 'fb40e507-1fca-44c4-b825-23de6244e10f'

# Global Admin role (Company Administrator) role ID
$roleId = '62e90394-69f5-4237-9190-012177145e10'

# Your tenant ID
$tenantId = (Get-MgOrganization).Id

Write-Log "Starting Entra PIM Global Admin Request Script..." -Level Info

# PIM request section
try {
    Write-Log "Requesting Global Admin role activation..."
    $params = @{
        Action = "selfActivate"
        PrincipalId = $userId
        RoleDefinitionId = $roleId
        DirectoryScopeId = "/"
        Justification = "Scheduled administrative tasks"
        ScheduleInfo = @{
            StartDateTime = (Get-Date).ToUniversalTime().ToString("o")
            ExpirationDateTime = (Get-Date).AddHours(4).ToUniversalTime().ToString("o")
        }
    }

    New-MgIdentityGovernancePrivilegedAccessRoleAssignmentRequest -BodyParameter $params
    Write-Log "PIM request submitted successfully"

    Start-Sleep -Seconds 5

    # Verify activation
    $filter = "principalId eq '$userId' and roleDefinitionId eq '$roleId'"
    $activeAssignments = Get-MgIdentityGovernancePrivilegedAccessRoleAssignmentScheduleInstance -Filter $filter

    if ($activeAssignments) {
        Write-Log "Global Admin role successfully activated for 4 hours"
    } else {
        Write-Log "Could not verify role activation - please check Entra portal" -Level Warning
    }
} catch {
    Write-Log "Failed to activate Global Admin role: $_" -Level Error
    Write-Log "Stack Trace: $($_.ScriptStackTrace)" -Level Error
    exit 1
}

Write-Log "Script completed"