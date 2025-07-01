Connect to Exchange-Online V3 script by Brian Lowry - 2024
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

# Set Environment Variables
[console]::windowwidth=116;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.WindowTitle="Connect to Exchange-Online V3";

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

# Header
$BANNER1 = @"
.d88b                               w       w                                 
8P    .d8b. 8d8b. 8d8b. .d88b .d8b w8ww    w8ww .d8b.                         
8b    8' .8 8P Y8 8P Y8 8.dP' 8     8       8   8' .8                         
'Y88P 'Y8P' 8   8 8   8 'Y88P 'Y8P  Y8P     Y8P 'Y8P'                         
"@
$BANNER2 = @"
8888            8                                .d88b.       8 w             
8www Yb dP .d8b 8d8b. .d88 8d8b. .d88 .d88b      8P  Y8 8d8b. 8 w 8d8b. .d88b 
8     '8.  8    8P Y8 8  8 8P Y8 8  8 8.dP' wwww 8b  d8 8P Y8 8 8 8P Y8 8.dP' 
8888 dP Yb 'Y8P 8   8 'Y88 8   8 'Y88 'Y88P      'Y88P' 8   8 8 8 8   8 'Y88P 
                                 wwdP                                         
"@

# Display centered banners
Clear-Host
Write-Host ""
Write-CenteredText $BANNER1 -ForegroundColor DarkBlue
Write-CenteredText $BANNER2 -ForegroundColor DarkBlue
Write-Host ""
Write-Host ""
Write-CenteredText "*** This script requires Microsoft PowerShell 7 or higher. ***" -ForegroundColor Yellow
Write-CenteredText "Windows PowerShell is insufficient." -ForegroundColor Yellow
Write-Host ""
Write-Host ("*" * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor Red
Write-Host ""

# Check PowerShell version
Write-Host "Checking PS version..." -ForegroundColor Yellow
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "This script requires PowerShell 7 or higher. Current version: $($PSVersionTable.PSVersion)"
    exit 1
}

# Check if ExchangeOnlineManagement module is installed and up to date
Write-Host "Checking for ExchangeOnlineManagement module..." -ForegroundColor Yellow
try {
    $module = Get-InstalledModule -Name ExchangeOnlineManagement -ErrorAction Stop
    if ($module.Version -lt "3.0.0") {
        Write-Host "Updating ExchangeOnlineManagement module..." -ForegroundColor Yellow
        Update-Module -Name ExchangeOnlineManagement -Force
    }
} catch {
    Write-Host "Installing ExchangeOnlineManagement module..." -ForegroundColor Yellow
    Install-Module -Name ExchangeOnlineManagement -Force
}

# Connect to Exchange Online with modern authentication
Write-Host "Connecting to Exchange Online..." -ForegroundColor Yellow
try {
    Connect-ExchangeOnline -ShowBanner:$false
    Write-Host "Successfully connected to Exchange Online" -ForegroundColor Green
} catch {
    Write-Error "Failed to connect to Exchange Online: $_"
    exit 1
}

#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"