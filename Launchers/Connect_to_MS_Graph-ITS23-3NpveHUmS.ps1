
Clear-Host
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

# Environment Variables:
$hostWidth = $Host.UI.RawUI.WindowSize.Width

# Ensure the Microsoft.Graph module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "Microsoft.Graph module is not installed. Installing..." -ForegroundColor red
    Install-Module -Name Microsoft.Graph -Force -Scope CurrentUser
} Else {
    Write-Host "Microsoft.Graph module is installed" -ForegroundColor green
}
# Import the AzureAD module
Import-Module Microsoft.Graph

# Debugging entry
Write-Host "  Module Installation Complete"

# Header
Write-Host "                                                                           "
Write-Host "   ************************************************************************"
Write-Host "   *                                                                      *"
Write-Host "   *                    Connecting to Azure\MS Graph...                   *"
Write-Host "   *                                                                      *"
Write-Host "   ************************************************************************"
Write-Host ""

# VERIFY AZ CONNECTION, CONNECT IF NOT.
$IsConnected = Get-MgContext
if ($IsConnected) {
    Write-host "Using established connection" -ForegroundColor Yellow
} Else {
    # Connect to Azure
    write-host "                                 Not connected" -ForegroundColor red
    Write-host "                         *** Connecting to Azure\Graph ***                        " -ForegroundColor black -BackgroundColor Yellow
    Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All" -NoWelcome
    $IsConnected
}
$IsConnected = Get-MgContext
If ( !$IsConnected) {
    write-host "                            Unable to connect to Azure" -ForegroundColor red
    exit   
} Else { 
    Write-host "                          *** Connected to Azure\Graph ***                        " -ForegroundColor black -BackgroundColor Green
    Write-host "                  You may now execute PowerShell cmdlets in Azure."
}
Write-Host ("*" * $hostWidth) -ForegroundColor Red
