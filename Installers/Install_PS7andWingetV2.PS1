# Install Powershell 7 using winget
# By Brian Lowry 11/2024

# Function to check if the script is running as administrator
function Test-IsAdmin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to check if winget is installed
function Test-WingetInstalled {
    Write-Host ""
    Write-Host "Testing if Winget is installed..." -ForegroundColor Yellow
    try {
        winget --version
        return $true
    } catch {
        # Write-Host "Winget is not installed, exiting script..." -ForegroundColor Red
        return $false
    }
}

# Function to check if PowerShell 7 is installed
function Test-PowerShell7Installed {
    Write-Host ""
    Write-Host "Testing if PS7 is already installed..." -ForegroundColor Yellow
    try {
        $psVersion = pwsh -Command '$PSVersionTable.PSVersion'
        If ($PSversion) {
            return $true
        }
    } catch {
        return $false
    }
}

# Function to configure winget source
function Configure-WingetSource {
    Write-Host "Configuring winget source..." -ForegroundColor Yellow
    winget source reset --force
    winget source update
    winget source add --name winget --arg "https://winget.azureedge.net/cache" --accept-source-agreements
}

# Function to install or update PowerShell 7 using winget with a progress bar
function Install-Or-Update-PowerShell7 {
    if (Test-PowerShell7Installed) {
        Write-Host "PowerShell 7 is already installed. Checking for updates..." -ForegroundColor Yellow
        $wingetArgs = "upgrade --id Microsoft.Powershell --silent --accept-package-agreements --accept-source-agreements"
    } else {
        Write-Host "PowerShell 7 is not installed. Installing..." -ForegroundColor Yellow
        $wingetArgs = "install --id Microsoft.Powershell --silent --accept-package-agreements --accept-source-agreements"
    }

    Write-Host ""

    # Start the winget process and capture the output
    Write-Host "Downloading with Winget..."
    $process = Start-Process -FilePath "winget" -ArgumentList $wingetArgs -NoNewWindow -PassThru -RedirectStandardOutput "winget_output.txt"

    try {
        # Initialize the progress bar variables
        $progressActivity = "Installing PowerShell 7"
        $progressStatus = "In Progress"
        $progressPercent = 0

        # Start the installation process (assuming $process is already defined)
        while (-not $process.HasExited) {
            # Update progress bar
            Write-Progress -Activity $progressActivity -Status $progressStatus -PercentComplete $progressPercent
            Start-Sleep -Seconds 1
            $progressPercent += 5
            if ($progressPercent -gt 100) {
                $progressPercent = 100
            }
        }
        
        # Read the output file to check for success or failure
        Write-Host "Verifying PowerShell 7 installation success..."
        if (Test-Path -Path "winget_output.txt") {
            $output = Get-Content -Path "winget_output.txt"
            if ($output -match "Successfully installed" -or $output -match "No applicable update found") {
                Write-Host "PowerShell 7 installation or update completed successfully." -ForegroundColor Green
            } else {
                Write-Host "PowerShell 7 installation or update failed. See output below:" -ForegroundColor Red
                Write-Host $output
            }
            # Clean up
            Remove-Item -Path "winget_output.txt"
        } else {
            Write-Host "Output file not found. Unable to verify installation status." -ForegroundColor Red
        }
    } catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
}

# Function for centering text
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

Clear-Host

# Get StartTime
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

# Set Environment Variables
[console]::windowwidth=116;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.WindowTitle="Install PowerShell 7 with Winget";

$BANNER1 = @"
|.   ___           _        _ _   ____                        ____  _          _ _   _____   .|
|.  |_ _|_ __  ___| |_ __ _| | | |  _ \ _____      _____ _ __/ ___|| |__   ___| | | |___  |  .|
|.   | || '_ \/ __| __/ _' | | | | |_) / _ \ \ /\ / / _ \ '__\___ \| '_ \ / _ \ | |    / /   .|
|.   | || | | \__ \ || (_| | | | |  __/ (_) \ V  V /  __/ |   ___) | | | |  __/ | |   / /    .|
|.  |___|_| |_|___/\__\__,_|_|_| |_|   \___/ \_/\_/ \___|_|  |____/|_| |_|\___|_|_|  /_/     .|
|.                                                                                           .|
"@#
$BANNER2 = @"
|.                         _ _   _       __    __ _                  _                       .|
|.               __      _(_) |_| |__   / / /\ \ (_)_ __   __ _  ___| |_                     .|
|.               \ \ /\ / / | __| '_ \  \ \/  \/ / | '_ \ / _' |/ _ \ __|                    .|
|.                \ V  V /| | |_| | | |  \  /\  /| | | | | (_| |  __/ |_                     .|
|.                 \_/\_/ |_|\__|_| |_|   \/  \/ |_|_| |_|\__, |\___|\__|                    .|
|.                                                        |___/                              .|
"@#

# Display centered banners
Clear-Host
Write-Host ""
Write-Host ""
Write-Host ""
Write-CenteredText $BANNER1 -ForegroundColor Blue -BackgroundColor Yellow
Write-CenteredText $BANNER2 -ForegroundColor DarkBlue -BackgroundColor Yellow
Write-Host ""
Write-Host ""
Write-CenteredText "This script Installs Microsoft PowerShell 7 using the WinGet Package Manager." -ForegroundColor Yellow
Write-CenteredText "If Winget is not found, it will be automatically installed first." -ForegroundColor Yellow
Write-Host ""
Write-Host ("*" * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor Red
Write-Host ""


# Check if the script is running as administrator
if (-not (Test-IsAdmin)) {
    Write-Host "This script must be run as an administrator. Please restart the script with administrative privileges." -ForegroundColor Red
    exit
} Else {
    Write-Host "Running as administrator..." -ForegroundColor Green
}

# Check if PS7 is installed
if (-not (Test-PowerShell7Installed)) {
    Write-Host "PowerShell 7 is not installed." -ForegroundColor Red
} Else {
    Write-Host "PowerShell 7 Is already installed!" -ForegroundColor Green
}

# Install WinGet if not installed
if (-not (Test-WingetInstalled)) {
    Write-Host "Winget is not installed. Installing now." -ForegroundColor Red
    $progressPreference = 'silentlyContinue'
    $latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
    $latestWingetMsixBundle = $latestWingetMsixBundleUri.Split("/")[-1]
    Write-Information "Downloading winget to artifacts directory..."
    Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle"
    Add-AppxPackage $latestWingetMsixBundle
    Write-Host "Winget is now installed" -ForegroundColor Green
} Else {
    Write-Host "Winget Is installed" -ForegroundColor Green
}

#Configure winget source
#Set-WingetSource

# Run the function to install or update PowerShell 7
Install-Or-Update-PowerShell7

Write-Host "Press any key to exit"
Read-Host