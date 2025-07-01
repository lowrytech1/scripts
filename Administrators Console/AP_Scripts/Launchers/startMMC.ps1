# Define the script to be executed in the new PowerShell window
$script = @'
# Your script content here
Write-Host "This PowerShell window is running with administrative privileges."
# The code below uses a loop to continually prompt the user to select an option from a list of options until the user selects the Exit option:

# Initialize the $exit variable to $false
$exit = $false

#Ensure necessary modules load when needed:
#$PSModuleAutoLoadingPreference = "All"

#Vars
$userName = Read-Host "Enter your username for this domain"

# Process to run
Function Get-ADUC {
    Param (
        [string]$domain,
        [string]$userName
    )
    $credential = Get-Credential -UserName "$domain\$userName" 
    runas /noprofile /netonly /user:$domain\$userName "%w\System32\mmc.exe dsa.msc /domain=kcda.local" -Credential $credential
}

# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {
    # Display a list of options to the user
    Write-Host "Select a domain:"
    Write-Host "1. Kern County......kernCounty.com"
    Write-Host "2. DA...............kcda.local"
    Write-Host "3. Crime Lab........lab.da.co.kern.ca.us"
    Write-Host "4. Recorder.........rcrd.internal"
    Write-Host "5. County Council...ccdomain.cc.co.kern.ca.us"
    Write-Host "6. Public Health....phdom.local"
    Write-Host "7. Assessor.........ASSESSOR.INTERNAL"
    Write-Host "8. BHRS.............KernBHRS.local"
    Write-Host "9. Elections........elections.accc.co.kern.ca.us"
    Write-Host "10. DHS.............dom1.dhs.co.kern.ca.us"
    Write-Host "11. Auditor.........accc.co.kern.ca.us"
    Write-Host "12. Exit"


  # Prompt the user for a selection
  $selection = Read-Host

  # Use a switch statement to execute different codes based on the user's selection
  switch ($selection) {
        # Prompt the user to select an option
        1 { $domain = "'"kernCounty'"" }
        2 { $domain = "kcda" }
        3 { $domain = "lab" }
        4 { $domain = "rcrd.internal" }
        5 { $domain = "ccdomain.cc.co.kern.ca.us" }
        6 { $domain = "phdom.local" }
        7 { $domain = "ASSESSOR.INTERNAL" }
        8 { $Domain = "KernBHRS.local" }
        9 { $Domain = "elections.accc.co.kern.ca.us" }
        10 { $Domain = "dom1.dhs.co.kern.ca.us" }
        11 { $Domain = "accc.co.kern.ca.us" }
        12 { $exit = $true }
        default { Write-Host "Invalid selection. Please try again." }
    }
    # If the user did not select "Exit", call the Get-ADUC function
    if (!$exit) {
        Write-Host "Connecting to $domain"
        Get-ADUC -domain $domain -userName $userName
    }

}
'@

# Start a new PowerShell process with administrative privileges
#Start-Process powershell -ArgumentList "-NoExit", "-Command", $script -Verb RunAs