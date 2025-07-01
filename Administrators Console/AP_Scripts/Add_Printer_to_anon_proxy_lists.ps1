Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"


#Header

Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "** Add printer to Anon Relay **" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

# Function to validate IP address format
function Validate-IPAddress {
    param (
        [string]$ipAddress
    )
    if ($ipAddress -match '^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$') {
        return $true
    } else {
        return $false
    }
}

# Prompt for printer IP address
$printerIP = Read-Host -Prompt "Enter the printer IP address"

# Validate IP address
if (-not (Validate-IPAddress -ipAddress $printerIP)) {
    Write-Host "Invalid IP address format. Please try again." -ForegroundColor Red
    exit
}

# Define the receive connector name
$receiveConnectorName = "Anonymous Relay"

# Connect to Exchange (adjust as needed for on-premises)
# Connect-ExchangeOnline -UserPrincipalName <your admin account> -ShowProgress $true
# ---------------Start exch conx
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
#[OutputType([int])]

$session = Get-PsSession | Where-Object {
    ($_.ComputerName -match "ITS-EXCH01.kerncounty.com") -and ($_.State -match "Opened")
}
$session
<#testing entries                      "
$MyMailbox = Get-remotemailbox -identity "lowryb@kerncounty.com"
Write-host "MyMailbox = $MyMailbox"
#start-sleep -seconds 15
#>

If (!($session)) {
    $Params = @{
    	ConfigurationName = "Microsoft.Exchange"
    	ConnectionUri = "https://ITS-EXCH01.kerncounty.com/PowerShell/"
    	Authentication = "Basic"
    	AllowRedirect = $True
    } # End Params
    write-host "                         *** Creating new session ***                        "

    #Obtain On-prem Exchange server credentials:
    $UserCredential = Get-Credential -Message "Please enter On-premise Exchange administrative credentials (domain\user)"
    $ExchSession = New-PSSession @params -Credential $UserCredential
    Import-PSSession $ExchSession -AllowClobber
} #End -not $session
Else {
    Write-host "                      *** Current Session Connected  ***                       " -ForegroundColor black -BackgroundColor green 
}
#-------end Exch conx

# Import the Exchange module
Import-Module ExchangeOnlineManagement

# Get the list of servers
$servers = Get-ExchangeServer | Where-Object { $_.ServerRole -like "*Mailbox*" }

foreach ($server in $servers) {
    Write-Host "Processing server: $($server.Name)" -ForegroundColor Cyan

    # Get the current list of remote IP ranges for the receive connector
    $receiveConnector = Get-ReceiveConnector -Server $server.Name | Where-Object { $_.Name -eq $receiveConnectorName }
    
    if ($receiveConnector -eq $null) {
        Write-Host "Receive connector $receiveConnectorName not found on server $($server.Name)." -ForegroundColor Red
        continue
    }

    $currentIPRanges = $receiveConnector.RemoteIPRanges

    # Check if the IP address is already in the list
    if ($currentIPRanges -contains $printerIP) {
        Write-Host "The IP address $printerIP is already in the list for server $($server.Name)." -ForegroundColor Yellow
        continue
    }

    # Add the new IP address to the list
    $newIPRanges = $currentIPRanges + $printerIP

    # Update the receive connector with the new list of IP addresses
    Set-ReceiveConnector -Identity $receiveConnector.Identity -RemoteIPRanges $newIPRanges

    Write-Host "The IP address $printerIP has been added to the receive connector $receiveConnectorName on server $($server.Name)." -ForegroundColor Green
}

Write-Host "Script completed." -ForegroundColor Green

#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"
