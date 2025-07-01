Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"


#Header
Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "******** Unlock Account *******" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

#Body
$User_Name = Read-Host -Prompt "Enter Account Login Name (E.G- `"LowryB`")"
# Check if account is locked:
$IsLocked = (Get-ADUser $User_Name -Properties LockedOut | Select-Object LockedOut)
foreach ($User in $IsLocked) {
    $Status = ($User.lockedOut)
}
write-host $Status

# If account not locked, lock it or quit.
if ($Status -eq $False) {
    Write-Host - "User account is not currently locked. Exiting."
} Else {
    Unlock-ADAccount -Identity $User_Name -confirm
    Start-Sleep -Seconds 3
    $IsLocked = (Get-ADUser $User_Name -Properties LockedOut | Select-Object LockedOut)
    foreach ($User in $IsLocked) {
        $Status = ($User.lockedOut)
    }
    if ($Status -eq $False) {
        Write-Host - "User account has been unlocked"
    } Else {
        Write-Host "Unableto unlock account. Try using the web Console"
    }
    Write-Host "Complete. Exiting."
}

#Unlock account:
#Unlock-ADAccount -Identity $User_Name


# At end of file:
#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"