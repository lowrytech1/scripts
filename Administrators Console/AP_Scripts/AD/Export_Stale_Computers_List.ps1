Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

#Header
Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "**** Export Stale Computers ***" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

#Body
Write-Host "This script exports a CSV file list of all Computers not logged into in the past 6 months,"
Write-Host "           shows last login date and account enabled/disabled status."


$inactiveDays = ((Get-Date).AddDays(-180)).Date
Get-ADComputer -Filter {LastLogonDate -lt $inactiveDays} -Properties * | Select-Object samaccountname,LastLogonDate,Enabled | Sort-Object -property samAccountName |
Export-Csv -Path C:\temp\inactive_Computers_ad.csv -NoTypeInformation
Write-Host "A copy of the stale accounts list has been exported to 'C:\temp\inactive_Computers_ad.csv'"  -ForegroundColor "Green"

#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"