#ADUC Launcher script by Brian Lowry, 2024
# The code below uses a loop to continually prompt the user to select an option from a list of options until the user selects the Exit option:
#Set Environment Values
[console]::windowwidth=60;
[console]::windowheight=23;
[console]::bufferwidth=[console]::windowwidth;
#$host.UI.RawUI.BackgroundColor="black";
#$host.UI.RawUI.ForegroundColor="a";
$host.UI.RawUI.WindowTitle="ADUC Launcher";

Clear-Host
# Initialize the $exit variable to $false
$exit = $false

#Ensure necessary modules load when needed:
$PSModuleAutoLoadingPreference = "All"

# Process to run
Function Get-ADUC {
    Param (
        [string]$domain,
        [string]$userName
    )
    runas /noprofile /netonly /user:$domain\$userName "C:\windows\System32\mmc.exe dsa.msc /domain=$domain"
}

# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {
    # Header
    Write-Host ""
    Write-Host "              *******************************V1.1           " -ForegroundColor black -BackgroundColor "DarkRed"
    Write-Host "              *******************************               " -ForegroundColor black -BackgroundColor "DarkRed"
    Write-Host "              ******** ADUC Launcher ********               " -ForegroundColor black -BackgroundColor "DarkRed"
    Write-Host "              *******************************               " -ForegroundColor black -BackgroundColor "DarkRed"
    Write-Host "              *******************************               " -ForegroundColor black -BackgroundColor "DarkRed"
    Write-Host ""
    Write-Host ""
    # Display a list of options to the user
    Write-Host "     Select a domain to manage:"
    Write-Host "      1. Kern County......kernCounty.com" -ForegroundColor "Green"
    Write-Host "      2. DA...............kcda.local" -ForegroundColor "Green"
    Write-Host "      3. Crime Lab........lab.da.co.kern.ca.us" -ForegroundColor "Green"
    Write-Host "      4. Recorder.........rcrd.internal" -ForegroundColor "Green"
    Write-Host "      5. County Council...ccdomain.cc.co.kern.ca.us" -ForegroundColor "Green"
    Write-Host "      6. Public Health....phdom.local" -ForegroundColor "Green"
    Write-Host "      7. Assessor.........ASSESSOR.INTERNAL" -ForegroundColor "Green"
    Write-Host "      8. BHRS.............KernBHRS.local" -ForegroundColor "Green"
    Write-Host "      9. Elections........elections.accc.co.kern.ca.us" -ForegroundColor "Green"
    Write-Host "      10. DHS.............kerndhs.com" -ForegroundColor "Green"
    Write-Host "      11. Auditor.........accc.co.kern.ca.us" -ForegroundColor "Green"
    Write-Host "      12. Exit"

    # Prompt the user for a selection
    $selection = Read-Host
    
    # If the user selected "12", exit.
    if ($selection -eq 12) {
        Write-Host "Exiting ADUC Launcher..."
        Break
    }

    $userName = Read-Host "Enter your username for the remote domain (EG; admin-blowry)"

    # Use a switch statement to execute different codes based on the user's selection
    switch ($selection) {
        # Prompt the user to select an option
        1 { $domain = "kernCounty" }
        2 { $domain = "kcda.local" }
        3 { $domain = "lab" }
        4 { $domain = "rcrd.internal" }
        5 { $domain = "ccdomain.cc.co.kern.ca.us" }
        6 { $domain = "phdom.local" }
        7 { $domain = "ASSESSOR.INTERNAL" }
        8 { $Domain = "KernBHRS.local" }
        9 { $Domain = "elections.accc.co.kern.ca.us" }
        10 { $Domain = "kerndhs.com" }
        11 { $Domain = "accc.co.kern.ca.us" }
        12 { $exit = $true }
        Default { Write-Host "Invalid selection. Please try again." }
    }
    # If the user did not select "Exit", call the Get-ADUC function
    if (!$exit) {
        Write-Host "Connecting to $domain"
        Get-ADUC -domain $domain -userName $userName
        Clear-host
    }

}
