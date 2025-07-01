Clear-Host
$StartTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $StartTime" -foregroundcolor "Yellow"


#Header
Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "****** Search AD Account ******" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

#Body
$Account_Name = Read-Host -Prompt "Enter full or partial Account Name:"
$Account_Info = Get-ADObject -Filter "sAMAccountName -like '*$Account_Name*'" -Properties *
If (!$account_Info) {
    Write-Host - "No account found with that criteria." -ForegroundColor Red -BackgroundColor Yellow
}
Else{
    Get-ADObject -Filter "sAMAccountName -like '*$Account_Name*'" -Properties *
}


# At end of file:
#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"