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
Write-Host "    1. KCPrint01" -ForegroundColor Blue
Write-Host "    2. PSBPrint01" -ForegroundColor Blue
Write-Host "    3. DHS-AD06" -ForegroundColor Blue
Write-Host "    4. DA-FS01" -ForegroundColor Blue
Write-Host "    5. Other Server" -ForegroundColor Blue
Write-Host "    6. Exit" -ForegroundColor Blue
#printers to add:
#KCPRINT02
#MFPRINTSERVER
#ITS-FOOTPRINTS

# Prompt the user for a selection
$selection = Read-Host

# Use a switch statement to execute different codes based on the user's selection
switch ($selection) {
    1 {
        # Define the remote server's name or IP address
        $remoteServer = "KCPrint01.Kerncounty.com"
        Restart-SpoolerService
    }

    2 {
        # Define the remote server's name or IP address
        $remoteServer = "PSBPrint01.RMANT.RMA.CO.KERN.CA.US"
        Restart-SpoolerService
    }

    3 {
        # Define the remote server's name or IP address
        $remoteServer = "DHS-AD06.Dom1.DHS.CO.KERN.CA.US" 
        Restart-SpoolerService
    }
    
    4 {
        # Define the remote server's name or IP address
        $remoteServer = "DA-FS01.kcda.local" 
        Restart-SpoolerService
    }
    
    5 {
        # Define the remote server's name or IP address
        $remoteServer = Read-Host -prompt "Print Server Name" 
        Restart-SpoolerService
    }

    6 {
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