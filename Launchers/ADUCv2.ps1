#ADUC Launcher script by Brian Lowry, 2024
# Todo: add TTC domain.
# The code below uses a loop to continually prompt the user to select an option from a list of options until the user selects the Exit option:
#Set Environment Values
[console]::windowwidth=70;
[console]::windowheight=31;
[console]::bufferwidth=[console]::windowwidth;
#$host.UI.RawUI.BackgroundColor="black";
#$host.UI.RawUI.ForegroundColor="a";
$host.UI.RawUI.WindowTitle="ADUC Launcher V2";

# Function to check if the script is running as administrator
function Test-IsAdmin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Process to run the MMC with the specified domain and username
Function Get-ADUC {
    Param (
        [string]$domain,
        [string]$userName
    )
    runas /noprofile /netonly /user:$domain\$userName "C:\windows\System32\mmc.exe dsa.msc /domain=$domain"
}

# Add helper function for centering text
function Write-CenteredText {
    param([string]$Text, [System.ConsoleColor]$ForegroundColor = [System.ConsoleColor]::White)
    
    # Split the text into lines
    $lines = $Text -split "`n"
    $maxLength = ($lines | Measure-Object -Property Length -Maximum).Maximum
    $windowWidth = $Host.UI.RawUI.WindowSize.Width
    
    foreach ($line in $lines) {
        # Calculate padding without trimming spaces
        $padding = [Math]::Max(0, [Math]::Floor(($windowWidth - $line.Length) / 2))
        Write-Host (" " * $padding) -NoNewline
        Write-Host $line -ForegroundColor $ForegroundColor
    }
}

# Initialize the $exit variable to $false
$exit = $false

# Command to Check if the script is running as administrator
if (-not (Test-IsAdmin)) {
    Write-Host "This script must be run as an administrator. Please restart the script with administrative privileges." -ForegroundColor Red
    exit
} Else {
    Write-Host "Running as administrator..." -ForegroundColor Green
}

#Ensure necessary modules load when needed:
$PSModuleAutoLoadingPreference = "All"
# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {
    Clear-Host
    # Header
    $BANNER1 = @"
       _       ______        /|       _____  _____   ______  
      / \     |_   _ '.     / |      |_   _||_   _|.' ___  | 
     / _ \      | | '. \   /  |_____   | |    | | / .'   \_| 
    / ___ \     | |  | |  /_____   /   | '    ' | | |        
  _/ /   \ \_  _| |_.' /       |  /     \ \__/ /  \ '.___.'\ 
 |____| |____||______.'        | /       '.__.'    '.____ .' 
                               |/                            
"@
    $BANNER2 = @"
    _ __ __    ___   __  ___   __________  ____________ 
   __ _ / /   /   | / / / / | / / ____/ / / / ____/ __ \
  _ __ / /   / /| |/ / / /  |/ / /   / /_/ / __/ / /_/ /
 __ _ / /___/ ___ / /_/ / /|  / /___/ __  / /___/ _, _/ 
_ __ /_____/_/  |_\____/_/ |_/\____/_/ /_/_____/_/ |_|   
"@

    # Display centered banners
    Clear-Host
    Write-Host ""
    Write-CenteredText $BANNER1 -ForegroundColor DarkYellow
    Write-CenteredText $BANNER2 -ForegroundColor DarkRed
    Write-Host ""
    Write-Host ("*" * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor Blue
    Write-Host ""

    # Display a list of options to the user
    Write-Host "     Select a domain to manage:"
    Write-Host "         1.  Domain1......Domain1.com" -ForegroundColor "Green"
    Write-Host "         2.  Domain2......Domain2.local" -ForegroundColor "Green"
    Write-Host "         13. Exit"

    # Prompt the user for a selection
    $selection = Read-Host
    
    # If the user selected "13", exit.
    if ($selection -eq 13) {
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
        12 { $Domain = "RMANT.RMA.CO.KERN.CA.US" }
        13 { $exit = $true }
        Default { Write-Host "Invalid selection. Please try again." }
    }
    # If the user did not select "Exit", call the Get-ADUC function
    if (!$exit) {
        Write-Host "Connecting to $domain"
        Get-ADUC -domain $domain -userName $userName
        Clear-host
    }

}
