# remote session launcher
# A script to open a remote powershell session to another PC
While ($exit = "false"){
    # Header
    Write-Host ""
    Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "******** Remote session *******" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host ""
    Write-Host ""
    
    $Computer = Read-Host "Computer or Server Name"
    Try {
        Enter-pssession $computer
    } Catch {
        Write-Host "Failed to connect to $computer`: $_" -ForegroundColor Red
    }
}
read-host "Press [Enter] to exit"
