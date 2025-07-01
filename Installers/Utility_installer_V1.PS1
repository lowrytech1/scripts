# Utilities installer script by Brian Lowry, 2024.
Clear-Host
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

# Header
$text = "Dev Utilities Installer V1" #Script or section title
$boxWidth = $text.Length + 6
$hostWidth = $Host.UI.RawUI.WindowSize.Width
$padding = " " * [math]::Max(0, [math]::Floor(($hostWidth - $boxWidth) / 2))
#Clear-Host
Write-Host ("-" * $hostWidth)
Write-Output ""
Write-Host ($padding + ("*" * $boxWidth)) -ForegroundColor Red
Write-Host ($padding + ("*" * $boxWidth)) -ForegroundColor Red
Write-Host ($padding + "** $text **") -ForegroundColor Red
Write-Host ($padding + ("*" * $boxWidth)) -ForegroundColor Red
Write-Host ($padding + ("*" * $boxWidth)) -ForegroundColor Red
Write-Output ""
Write-Output ""
Write-Host " This script will install the following utilities:" -ForegroundColor Green 
Write-Host " Winget, Chocolatey, Powershell 7, NMAP, WireShark, MobaXterm," -ForegroundColor White
Write-Host " Visual Studio Code, and Git." -ForegroundColor White
Write-Host ("-" * $hostWidth)

# Ensure winget is installed
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget is not installed. Installing now." -ForegroundColor Red
    # Download latest release from GitHub
    $apiUrl = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $downloadUrl = ((Invoke-RestMethod -Uri $apiUrl).assets | Where-Object { $_.name -match "\.msixbundle$" }).browser_download_url

    # Create temporary directory
    $tempDir = Join-Path $env:TEMP "WinGetInstall"
    New-Item -ItemType Directory -Force -Path $tempDir

    # Download the installer
    $installerPath = Join-Path $tempDir "Microsoft.DesktopAppInstaller.msixbundle"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

    # Install the package
    try {
        Add-AppxPackage -Path $installerPath
        Write-Host "Winget has been successfully installed."
    } catch {
        Write-Error "Failed to install winget: $_"
        exit 1
    } finally {
        # Cleanup
        Remove-Item -Path $tempDir -Recurse -Force
    }
} Else {
    Write-Host "winget is already installed." -ForegroundColor Green
}
# Define the packages to install
$packages = @(
    "Chocolatey.Chocolatey",
    "Microsoft.Powershell",
    "Nmap.Nmap",
    "WiresharkFoundation.Wireshark",
    "Mobatek.MobaXterm",
    "Microsoft.VisualStudioCode",
    "Git.Git"
)

# Install each package
foreach ($package in $packages) {
    Write-Host "Installing $package..." -ForegroundColor Green
    winget install --id $package --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to install $package. Please check the error message above." -ForegroundColor Red
    } else {
        Write-Host "$package installed successfully." -ForegroundColor Green
    }
}

#Script Execution Stats
$endTime = Get-Date
# Calculate time difference between start and end time
$Duration = New-TimeSpan -Start $StartTime -End $EndTime
#Format the duration time as dd:HH:mm:ss
$formattedDuration = "{0:D2}:{1:D2}:{2:D2}:{3:D2}" -f $Duration.Days, $Duration.Hours, $Duration.Minutes, $Duration.Seconds
Write-Host "Script Duration time (dd:HH:mm:ss):" -NoNewline
Write-Host "  $formattedDuration" -foregroundcolor "yellow"
