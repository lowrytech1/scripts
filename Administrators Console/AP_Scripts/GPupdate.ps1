Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

#Header
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "********** GPupdate ***********" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue

# Body
Invoke-Command { GPupdate.exe /force }

#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"