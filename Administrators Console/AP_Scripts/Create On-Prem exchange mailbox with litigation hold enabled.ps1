# $whatifpreference = 'True'
clear-host
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -ForegroundColor white -BackgroundColor blue

#Header
Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "******* Create Mailboxes ******" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

#Region Header
# Setting up the logging
$logFile= Join-Path -path "C:\Temp" -ChildPath "Create-Remote-mailbox-log-$(Get-date -f "yyyyMMddHHmmss").csv";

# Start Logging
Start-Transcript -Path $logFile
#endregion

#Ensure necessary modules load when needed:
$PSModuleAutoLoadingPreference = "All"

#region licensing
Write-host "       *** This script requires Microsoft PowerShell 7 or higher. ***     *" -ForegroundColor red -BackgroundColor Black
Write-host "                    Windows PowerShell is insufficient.                    " -ForegroundColor Yellow -BackgroundColor Blue
Write-host "*** This should only be used for users with an @kernCounty.com account. ***" -ForegroundColor Green -BackgroundColor white

Write-host "   ************************************************************************"
Write-host "   *                                                                      *"
Write-host "   *                           Kern County ITS                            *"
Write-host "   *                                                                      *"
Write-host "   *  *** Create On-Prem Exchange mailbox and enable Litigation Hold ***  *"
Write-host "   *            ***By Brian Lowry and Robert Sandoval, 2023***            *"
Write-host "   *                                                                      *"
Write-host "   *                 *** Logfile available at C:\Temp ***                 *"
Write-host "   *                                                                      *"
Write-host "   ************************************************************************"
Write-host ""

# Collect user info:
$UserUpn = Read-Host -Prompt "User Account - first part of email address"
$DisplayName = Read-Host -Prompt "Users Display Name - Full Name (First Last)"
$Email = ($UserUpn + "@kerncounty.com")
$UPN = ($UserUpn + "@kerncounty.onmicrosoft.com")

Write-Host "Verify info:"
Write-host "    $DisplayName"
Write-host "    $UserUpn"
Write-host "    $UPN"
Write-host "    $Email"

#******************************************************************************************** 
# Add user to licensing Group...
# 1. Check if AZ powershell module installed
# 2. The Azure PowerShell module will be installed if absent.
# 3. Get AZ Credentials
# 4. Get current membership list to check if new user is already a member, quit if listed
# 5. Add user to membership list
#********************************************************************************************

# Check for AZ Module installed, Install AZ module(if necessary):
Write-Host "   ************************************************************************"
Write-Host "   *                                                                      *"
Write-Host "   *              Verifying Azure modules are installed...                *"
Write-Host "   *                                                                      *"
Write-Host "   ************************************************************************"
Write-host ""

$exonline = Get-InstalledModule -Name ExchangeOnlineManagement
If (-not ($exonline)) {
    Write-Host "                *** Installing Exchange Online Module... ***               " -ForegroundColor white -BackgroundColor Red
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Install-Module -Name ExchangeOnlineManagement -Repository PSGallery -Force
    Import-Module -name ExchangeOnlineManagement
    Write-Host "            *** Exchange Online module successfully installed ***          " -ForegroundColor white -BackgroundColor Green
}
Else {
    Write-Host "                 *** Exchange Online Module is installed ***               " -ForegroundColor black -BackgroundColor yellow
}

$AZinstalled = Get-InstalledModule -Name Az
If (-not ($AZinstalled)) {
    Write-Host "                    *** Installing Azure PS Module... ***                  " -ForegroundColor white -BackgroundColor Red
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Install-Module -Name Az -Repository PSGallery -Force
    Import-Module -name az
    Write-Host "                 *** Azure module successfully installed ***               " -ForegroundColor white -BackgroundColor Green
}
Else {
    Write-Host "                      *** Azure Module is installed ***                    " -ForegroundColor black -BackgroundColor yellow
}

$AZrinstalled = Get-InstalledModule -Name Az.Resources
If (-not ($AZrinstalled)) {
    Write-Host "              *** Installing Azure Resources PS Module... ***               " -ForegroundColor white -BackgroundColor Red
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Install-Module -Name Az.Resources -Repository PSGallery -Force
    Import-Module -name Az.Resources
    Write-Host "           *** Azure resources module successfully installed ***            " -ForegroundColor white -BackgroundColor Green
}
Else {
    Write-Host "                *** Azure Resources Module is installed ***                 " -ForegroundColor black -BackgroundColor yellow
}

Write-host "                                                                           "
Write-host "   ************************************************************************"
Write-host "   *                                                                      *"
Write-host "   *                        Connecting to Azure...                        *"
Write-host "   *                                                                      *"
Write-host "   ************************************************************************"
Write-host ""

$context = Get-AzContext
if (!$context) {
    Connect-AzAccount 
} else {
Write-Host "   *                     Connection to Azure exists                       *" -ForegroundColor black -BackgroundColor Green
}
 
