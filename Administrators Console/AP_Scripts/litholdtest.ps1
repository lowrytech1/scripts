Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

# Header
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "**** Litigation Hold Check ****" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue

# Collect user info:
$UserUpn = Read-Host -Prompt "User Account - first part of email address"
$DisplayName = Read-Host -Prompt "Users Display Name - Full Name (First Last)"
$Email = ($UserUpn + "@kerncounty.com")
$UPN = ($UserUpn + "@kerncounty.onmicrosoft.com")

Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "**Connect to On-Prem Exchange**" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-host ""
Write-Host "   ************************************************************************"
Write-Host "   *                                                                      *"
Write-Host "   *               Connecting to On-Prem Exchange Server...               *"
Write-Host "   *                                                                      *"
Write-Host "   *                                                                      *"
Write-Host "   *     On-premise Exchange administrative credentials (domain\user)     *" -ForegroundColor red
Write-Host "   *                                                                      *"
Write-Host "   ************************************************************************"
Write-host ""

# Check if a session already exists and enter, or create new session:
Write-host "   *                      checking for active session                      *" -ForegroundColor black -BackgroundColor white

[CmdletBinding()]
[OutputType([int])]

$session = Get-PsSession | Where-Object {
    ($_.ComputerName -match "ITS-EXCH01.kerncounty.com") -and ($_.State -match "Opened")
} # End Where-Object
write-host "                       *** Current Session: $Session ***  "

If (-not ($session)) {
    $Params = @{
    	ConfigurationName = "Microsoft.Exchange"
    	ConnectionUri = "https://ITS-EXCH01.kerncounty.com/PowerShell/"
    	Authentication = "Basic"
    	AllowRedirect = $True
    } # End Params
    write-host "                   *** Creating new session ***                        "

    #Obtain On-prem Exchange server credentials:
    $UserCredential = Get-Credential -Message "Please enter On-premise Exchange administrative credentials (domain\user)"
    $ExchSession = New-PSSession @params -Credential $UserCredential
    Import-PSSession $ExchSession -AllowClobber
} #End -not $session
Else {
    Write-host "                  *** Current Session $session  ***                       " -ForegroundColor black -BackgroundColor green 
    #Import-PSSession $Session -AllowClobber
}

# Connect to Azure:
Write-Output "                                                                           "
Write-Output "   ************************************************************************"
Write-Output "   *                                                                      *"
Write-Output "   *                        Connecting to Azure...                        *"
Write-Output "   *                                                                      *"
Write-Output "   ************************************************************************"
Write-Output ""

if ([string]::IsNullOrEmpty($(Get-AzContext))) {Connect-AzAccount}
#if ([string]::IsNullOrEmpty($(Get-AzContext.Account))) {Connect-AzAccount}
#if ([string]::IsNullOrEmpty($(Get-AzContext.Account))) {Connect-AzAccount}
if ([string]::IsNullOrEmpty($(Get-AzContext.Account))) {Write-Host "Unable to connect to Azure"}
else {
     Write-Output "                         *** Connected to Azure ***                        " -ForegroundColor black -BackgroundColor Green
     Write-Output ""
}
#Connect-AzAccount
#VERIFY AZ CONNECT.

# Check if MB exists:
Write-host "Verify user info:" -ForegroundColor yellow -BackgroundColor Blue
$MBextant = Get-remotemailbox -Identity $UPN
Write-host "Email = $Email"
Write-host "MBextant = $MBextant"
Write-host "UPN = $UPN"
Write-host "DisplayName = $DisplayName"

# If mailbox exists, check if Litigation hold is enabled:
If (-Not ($MBextant)){
    Write-Host "Cannot find a Mailbox for $Email. CTRL+C to quit." -ForegroundColor black -BackgroundColor Red
}
Else {
    Write-Host "   ************************************************************************" -ForegroundColor Yellow -BackgroundColor Red
    Write-Host "   *                                                                      *" -ForegroundColor Yellow -BackgroundColor Red
    Write-Host "   *     Verifying Litigation hold is enabled. Please stand by...         *" -ForegroundColor Yellow -BackgroundColor Red
    Write-Host "   *                                                                      *" -ForegroundColor Yellow -BackgroundColor Red
    Write-Host "   ************************************************************************" -ForegroundColor Yellow -BackgroundColor Red
    Write-Host ""
    $LitHoldEnabled = Get-mailbox -identity $DisplayName | where-object {
        ($_.LitigationHoldEnabled -eq $True)
    }
}

If (-Not ($LitHoldEnabled)){
    write-host "           Litigation Hold not enabled. Enabling now.     " -ForegroundColor black -BackgroundColor Red
    Set-Mailbox $email -LitigationHoldEnabled $true
    # RE-check if Litigation hold is enabled:
    Write-Host "       *** Verifying Litigation hold is enabled. Again. ***        " -ForegroundColor Yellow -BackgroundColor Red
    $LitHoldEnabled = Get-mailbox -identity $DisplayName | where-object {
        ($_.LitigationHoldEnabled -eq $True)
    }
}
Else {
    Write-Output "          *** Litigation hold is already enabled ***                 " -ForegroundColor white -BackgroundColor Green
}

If (-Not ($LitHoldEnabled)){
    write-host "         Litigation Hold is still not enabled. Trying again.     " -ForegroundColor black -BackgroundColor Red
    Set-Mailbox $email -LitigationHoldEnabled $true
    # RE-check if Litigation hold is enabled:
    Write-Host "      *** Verifying Litigation hold is enabled. Again. Again. ***     " -ForegroundColor Yellow -BackgroundColor Red
    $LitHoldEnabled = Get-mailbox -identity $DisplayName | where-object {
        ($_.LitigationHoldEnabled -eq $True)
    }
}
Else {
    Write-Output "Litholdenabled = $LitHoldEnabled" #Proves lit hold check is working
}

If (-Not ($LitHoldEnabled)){
    write-host "   Unable to set Litigation hold. Please use the M365 Console.     " -ForegroundColor black -BackgroundColor Red
}
Else {
    Write-Host "                    *** Litigation hold enabled ***                   " -ForegroundColor white -BackgroundColor Green
}

#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"