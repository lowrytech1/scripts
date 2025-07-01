# Winget installer script by Brian Lowry - 2024.
# Header
Clear-Host
Write-Host ""
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue -NoNewline
Write-Host "  V1" -ForegroundColor red
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "********* Winget Installer *********" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host " This script will install the Windows Package Manager (Winget)." -ForegroundColor Green
Write-Host ""

# Check if winget is already installed
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "Winget is already installed."
    exit 0
}

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

# Verify installation
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "Verification successful: winget is now available."
} else {
    Write-Error "Verification failed: winget is not available after installation."
    exit 1
}