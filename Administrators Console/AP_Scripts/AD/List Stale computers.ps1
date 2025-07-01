Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

#Header
Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "***** List Stale Computers ****" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

#Body
Write-Host "Gets list of all computers not logged into in the past 6 months,"
Write-Host "shows last login date and account enabled/disabled status."
Write-Host "*************** Press space to move to next page ****************"

$inactiveDays = ((Get-Date).AddDays(-180)).Date
Get-ADcomputer -Filter {LastLogonDate -lt $inactiveDays} -Properties * | Select-Object samaccountname,LastLogonDate,Enabled | Sort-Object -property samAccountName | more
Write-host "***************End of List***************"


#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"