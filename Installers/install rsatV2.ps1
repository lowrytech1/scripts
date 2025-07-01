# RSAT tools installer for Windows 10/11 by Brian Lowry - 2024
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

Clear-Host
# Header

# Get StartTime
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

# Set Environment Variables
[console]::windowwidth=116;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.WindowTitle="RSAT Installer V2";


$BANNER1 = @"
8 888888888o.     d888888o.           .8.    8888888 8888888888 
8 8888    '88.  .'8888:' '88.        .888.         8 8888       
8 8888     '88  8.'8888.   Y8       :88888.        8 8888       
8 8888     ,88  '8.'8888.          . '88888.       8 8888       
8 8888.   ,88'   '8.'8888.        .8. '88888.      8 8888       
8 888888888P'     '8.'8888.      .8'8. '88888.     8 8888       
8 8888'8b          '8.'8888.    .8' '8. '88888.    8 8888       
8 8888 '8b.    8b   '8.'8888.  .8'   '8. '88888.   8 8888       
8 8888   '8b.  '8b.  ;8.'8888 .888888888. '88888.  8 8888       
8 8888     '88. 'Y8888P ,88P'.8'       '8. '88888. 8 8888        
"@#
$BANNER2 = @"
  _____           _        _ _           
 |_   _|         | |      | | |          
   | |  _ __  ___| |_ __ _| | | ___ _ __ 
   | | | '_ \/ __| __/ _' | | |/ _ \ '__|
  _| |_| | | \__ \ || (_| | | |  __/ |   
 |_____|_| |_|___/\__\__,_|_|_|\___|_|   
"@#

# Display centered banners
#Clear-Host
Write-Host ""
Write-Host ""
Write-Host ""
Write-CenteredText $BANNER1 -ForegroundColor DarkCyan
Write-CenteredText $BANNER2 -ForegroundColor Cyan
Write-Host ""
Write-Host ""
Write-CenteredText "This script will Installs the full suite of Remote Server Installation Tools (RSAT)." -ForegroundColor Yellow
Write-CenteredText "The installer is compatible with Windows 10 and 11." -ForegroundColor Yellow
Write-Host ""
Write-Host ("*" * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor Red
Write-Host ""

$WarningPreference = "Inquire"
$m = "This script will install RSAT Tools. Please ensure you are running this script as Administrator."
Write-Warning -Message $m


# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator!"
    break
}

# Get Windows Version
$WindowsVersion = [System.Environment]::OSVersion.Version.Major
$WindowsBuild = [System.Environment]::OSVersion.Version.Build

# Install RSAT based on Windows version
if ($WindowsVersion -eq 10 -or $WindowsVersion -eq 11) {
    if ($WindowsBuild -ge 17763) {
        # Windows 10 1809 or later / Windows 11 - Use Windows Capabilities
        Write-Host "Installing RSAT tools via Windows Capabilities..."
        Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
    } else {
        # Earlier Windows 10 versions - Use legacy method
        Write-Host "Installing RSAT tools via legacy method..."
        $url = "https://download.microsoft.com/download/1/D/8/1D8B5022-5477-4B9A-8104-6A71FF9D98AB/WindowsTH-RSAT_WS_1709-x64.msu"
        $output = "$env:TEMP\RSAT.msu"
        Invoke-WebRequest -Uri $url -OutFile $output
        Start-Process -FilePath "wusa.exe" -ArgumentList "$output /quiet" -Wait
    }
} else {
    Write-Error "This script is designed for Windows 10/11. Please use Server Manager or appropriate method for your OS."
    break
}

# Verify installation
Write-Host "Verifying installation..."
$RSATTools = Get-WindowsCapability -Name RSAT* -Online | Where-Object State -eq "Installed"
if ($RSATTools) {
    Write-Host "RSAT tools installed successfully!"
} else {
    Write-Warning "Some RSAT tools might not have installed correctly. Please check manually."
}
