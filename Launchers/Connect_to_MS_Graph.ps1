Clear-Host
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

# Environment Variables:
$hostWidth = $Host.UI.RawUI.WindowSize.Width

# Add helper function for centering text
function Write-CenteredText {
    param([string]$Text, [System.ConsoleColor]$ForegroundColor = [System.ConsoleColor]::White)
    
    # Split the text into lines
    $lines = $Text -split "`n"
    $maxLength = ($lines | Measure-Object -Property Length -Maximum).Maximum
    $windowWidth = $Host.UI.RawUI.WindowSize.Width
    
    foreach ($line in $lines) {
        # Calculate padding based on the maxLength for consistent alignment
        $padding = [Math]::Max(0, [Math]::Floor(($windowWidth - $maxLength) / 2))
        Write-Host (" " * $padding) -NoNewline
        Write-Host $line -ForegroundColor $ForegroundColor
    }
}

# Ensure the Microsoft.Graph module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "Microsoft.Graph module is not installed. Installing..." -ForegroundColor red
    Install-Module -Name Microsoft.Graph -Force -Scope CurrentUser
} Else {
    Write-Host "Microsoft.Graph module is installed" -ForegroundColor green
}
# Import the AzureAD module
Write-CenteredText "Importing MSGraph module"
Import-Module Microsoft.Graph

# Debugging entry
Write-CenteredText "Module Installation Complete"
$importTime = Get-Date
# Calculate time difference between start and end time
$Duration = New-TimeSpan -Start $StartTime -End $importTime
#Format the duration time as dd:HH:mm:ss
$formattedDuration = "{0:D2}:{1:D2}:{2:D2}:{3:D2}" -f $Duration.Days, $Duration.Hours, $Duration.Minutes, $Duration.Seconds
Write-Host "Script Duration time (dd:HH:mm:ss):" -NoNewline
Write-Host "  $formattedDuration" -foregroundcolor "yellow"

# Header
Write-Host ""
Write-CenteredText "************************************************************************"
Write-CenteredText "*                                                                      *"
Write-CenteredText "*                    Connecting to Azure\MS Graph...                   *"
Write-CenteredText "*                                                                      *"
Write-CenteredText "************************************************************************"
Write-Host ""

# VERIFY AZ CONNECTION, CONNECT IF NOT.
$IsConnected = Get-MgContext
if ($IsConnected) {
    Write-CenteredText "Using established connection"
} Else {
    # Connect to Azure
    Write-CenteredText "Not connected"
    Write-CenteredText "*** Connecting to Azure\Graph ***" -ForegroundColor black -BackgroundColor Yellow
    Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All" -NoWelcome
    $IsConnected
}
$IsConnected = Get-MgContext
If ( !$IsConnected) {
    Write-CenteredText "Unable to connect to Azure"
    exit   
} Else { 
    Write-CenteredText "*** Connected to Azure\Graph ***"
    Write-CenteredText "You may now execute PowerShell cmdlets in Azure."
}
Write-Host ("*" * $hostWidth) -ForegroundColor Red

