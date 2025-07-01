# At top of file:
Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

#Header

Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "***** Disable AD Account ******" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

#Body
$Account_Name = Read-Host -Prompt "Enter the account name to disable (E.G., lowryb)"
$StatusList = Get-ADuser -identity "$Account_Name" | Select-Object Enabled
Foreach ($Status in $StatusList) {
    $Enabled = $Status.enabled
}
if ($Enabled -eq $False) {
    Write-Host "Account is already disabled"
} Else {
    Disable-ADaccount -Identity $Account_Name -confirm
    $StatusList = Get-ADuser -identity "$Account_Name" | Select-Object Enabled
    Foreach ($Status in $StatusList) {
        $Enabled = $Status.enabled
    }
    if ($Enabled -eq $False) {
        Write-Host "Account $Account_Name has been disabled"
    }
    Elseif ($status2 -eq $True) {
        Write-Host "Unable to disable Account $Account_Name. Try using ADUC."
    }
}


#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"