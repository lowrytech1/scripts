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

Write-host "       *** This script requires Microsoft PowerShell 7 or higher. ***     *" -ForegroundColor red -BackgroundColor Black
Write-host "                    Windows PowerShell is insufficient.                    " -ForegroundColor red -BackgroundColor Black

# Check for AZ Module installed:
<#
$AZinstalled = Get-InstalledModule -Name Az
If (-not ($AZinstalled)) {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Install-Module -Name Az -Repository PSGallery -Force
    Import-Module -name az
    write-host "Azure module successfully installed"
}
Else {
    Write-host "Azure Module is installed"
}
#>

Write-Host "                                                                           "
Write-Host "   ************************************************************************"
Write-Host "   *                                                                      *"
Write-Host "   *                        Connecting to Azure...                        *"
Write-Host "   *                                                                      *"
Write-Host "   ************************************************************************"
Write-Host ""

#VERIFY AZ CONNECTION, CONNECT IF NOT.
$counter = 0
$IsConnected = get-AZContext
if ( !$IsConnected ) {
    While ($counter -lt 4) {
        write-host "Not connected" -ForegroundColor red
        Connect-AzAccount
        $counter++
        If ($counter -GT 3) {
            write-host "Unable connect to Azure" -ForegroundColor red
        }
    }
}
Else {Write-host "                         *** Connected to Azure ***                        " -ForegroundColor black -BackgroundColor Green}

#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"