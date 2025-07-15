# At top of file:
Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

#Ensure necessary modules load when needed:
$PSModuleAutoLoadingPreference = "All"

#Header

Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "********    Restart    ********" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "******** Print Spooler ********" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

#Body
Function Restart-SpoolerService {
    #start a remote session with the print server
    Enter-PSSession -ComputerName $remoteServer
    # Check the status of the spooler service on the remote server
    $spoolerService = Get-Service -Name "Spooler" #-ComputerName $remoteServer

    if ($spoolerService.Status -eq "Running") {
        # Restart the spooler service if it is running
        Restart-Service -Name "Spooler" #-ComputerName $remoteServer
        Write-Host "The spooler service on $remoteServer has been restarted."
    } else {
        # Start the spooler service if it is not running
        Start-Service -Name "Spooler" #-ComputerName $remoteServer
        Write-Host "The spooler service on $remoteServer was not running and has been started."
    }

    # Output the status of the spooler service after the operation
    $spoolerService = Get-Service -Name "Spooler" #-ComputerName $remoteServer
    Write-Host "The spooler service on $remoteServer is now $($spoolerService.Status)."
    read-host "Press any key to exit"
    # End the remote session
    Exit-PSSession
}

Write-Host "Please select a print server from the following options:" -ForegroundColor White   -BackgroundColor DarkRed
Write-Host "    1. [printsrv1]" -ForegroundColor Blue
Write-Host "    2. [printsrv2]" -ForegroundColor Blue
Write-Host "    3. Exit" -ForegroundColor Blue

# Prompt the user for a selection
$selection = Read-Host

# Use a switch statement to execute different codes based on the user's selection
switch ($selection) {
    1 {
        # Define the remote server's name or IP address
        $remoteServer = "[printsrv1.your_domain.com]"
        Restart-SpoolerService
    }

    2 {
        # Define the remote server's name or IP address
        $remoteServer = "[printsrv2.your_other_domain.com]"
        Restart-SpoolerService
    }

    3 {
        exit
    }
}

#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"