Write-host "                         *** Connected to Azure ***                        " -ForegroundColor black -BackgroundColor Green
Write-host "                                                                           "
Write-host "   ************************************************************************"
Write-host "   *                                                                      *"
Write-host "   *                Adding user to O365 licensing group...                *"
Write-host "   *                                                                      *"
Write-host "   ************************************************************************"
Write-host ""
Write-host "   *Checking if user is already a member of the licensing security group. *"
Write-host "   *                       Please stand by...                             *"

# Get membership list to check if user is already included:
$CurrentMember = Get-AzADGroup -ObjectId "e68a8d67-b116-4d2d-a20d-0e6b6614ac80" | get-AzADGroupMember | Select-Object -Property DisplayName
   Where-Object {
    ($_.DisplayName -match "$DisplayName")
} # End Where-Object

#Add user to sec. group:
If (-not ($CurrentMember)){
    Write-host "                  *** $DisplayName is not licensed. ***                    " -ForegroundColor white -BackgroundColor Red
    $UserID = Get-ADUser -Identity "$UserUpn" | Select-Object -Property ObjectGUID
    Add-AzADGroupMember -TargetGroupObjectId "e68a8d67-b116-4d2d-a20d-0e6b6614ac80" -memberObjectId $UserID
    Write-host "User $DisplayName has been added to the O365 licensing security group and is now licensed." -ForegroundColor white -BackgroundColor Green
}

Else {
    Write-host "          *** User is already a member of the Licensing group. ***         " -ForegroundColor white -BackgroundColor Green
}
#endregion

#region connect to On-Prem Exchange
# Next, connect a session to On-Prem Exchange server:
# Exchange Powershell connection script:
Write-host "   ************************************************************************"
Write-host "   *                                                                      *"
Write-host "   *               Connecting to On-Prem Exchange Server...               *"
Write-host "   *                                                                      *"
Write-host "   *                                                                      *"
Write-host "   *      Please enter On-premise Exchange administrative credentials     *" -ForegroundColor red
Write-host "   *                      Example: KernCounty\UserN                       *" -ForegroundColor red
Write-host "   *                                                                      *"
Write-host "   ************************************************************************"
Write-host ""

# Check if a session already exists and enter, or create new session:
Write-host "   *                     checking for active session                      *" -ForegroundColor blue -BackgroundColor White
Write-host "   *                         Please stand by...                           *" -ForegroundColor blue -BackgroundColor White

[CmdletBinding()]
[OutputType([int])]

$session = Get-PsSession | Where-Object {
    ($_.ComputerName -match "ITS-EXCH01.kerncounty.com") -and ($_.State -match "Opened")
} # End Where-Object


If (-not ($session)) {
    $Params = @{
    	ConfigurationName = "Microsoft.Exchange"
    	ConnectionUri = "https://ITS-EXCH01.kerncounty.com/PowerShell/"
    	Authentication = "Basic"
    	AllowRedirect = $True
    } # End Params
    
    Write-host "                         *** Creating new session ***                      " -ForegroundColor green -BackgroundColor black
    $ExchCredential = Get-Credential -Message "Please enter On-premise Exchange administrative credentials (domain\user)"
    $ExchSession = New-PSSession @params -Credential $ExchCredential
    Import-PSSession $ExchSession -AllowClobber
} # End -not $session

Else {
    Write-host "                           *** Session exists ***                          " -ForegroundColor black -BackgroundColor green
}
#Endregion

# Check for Exchange Module installed, Install Exchange module(if necessary):
Write-host "   ************************************************************************"
Write-host "   *                                                                      *"
Write-host "   *              Verifying Exchange module is installed...               *"
Write-host "   *                                                                      *"
Write-host "   ************************************************************************"
Write-host ""

$EXinstalled = Get-InstalledModule -Name ExchangePowerShell
If (-not ($EXinstalled)) {
    Write-host "               *** Installing Exchange PS Module... ***                   " -ForegroundColor white -BackgroundColor Red
    Install-Module -Name ExchangePowerShell
    Import-Module -name ExchangePowerShell
    Write-host "            *** Exchange module successfully installed ***                " -ForegroundColor white -BackgroundColor Green
}
Else {
    Write-host "                 *** Exchange Module is installed ***                     " -ForegroundColor green
}

#region Create mailbox
Write-host "   ************************************************************************"
Write-host "   *                                                                      *"
Write-host "   *                       Enabling remote mailbox...                     *"
Write-host "   *                                                                      *"
Write-host "   *                       If a return error states:                      *" -ForegroundColor Green
Write-Host "   *           'Enable-RemoteMailbox: This task does not support          *" -ForegroundColor RED -BackgroundColor black
Write-Host "   *                       recipients of this type'                       *" -ForegroundColor RED -BackgroundColor black
Write-Host "   *               It means the mailbox is already enabled.               *" -ForegroundColor Green
Write-host "   *                                                                      *"
Write-host "   ************************************************************************"
Write-host ""

