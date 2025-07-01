# GA PIM Request script by B.Lowry
#requires -version 7
#requires -runasadministrator

# Set Environment Variables
[console]::windowwidth=116;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.WindowTitle="Entra PIM Request - Global Admin";

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

# Add helper function for centering text
function Write-CenteredText {
    param([string]$Text, [System.ConsoleColor]$ForegroundColor = [System.ConsoleColor]::White)
    
    # Split the text into lines
    $lines = $Text -split "`n"
    $maxLength = ($lines | Measure-Object -Property Length -Maximum).Maximum
    $windowWidth = $Host.UI.RawUI.WindowSize.Width
    
    foreach ($line in $lines) {
        # Calculate padding based on the maxLength for consistent alignment
        $padding = [Math]::Max(0, [Math]::Floor(($windowWidth - $maxLength) / 2))
        Write-Host (" " * $padding) -NoNewline
        Write-Host $line -ForegroundColor $ForegroundColor
    }
}

# Get window width safely
try {
    $hostWidth = $Host.UI.RawUI.WindowSize.Width
} catch {
    $hostWidth = 80  # Default fallback width
    Write-Log "Could not detect window width, using default: $_" -Level Warning
}

# Ensure the Microsoft.Graph module is installed
Write-Log "Setting up Microsoft.Graph module...`n" -Level Info
try {
    $module = Get-Module -ListAvailable -Name Microsoft.Graph | 
        Sort-Object Version -Descending | 
        Select-Object -First 1
    
    if (-not $module) {
        Write-Log "Microsoft.Graph module not installed. Installing version $($config.RequiredModuleVersion)..." -Level Warning
        Install-Module -Name Microsoft.Graph -RequiredVersion $config.RequiredModuleVersion -Force -Scope CurrentUser
    } elseif ($module.Version -lt [version]$config.RequiredModuleVersion) {
        Write-Log "Updating Microsoft.Graph module to version $($config.RequiredModuleVersion)..." -Level Warning
        Update-Module -Name Microsoft.Graph -RequiredVersion $config.RequiredModuleVersion -Force
    }
    #Write-Log "Importing Microsoft.Graph module..." -Level Info
    #Import-Module Microsoft.Graph -MinimumVersion $config.RequiredModuleVersion
} catch {
    Write-Log "Failed to setup Microsoft.Graph module: $_" -Level Error
    exit 1
}

# Import Microsoft.Graph modules:
Write-Log "Importing Microsoft.Graph submodules...`n" -Level Info
try {
    Write-Log "Importing Microsoft.Graph.Identity.Governance" -Level Info
    Import-Module Microsoft.Graph.Identity.Governance -ErrorAction Stop
    Write-Log "Microsoft.Graph.Identity.Governance module imported successfully`n"
} catch {
    Write-Log "Failed to import Microsoft.Graph.Identity.Governance module: $_" -Level Error
    exit 1
}
try {
    Write-Log "Importing Microsoft.Graph.Authentication" -Level Info
    Import-Module Microsoft.Graph.Authentication -ErrorAction Stop #
    Write-Log "Microsoft.Graph.Authentication module imported successfully`n"
} catch {
    Write-Log "Failed to import Microsoft.Graph.Authentication module: $_" -Level Error
    exit 1
}

try {
    Write-Log "Importing Microsoft.Graph.Identity.DirectoryManagement " -Level Info

    # Check if the module is installed
    if (Get-Module -ListAvailable Microsoft.Graph.Identity.DirectoryManagement ) {
        Import-Module Microsoft.Graph.Identity.DirectoryManagement  -ErrorAction Stop
        Write-Log "Microsoft.Graph.Identity.DirectoryManagement  module imported successfully`n"
    } else {
        Write-Log "Microsoft.Graph.Identity.DirectoryManagement  module not found. Installing..." -Level Warning
        Install-Module -Name Microsoft.Graph.Identity.DirectoryManagement  -Force -Scope CurrentUser
        Import-Module Microsoft.Graph.Identity.DirectoryManagement  -ErrorAction Stop
        Write-Log "Microsoft.Graph.Identity.DirectoryManagement  module installed and imported successfully`n"
    }
} catch {
    Write-Log "Failed to import Microsoft.Graph.Identity.DirectoryManagement  module: $_" -Level Error
    exit 1
}


# Debugging entry
Write-Log "Module Installation Complete" -level Info

Write-Log "Script started"

###############################################################################
#region header

Clear-Host
# Header
$BANNER1 = @"
__________ .___    _____    
\______   \|   |  /     \   
 |     ___/|   | /  \ /  \  
 |    |    |   |/    Y    \ 
 |____|    |___|\____|__  / 
                        \/  
