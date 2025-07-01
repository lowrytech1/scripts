# Fat 32  disk conversion script by Brian Lowry - 2025
#Set Environment Values
[console]::windowwidth=120;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.WindowTitle="PHAT32 Disk Conversion Tool";

# Header
# Banner text definitions
$BANNER1 = @" 
 ███████████  █████   █████   █████████   ███████████  ████████   ████████ 
 ░░███░░░░░███░░███   ░░███   ███░░░░░███ ░█░░░███░░░█ ███░░░░███ ███░░░░███
  ░███    ░███ ░███    ░███  ░███    ░███ ░   ░███  ░ ░░░    ░███░░░    ░███
 ░██████████  ░███████████  ░███████████     ░███       ██████░    ███████ 
 ░███░░░░░░   ░███░░░░░███  ░███░░░░░███     ░███      ░░░░░░███  ███░░░░  
  ░███         ░███    ░███  ░███    ░███     ░███     ███   ░███ ███      █
  █████        █████   █████ █████   █████    █████   ░░████████ ░██████████
 ░░░░░        ░░░░░   ░░░░░ ░░░░░   ░░░░░    ░░░░░     ░░░░░░░░  ░░░░░░░░░░ 
"@
# Display centered banners
Clear-Host
Write-Host ""
Write-Host ""

$banner1Lines = $BANNER1.TrimEnd() -split "`n"
$maxWidth = ($banner1Lines | Measure-Object -Property Length -Maximum).Maximum
$hostWidth = $Host.UI.RawUI.WindowSize.Width
foreach ($line in $banner1Lines) {
    $line = $line.TrimEnd()
    $paddingLength = [Math]::Max(0, [math]::Floor(($hostWidth - $line.Length) / 2))
    $padding = if ($paddingLength -gt 0) { " " * $paddingLength } else { "" }
    Write-Host ($padding + $line) -ForegroundColor DarkMagenta
}

Write-Host ""
$hostWidth = $Host.UI.RawUI.WindowSize.Width
$text = "FAT-32 Disk Conversion Tool"
$padding = " " * [math]::Max(0, ($hostWidth - $text.Length) / 2)
Write-Host ($padding + $text) -ForegroundColor Cyan
Write-Host ""
Write-Host ""
Write-Host ("*" * $hostWidth) -ForegroundColor Red

# Get drive letter from user
$driveLetter = Read-Host "Enter drive letter (e.g. E)"

# Validate input
if ($driveLetter -notmatch '^[A-Za-z]$') {
    Write-Error "Invalid input. Please enter a single letter."
    exit 1
}

# Format drive letter for use
$driveLetter = $driveLetter.ToUpper()

# Confirm with user
$confirmation = Read-Host "WARNING: This will format ${driveLetter}: drive. All data will be lost! Are you sure? (Y/N)"
if ($confirmation -ne 'Y') {
    Write-Host "Operation cancelled."
    exit 0
}

try {
    # Execute format command
    Write-Host "Formatting drive ${driveLetter}:..."
    Format-Volume -DriveLetter $driveLetter -FileSystem FAT32 -Force
    Write-Host "Format completed successfully."
}
catch {
    Write-Error "Error formatting drive: $_"
    exit 1
}