# Enable Remote Mailbox:
Enable-RemoteMailbox "$DisplayName" -RemoteRoutingAddress ($UserUpn + "@kerncounty.mail.onmicrosoft.com")

#----------------------
#Verify mailbox has been created:
$MBextant = Get-RemoteMailbox -Identity $Email #Proves the mailbox exists by retrieving values
Write-host "UserUPN = $UserUPN"
Write-host "Email = $Email" #Proves the connection exists by displaying retrieved values
Write-host "MB Exists = $MBextant" #Proves the mailbox exists by displaying retrieved values
Write-host "UPN = $UPN"
Write-host "DisplayName = $DisplayName"


#If not created, wait 60 seconds and try to verify again, up to 3 times:
if (-not($MBextant)) {
    For($counter =0; $counter -le 2;$counter++){
        If (-not ($MBextant)){
            Write-host " *** Waiting 60 sec for account to be verified on the server... *** " -ForegroundColor black -BackgroundColor yellow
            Start-Sleep -Seconds 10
            $MBextant = Get-RemoteMailbox -Identity $Email
        }

        #If try count is 3 or higher, exit script:
        ElseIf ($counter -ge 2){
            Write-host "                 ***Cannot Verify Mailbox - Closing***              " -ForegroundColor Yellow -BackgroundColor Red
            Exit
        }
    }
} Else {}
#endregion

#region set litigation hold
#Connect to ExchangeOnline
Write-host "   ************************************************************************"
Write-host "   *                                                                      *"
Write-host "   *                      Connecting to ExchangeOnline                    *"
Write-host "   *         -Use Azure `"KernCounty.onmicrosoft.com`" account creds        *" -ForegroundColor Red -BackgroundColor black
Write-host "   *                                                                      *"
Write-host "   ************************************************************************"
Write-host ""

Connect-ExchangeOnline

Write-host "   ************************************************************************"
Write-host "   *                                                                      *"
Write-host "   *                 Setting litigation hold to 'true'...                 *"
Write-host "   *                                                                      *"
Write-host "   ************************************************************************"
Write-host ""

# If mailbox exists, check if Litigation hold is enabled, if not extant, exit:
Write-Host "   *** Verifying Litigation hold is enabled. Please stand by... ***    " -ForegroundColor white -BackgroundColor Red
If (-Not ($MBextant)){
    Write-Host "         Cannot find a Mailbox for $Email. Exiting.                " -ForegroundColor black -BackgroundColor Red
    Exit
}
Else {
    $LitHoldEnabled = Get-mailbox -identity $DisplayName | where-object {
        ($_.LitigationHoldEnabled -eq $True)
    }
}

# If Lit Hold not enabled, enable it then re-check, or report as already enabled.
If (-Not ($LitHoldEnabled)){
    write-host "            Litigation Hold not enabled. Enabling now.                 " -ForegroundColor black -BackgroundColor Red
    Set-Mailbox $email -LitigationHoldEnabled $true
    # RE-check if Litigation hold is enabled:
    Write-Host "       *** Verifying Litigation hold is enabled. Again. ***            " -ForegroundColor Yellow -BackgroundColor Red
    $LitHoldEnabled = Get-mailbox -identity $DisplayName | where-object {
        ($_.LitigationHoldEnabled -eq $True)
    }
} Else {
    Write-host "            *** Litigation hold is already enabled ***                 " -ForegroundColor white -BackgroundColor Green
}
# Check to see if LitHold enabled again, if not try again, and again.
If (-Not ($LitHoldEnabled)){
    write-host "         Litigation Hold is still not enabled. Trying again.           " -ForegroundColor black -BackgroundColor Red
    Set-Mailbox $email -LitigationHoldEnabled $true
    # RE-check if Litigation hold is enabled:
    $LitHoldEnabled = Get-mailbox -identity $DisplayName | where-object {
        ($_.LitigationHoldEnabled -eq $True)
    }
}
Else {
    Write-host "                  Litigation Hold Enabled = True                       " #Proves lit hold check is working
}

If (-Not ($LitHoldEnabled)){
    write-host "  Unable to set Litigation hold. Please use the M365 Console. Exiting. " -ForegroundColor black -BackgroundColor Red
    Exit
}
Else {
    Write-Host "                    *** Litigation hold enabled ***                    " -ForegroundColor white -BackgroundColor Green
}

# Destroy PS Session to On-Prem Exchange
$session = Get-PsSession | Where-Object {
    ($_.ComputerName -match "ITS-EXCH01.kerncounty.com") -and ($_.State -match "Opened")
}
write-host "$session"
$SessID = $session.id
write-host "Session ID = $SessID"
Remove-PSSession $SessID

Write-host "   ************************************************************************"
Write-host "   *                                                                      *"
Write-host "   *                          Operation Complete.                         *"
Write-host "   * $Email has been created with Litigation Hold Enabled "
Write-host "   *                                                                      *"
Write-host "   ************************************************************************"

#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"

# Wait for logging to complete
Stop-Transcript