<# ToDo:
1. verify virtual terminal sequences are working 
#>
#Set Environment Values
[console]::windowwidth=53;
[console]::windowheight=13;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.BackgroundColor="black";
$host.UI.RawUI.ForegroundColor="blue";
$host.UI.RawUI.WindowTitle="Emoji Test";

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

# Check for and install PS7:
$PS7 = "Get-Command pwsh -ErrorAction SilentlyContinue"
If ($PS7 -eq $null) {
    $currentVersion = $PSVersionTable.PSVersion.Major
    Write-Host "This script requires PowerShell 7" -ForegroundColor Yellow
    Write-Host "You are currently running Powershell version" -noNewline
    Write-Host " $currentVersion" -ForegroundColor Red
    Read-Host "Do you want to install PowerShell 7? (Y/N)"
    If ($response -eq "Y") {
        ##### Install PS7 #####    
        Write-Host "Installing PowerShell 7..."
        cmd.exe /c "Winget install microsoft.powershell"
            
    } Else {
        Write-Host "Unable to execute without PS7"
        Write-Host "Exiting script..."
        exit
    }   
}
            
# INSTALL PSScriptTools module:
$Tools = "Get-module -ListAvailable -Name PSScriptTools"
If ($Tools -eq $null) {
    Install-Module -Name PSScriptTools -Force -AllowClobber
    Import-module PSScriptTools
} Else {
    Import-module PSScriptTools
}

# Initialize the $exit variable to $false
$exit = $false

# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {
    clear-host
    # Display a list of options to the user
    Write-Host ""
    Write-CenteredText "*************************************************" -ForegroundColor red
    Write-Host ""
    Write-CenteredText "A friend walks up and says `"Hey man...`"" -ForegroundColor white
    Write-Host ""
    Write-CenteredText "*************************************************" -ForegroundColor red
    Write-Host ""
    Write-CenteredText "Choose your response from the following options:" -ForegroundColor Blue
    Write-Host "                  1. What's up?"
    Write-Host "                  2. NO!"
    Write-Host "                  3. Exit"
    Write-Host ""

    # Prompt the user for a selection
    $selection = Read-Host "  Enter your selection (1, 2, or 3)"

    # Use a switch statement to execute different codes based on the user's selection
    switch ($selection) {
        1 {
            # If the user selects option 1, display a message and do something for option 1
            Clear-host
            Write-Host ""
            Write-Host ""
            Write-Host ""
            Write-Host ""
            Write-Host ""
            Write-CenteredText "`u{1F44C}"
            $sound = New-Object Media.SoundPlayer('.\AP_Scripts/Media/EXPLODE.WAV')
            $sound.Play();
            start-sleep -seconds 2
            Write-Host ""
            Write-Host ""
            Write-CenteredText "Gotcha!" -ForegroundColor red
            start-sleep -Seconds 3
        }

        2 {
            # If the user selects option 2, display a message and do something for option 2
            Clear-host
            Write-Host ""
            Write-Host ""
            Write-Host ""
            Write-Host ""
            Write-Host ""
            Write-CenteredText "`u{1F4A9}"
            Write-Host ""
            Write-Host ""
            Write-CenteredText "Loser!" -ForegroundColor red
            [console]::beep(250,1000)
            [console]::beep(200,2000)
            start-sleep -Seconds 3
        }

        3 {
            # If the user selects option 3, set $exit to $true to exit the loop
            Write-CenteredText "Exiting..." -ForegroundColor Yellow
            $exit = $true  
        }

        default {
            # If the user enters an invalid selection, display an error message
            Write-CenteredText "Invalid selection. Please try again." -ForegroundColor Red
            start-sleep -Seconds 2
        }
    } 
}
exit
