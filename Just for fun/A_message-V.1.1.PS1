# Type-Script.ps1 
# By Brian Lowry
# 2021-09-29
# This script will take text as input, then print each character in type-writer fashion.
#Requires -RunAsAdministrator
$PSModuleAutoLoadingPreference = "All"
$ErrorActionPreference = "SilentlyContinue"
$WarningPreference = 'SilentlyContinue'
Clear-Host

# Ensure the ActiveDirectory module is installed
if (-not (Get-Module -ListAvailable -Name  ActiveDirectory)) {
    Write-Host "ActiveDirectory module is not installed. Installing..." -ForegroundColor red
    try {
        Add-WindowsCapability -online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
        Write-Host "ActiveDirectory module installed successfully." -ForegroundColor green
    } catch {
        Write-Host "Failed to install ActiveDirectory module. Please check your system configuration." -ForegroundColor red
        exit 1}
} else {
    Write-Host "ActiveDirectory module is already installed"
}
# This is necessary due to Core editions needing the windows Compatibility module to load it.
$PSV = $PSVersionTable.PSEdition -eq "Desktop"
If ($PSV) {
	Import-Module ActiveDirectory
} Else {
    try {
        Install-Module -Name WindowsCompatibility -Force
    } catch {
        Write-Host "Failed to install WindowsCompatibility module. Please check your system configuration." -ForegroundColor red
        exit 1
    }
    Import-Module -Name WindowsCompatibility
    Import-WinModule -Name ActiveDirectory
}

# Ensure the PSReadLine module is installed
if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
    Write-Host "PSReadLine module is not installed. Installing..." -ForegroundColor red
    Install-Module -Name  PSReadLine -Force -Scope CurrentUser
} Else {
    Write-Host "PSReadLine module is installed" -ForegroundColor green
}
# Import the PSReadLine module
Import-Module PSReadLine

# Get the logged-in username
$username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split('\')[-1]

# Query Active Directory for the user's first name
$user = Get-ADUser -Identity $username -Properties GivenName
$firstName = $user.GivenName

# Define the text to be printed, including the username
$text = @"
Wake up, $firstName...
The Matrix has you...
Follow the white rabbit...
Knock, Knock, $firstName.
"@

# Function to print each character in typewriter fashion
function typewrite ($text) {
    # Split the text into lines
    $lines = $text -split "`r`n"

    # Loop through each line
    foreach ($line in $lines) {
        # Loop through each character in the line
        foreach ($char in $line.ToCharArray()) {
            # Create a random number for the delay between letters
            $gap = Get-random -Minimum 10 -Maximum 250
            Write-Host -nonewline $char -ForegroundColor Green  # Print the character
            Start-Sleep -Milliseconds $gap
        }

        # Simulate a blinking cursor at the end of the line
        $cursorLeft = [System.Console]::CursorLeft
        $cursorTop = [System.Console]::CursorTop
        for ($i = 0; $i -lt 4; $i++) {
            [System.Console]::SetCursorPosition($cursorLeft, $cursorTop)
            [System.Console]::CursorVisible = $false
            Start-Sleep -Milliseconds 500
            [System.Console]::CursorVisible = $true
            Start-Sleep -Milliseconds 500
        }

        #Start-Sleep -Seconds 2  # Pause for 2 seconds after printing the line
        Clear-Host
    }
    #Start-sleep -Seconds 4  # Pause for a second after printing all characters
    #Clear-Host
    Write-Host ""  # Move to the next line after printing all characters
} 
typewrite $text