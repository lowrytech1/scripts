Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

#Header

Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "* Connect to On-Prem Exchange *" -ForegroundColor yellow -BackgroundColor Blue
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

#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"