"@
$BANNER2 = @"
 ______     ______     ______     __  __     ______     ______     ______  
/\  == \   /\  ___\   /\  __ \   /\ \/\ \   /\  ___\   /\  ___\   /\__  _\ 
\ \  __<   \ \  __\   \ \ \_\_\  \ \ \_\ \  \ \  __\   \ \___  \  \/_/\ \/ 
 \ \_\ \_\  \ \_____\  \ \___\_\  \ \_____\  \ \_____\  \/\_____\    \ \_\ 
  \/_/ /_/   \/_____/   \/___/_/   \/_____/   \/_____/   \/_____/     \/_/ 
"@

# Display centered banners
Clear-Host
Write-Host ""
Write-Host ""
Write-Host ""
Write-CenteredText $BANNER1 -ForegroundColor Blue
Write-CenteredText $BANNER2 -ForegroundColor Blue
Write-Host ""
Write-Host ""
Write-CenteredText "This script will submit a PIM request for Global Administrator." -ForegroundColor Yellow
Write-CenteredText "Please select the required Tenant and provide your Tenant Admin credentials" -ForegroundColor Yellow
Write-Host ""
Write-Host ("*" * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor DarkRed
Write-Host ""

###############################################################################
#Region Connect to Azure\Graph

# Tenant selection
Read-Host "`n                                  Select Tenant to connect to:`n                                  1. County of Kern`n                                  2. Kern County District Attorney Office`n                                  3. Kern County Human Services`n                                  4. KernBHRS`n`n                               Enter the number of the Tenant to connect to: " -OutVariable TenantSelection
Switch ($TenantSelection) {
    1 { $TenantId = 'e0f2e4b5-0515-4028-99f2-2e7a43fe5379' }
    2 { $TenantId = '795d7eb4-bae3-461a-a2ad-4a4c1c54236d' }
    3 { $TenantId = '03a1b294-969c-49cb-92e2-5490cbd22da9' }
    4 { $TenantId = '04e5e3da-97ab-45dc-8a57-a66390b2653f' }
    Default { Write-Log "Invalid selection, exiting script" -Level Error; exit 1 }
}

# Connection Header
Write-Host ""
Write-CenteredText "************************************************************************" -ForegroundColor Blue
Write-CenteredText "*                                                                      *" -ForegroundColor Blue
Write-CenteredText "*                    Connecting to Azure\MS Graph...                   *" -ForegroundColor Blue
Write-CenteredText "*                                                                      *" -ForegroundColor Blue
Write-CenteredText "************************************************************************" -ForegroundColor Blue
Write-Host ""   

# VERIFY MG CONNECTION, CONNECT IF NOT.
$IsConnected = Get-MgContext
if ($IsConnected) {
    Write-CenteredText "Currently connected to Azure as $($IsConnected.Account)" -ForegroundColor Yellow
    $confirm = Read-Host "                      Use the existing connection? (Y/N)"
    if($confirm -match "[yY]") {
        Write-Log "Using established connection" -Level Info
    } Else {
        Write-CenteredText "Disconnecting existing connection..." -ForegroundColor Yellow
        Disconnect-MgGraph
        # Connect to Azure
        Write-Log "Current connection ended. Connecting to Azure\Graph..." -Level Warning
        try {
            Connect-MgGraph -TenantId $TenantId -Scopes "RoleManagement.ReadWrite.Directory Directory.Read.All" -NoWelcome -ErrorAction Stop 
        } catch {
            Write-Log "Failed to connect to Graph API: $_" -Level Error
            exit 1
        }
    } 
} 
Else {
    # Connect to Azure
    Write-Log "Connecting to Azure\Graph..." -Level Warning
    try {
        Connect-MgGraph -TenantId $TenantId -Scopes "RoleManagement.ReadWrite.Directory Directory.Read.All" -NoWelcome -ErrorAction Stop 
    } catch {
        Write-Log "Failed to connect to Graph API: $_" -Level Error
        exit 1
    }
} $IsConnected = Get-MgContext

If (!$IsConnected) {
    Write-Log "Unable to connect to Azure" -Level Error
    exit   
} Else { 
    Write-Log "Connected to Azure\Graph" -Level Info
    Write-CenteredText "You may now execute PowerShell cmdlets in Azure." -ForegroundColor Green
}
Write-Host ("*" * $hostWidth) -ForegroundColor Red

Write-Host ""
Write-CenteredText "This script will request Global Admin access for 1 hour." -ForegroundColor Yellow
Write-CenteredText "Please ensure you have a valid justification ready." -ForegroundColor Yellow
Write-Host ""
#Write-Host "Press any key to continue..." -ForegroundColor Red
#$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

###############################################################################
# Config info
# Configuration variables
Write-Host ""
Write-CenteredText "************************************************************************" -ForegroundColor Blue
Write-CenteredText "*                                                                      *" -ForegroundColor Blue
Write-CenteredText "*                                 PIM                                  *" -ForegroundColor Blue
Write-CenteredText "*                       Requesting Global Admin...                     *" -ForegroundColor Blue
Write-CenteredText "*                                                                      *" -ForegroundColor Blue
Write-CenteredText "************************************************************************" -ForegroundColor Blue
Write-Host "" 

$config = @{
    UserId = $null # Will be populated after Connect-MgGraph
    RoleId = '62e90394-69f5-4237-9190-012177145e10'
    TenantId = $null # Will be populated in Tenant Selection
    RequiredModuleVersion = '2.5.0'
    ActiveDuration = 60 # minutes
    VerificationTimeout = 30 # seconds
    RequiredScopes = @(
        "User.Read.All",
        "Directory.Read.All",
        "RoleManagement.ReadWrite.Directory",
        "PrivilegedAccess.ReadWrite.AzureAD"
    )
}

# Prompt for User Principal Name (UPN)
$UserPrincipalName = Read-Host "                              Enter your Azure Admin email address (UPN)`n                           Example: Lowryb-admin@kerncounty.onmicrosoft.com"

# Get UserID from UPN
try {
    $user = Get-MgUser -Filter "userPrincipalName eq '$UserPrincipalName'" -ErrorAction Stop
    if ($user) {
        $config.UserId = $user.Id
        Write-Log "User ID resolved: $($config.UserId)" -Level Info
    } else {
        Write-Log "User not found with UPN '$UserPrincipalName'" -Level Error
        exit 1
    }
} catch {
    Write-Log "Failed to retrieve user information: $_" -Level Error
    exit 1
}

#############################################################################################
# PIM request section
Write-Log "Starting Entra PIM Global Admin Request Script..." -Level Info

try {
    Write-Progress -Activity "Role Activation" -Status "Requesting Global Admin role..." -PercentComplete 25
    
    $scheduleInfo = @{
        startDateTime = (Get-Date).ToUniversalTime().ToString("o")
        expiration = @{
            type = "AfterDuration"
            duration = "PT$($config.ActiveDuration)M"
        }
    }
    
    $params = @{
        Action = "selfActivate"
        PrincipalId = $config.UserId
        RoleDefinitionId = $config.RoleId
        DirectoryScopeId = "/"
        Justification = Read-Host "                              Enter justification for Global Admin activation"
        ScheduleInfo = $scheduleInfo
    }
    
    Try {
        $result = New-MgRoleManagementDirectoryRoleAssignmentScheduleRequest -BodyParameter $params -ErrorAction Stop
    } catch {
        Write-Log "Failed to submit PIM request: $_" -Level Error
        exit 1
    }
    
    Write-Progress -Activity "Role Activation" -Status "Verifying activation..." -PercentComplete 50

    # Verify activation with timeout
    $startTime = Get-Date
    $verified = $false
    $verificationTimeoutMinutes = 15
    $verificationIntervalSeconds = 15
    $maxVerificationTime = (New-TimeSpan -Minutes $verificationTimeoutMinutes)
    
    while (-not $verified -and ((Get-Date) - $startTime) -lt $maxVerificationTime) {
        Write-Log "Checking for role activation..." -Level Info
        Start-Sleep -Seconds $verificationIntervalSeconds
        $filter = "principalId eq '$($config.UserId)' and roleDefinitionId eq '$($config.RoleId)'"
        try {
            $activeAssignments = Get-MgRoleManagementDirectoryRoleAssignmentSchedule -Filter $filter -ErrorAction Stop
            if ($activeAssignments) {
                $verified = $true
                Write-Log "Global Admin role successfully activated for $($config.ActiveDuration) minutes" -Level Info
            } else {
                Write-Log "Role not yet active. Retrying..." -Level Info
            }
        } catch {
            Write-Log "Error checking role activation: $_" -Level Warning
        }
    }
    
    if (-not $verified) {
        Write-Log "Role activation verification timed out - please check Entra portal" -Level Warning
    }
    
    Write-Progress -Activity "Role Activation" -Completed
} catch {
    Write-Progress -Activity "Role Activation" -Completed
    Write-Log "                              Failed to activate Global Admin role: $_" -Level Error
    Write-Log "Stack Trace: $($_.ScriptStackTrace)" -Level Error
    exit 1
} finally {
    # Cleanup
    Remove-Variable -Name config -ErrorAction SilentlyContinue
}


Write-Log "Script completed"