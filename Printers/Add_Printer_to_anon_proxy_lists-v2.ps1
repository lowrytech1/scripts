# Add Printer to Anon Relay Script by Brian Lowry - 2024

# Set Environment Variables
[console]::windowwidth=116;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.WindowTitle="Add Printer to Anonymous Relay";

# Add helper function for centering text
function Write-CenteredText {
    param([string]$Text, [System.ConsoleColor]$ForegroundColor = [System.ConsoleColor]::White)
    
    # Split the text into lines
    $lines = $Text -split "`n"
    $maxLength = ($lines | Measure-Object -Property Length -Maximum).Maximum
    $windowWidth = $Host.UI.RawUI.WindowSize.Width
    
    foreach ($line in $lines) {
        # Calculate padding without trimming spaces
        $padding = [Math]::Max(0, [Math]::Floor(($windowWidth - $line.Length) / 2))
        Write-Host (" " * $padding) -NoNewline
        Write-Host $line -ForegroundColor $ForegroundColor
    }
}

# function to validate IP address format
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

$PSModuleAutoLoadingPreference = "All"

Clear-Host
# Header
$BANNER1 = @"
                                                                                                      
      _/_/          _/        _/                          _/              _/                          
   _/    _/    _/_/_/    _/_/_/      _/_/_/    _/  _/_/      _/_/_/    _/_/_/_/    _/_/    _/  _/_/   
  _/_/_/_/  _/    _/  _/    _/      _/    _/  _/_/      _/  _/    _/    _/      _/_/_/_/  _/_/        
 _/    _/  _/    _/  _/    _/      _/    _/  _/        _/  _/    _/    _/      _/        _/           
_/    _/    _/_/_/    _/_/_/      _/_/_/    _/        _/  _/    _/      _/_/    _/_/_/  _/            
                                 _/                                                                   
                                _/                                                                    
"@
$BANNER2 = @"
   _/               
_/_/_/_/    _/_/    
 _/      _/    _/   
_/      _/    _/    
 _/_/    _/_/       
"@
$BANNER3 = @"
      _/_/                                      _/_/_/              _/                      
   _/    _/  _/_/_/      _/_/    _/_/_/        _/    _/    _/_/    _/    _/_/_/  _/    _/   
  _/_/_/_/  _/    _/  _/    _/  _/    _/      _/_/_/    _/_/_/_/  _/  _/    _/  _/    _/    
 _/    _/  _/    _/  _/    _/  _/    _/      _/    _/  _/        _/  _/    _/  _/    _/     
_/    _/  _/    _/    _/_/    _/    _/      _/    _/    _/_/_/  _/    _/_/_/    _/_/_/      
                                                                                   _/       
                                                                              _/_/          
"@

# Display centered banners
Clear-Host
Write-Host ""
Write-Host ""
Write-Host ""
Write-CenteredText $BANNER1 -ForegroundColor Gray
Write-CenteredText $BANNER2 -ForegroundColor Gray
Write-CenteredText $BANNER3 -ForegroundColor Gray
Write-Host ""
Write-Host ""
Write-CenteredText "This script will add a given IP address to the Anonymous Relay Receive Connector" -ForegroundColor Yellow
Write-CenteredText "on each of the four On-Prem Exchange Servers in one shot." -ForegroundColor Yellow
Write-Host ""
Write-Host ("*" * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor Red
Write-Host ""

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
Write-CenteredText "************************************************************************"
Write-CenteredText "*                                                                      *"
Write-CenteredText "*               Connecting to On-Prem Exchange Server...               *"
Write-CenteredText "*                                                                      *"
Write-CenteredText "*                                                                      *"
Write-CenteredText "*     On-premise Exchange administrative credentials (domain\user)     *"
Write-CenteredText "*                                                                      *"
Write-CenteredText "************************************************************************"
Write-host ""

# Check if a session already exists and enter, or create new session:
Write-CenteredText "*** checking for active session ***"

[CmdletBinding()]
#[OutputType([int])]

$session = Get-PsSession | Where-Object {
    ($_.ComputerName -match ("[Exch.srv.fqdn.com]") -and ($_.State -match "Opened")
}
$session

If (!($session)) {
    $Params = @{
    	ConfigurationName = "Microsoft.Exchange"
    	ConnectionUri = "https://[Exch.srv.fqdn.com]/PowerShell/"
    	Authentication = "Basic"
    	AllowRedirect = $True
    } # End Params
    Write-CenteredText "*** Creating new session ***"

    #Obtain On-prem Exchange server credentials:
    $UserCredential = Get-Credential -Message "Please enter On-premise Exchange administrative credentials (domain\user)"
    $ExchSession = New-PSSession @params -Credential $UserCredential
    Import-PSSession $ExchSession -AllowClobber
} #End -not $session
Else {
    Write-CenteredText "*** Current Session Connected  ***" -ForegroundColor black -BackgroundColor green 
}
#-------end Exch conx

# Verify the installation of the Exchange Online module
$exonline = Get-InstalledModule -Name ExchangeOnlineManagement
If (-not ($exonline)) {
    Write-CenteredText "*** Installing Exchange Online Module... ***"
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Install-Module -Name ExchangeOnlineManagement -Repository PSGallery -Force
    Import-Module -name ExchangeOnlineManagement
    Write-CenteredText "*** Exchange Online module successfully installed ***"
}
Else {
    Write-CenteredText "*** Exchange Online Module is installed ***"
}

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
