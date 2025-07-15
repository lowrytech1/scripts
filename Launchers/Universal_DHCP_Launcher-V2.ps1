#DHCP Launcher script by Brian Lowry, 2024
#This script will launch the DHCP console for a specific server based on the IP address provided.

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

#Set Environment Values
[console]::windowwidth=60;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
#$host.UI.RawUI.BackgroundColor="black";
#$host.UI.RawUI.ForegroundColor="a";
$host.UI.RawUI.WindowTitle="DHCP Launcher V2";

Clear-Host
# Initialize the $exit variable to $false
$exit = $false

#Ensure necessary modules load when needed:
$PSModuleAutoLoadingPreference = "All"

# Lookup DHCP server name from a table based on the IP address
$dhcpTable = @{
    "121.155.18"      = "[DHCP_Server.your.domain.com]"
    "121.21.148"      = "[DHCP_Server.your.other.domain.local]"
    "121.48.158"       = "[DHCP_Server.another.domain.local]"
    # Add more mappings as needed
}

# Function to determine the correct DHCP server based on IP address
function Get-DhcpServer($ip) {
    Write-Host "Checking IP for matching scope..."
    foreach ($scope in $dhcpTable.Keys) {
        #Write-Host "Checking if $ip starts with $scope"
        if ($ip.StartsWith($scope)) {
            Write-Host "Match found: $scope"
            return $dhcpTable[$scope]
        }
    }
    return $null
}
Function get-console {   
    Write-Host ""
    Write-Host "Enter admin username for server $dhcpServer"                     
    $userName = Read-Host "  (EG; Kerncounty\admin-blowry)"
    
    # Open DHCP Console on selected server with administrator rights
    runas /noprofile /netonly /user:$userName "C:\windows\System32\mmc.exe dhcpmgmt.msc /computerName $dhcpServer"
    Write-Host "Opening DHCP Management console for server $dhcpServer..."
    start-sleep -seconds 3
    Clear-Host
 }

# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {
    # Header
    $BANNER1 = @"
ooooooooo  ooooo ooooo  oooooooo8 oooooooooo 
 888    88o 888   888 o888     88  888    888
 888    888 888ooo888 888          888oooo88 
 888    888 888   888 888o     oo  888       
o888ooo88  o888o o888o 888oooo88  o888o      
"@
    $BANNER2 = @"
   __   ___  __  ___  _________ _________ 
  / /  / _ |/ / / / |/ / ___/ // / __/ _ \
 / /__/ __ / /_/ /    / /__/ _  / _// , _/
/____/_/ |_\____/_/|_/\___/_//_/___/_/|_| 
"@

    Write-Host ""
    Write-Host ""
    Write-CenteredText $BANNER1 -ForegroundColor DarkMagenta
    Write-CenteredText $BANNER2 -ForegroundColor DarkMagenta
    Write-Host ""
    Write-Host ("*" * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor Red
    Write-Host ""
    Write-CenteredText "Enter the IP address of the device you want to manage." -ForegroundColor Yellow
    Write-CenteredText "This script will determine the DHCP server and open"  -ForegroundColor Yellow
    Write-CenteredText "the DHCP Management console in management mode." -ForegroundColor Yellow
    Write-Host ""
    Write-Host ("*" * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor Red

    # Ask user for IP address
    $ipAddress = Read-Host "Enter the IP address"
    
    # Execute Lookup Function
    $dhcpServer = Get-DhcpServer -ip $ipAddress                           

    Write-Host ""

    if ($dhcpserver -eq "DHCP_Server.your.domain.com") {
        Write-Host "This is a [department] domain scope." -ForegroundColor yellow
        Write-Host "Please enter your [department] domain admin credentials." -ForegroundColor Red
        get-console

    } elseif ($dhcpserver -eq "[DHCP_Server.your.other.domain.local]") {
        Write-Host "This is a [department1] domain scope." -ForegroundColor yellow
        Write-Host "Please enter your [department1] domain admin credentials." -ForegroundColor Red
        get-console

    } elseif ($dhcpserver -eq "[DHCP_Server.another.domain.local]") {
        Write-Host "This is a [department2] domain scope." -ForegroundColor yellow
        Write-Host "Please enter your [department2] domain admin credentials." -ForegroundColor Red
        get-console
   
    } else {
        Write-Host "No matching DHCP server found for IP address $ipAddress" -ForegroundColor Red
        Write-Host ""
        Write-Host "Would you like to try again? (Y/N)"
        $response = Read-Host
        if ($response -ne "Y") {
            $exit = $true
        } Else {
            Clear-Host
        }
    }
}  

