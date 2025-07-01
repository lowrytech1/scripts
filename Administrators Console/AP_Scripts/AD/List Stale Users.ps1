Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

#Header
Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "******* List Stale Users ******" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

#Body
Write-Host "Gets list of all users not logged in in the past 6 months,"
Write-Host "shows last login date and account enabled/disabled status."
Write-Host "*************** Press space to move to next page ****************"

$inactiveDays = ((Get-Date).AddDays(-180)).Date
$staleUsers = Get-ADUser -Filter {LastLogonDate -lt $inactiveDays} -Properties * | Select-Object samaccountname,LastLogonDate,Enabled | Sort-Object -property samAccountName

# Display the list of stale users
$staleUsers | more

# Display the total count of stale users
$totalCount = $staleUsers.Count
Write-Host "***************End of List***************"
Write-Host ""
Write-Host "Total number of stale accounts: $totalCount" -ForegroundColor "Yellow"
Write-Host ""
Write-Host ""

#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"