Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

#Header

Write-Host "***********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "***********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "**** Connect to Exchange-Online ***" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "***********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "***********************************" -ForegroundColor yellow -BackgroundColor Blue

Write-host "       *** This script requires Microsoft PowerShell 7 or higher. ***      " -ForegroundColor red -BackgroundColor Black
Write-host "                    Windows PowerShell is insufficient.                    " -ForegroundColor red -BackgroundColor Black

# Prompt for user credentials
$UserCredential = Get-Credential

# Connect to Exchange Online
Connect-ExchangeOnline -Credential $UserCredential


#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"