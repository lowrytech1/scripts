# DNS Record Check script modified by Brian Lowry - 2024
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
[console]::windowwidth=80;
[console]::windowheight=40;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.WindowTitle="DNS Record Check V2";

# Start a loop that will run until the user selects the "Exit" option
$exit = $false
while (!$exit) {
    # Display the banner
    $BANNER1 = @"
 |.    DDDDDDDDDDDDD        NNNNNNNN        NNNNNNNN   SSSSSSSSSSSSSSS     .|
 |.    D::::::::::::DDD     N:::::::N       N::::::N SS:::::::::::::::S    .|
 |.    D:::::::::::::::DD   N::::::::N      N::::::NS:::::SSSSSS::::::S    .|
 |.    DDD:::::DDDDD:::::D  N:::::::::N     N::::::NS:::::S     SSSSSSS    .|
 |.     D:::::D    D:::::D N::::::::::N    N::::::NS:::::S                 .|
 |.      D:::::D     D:::::DN:::::::::::N   N::::::NS:::::S                .|
 |.      D:::::D     D:::::DN:::::::N::::N  N::::::N S::::SSSS             .|
 |.      D:::::D     D:::::DN::::::N N::::N N::::::N  SS::::::SSSSS        .|
 |.      D:::::D     D:::::DN::::::N  N::::N:::::::N    SSS::::::::SS      .|
 |.      D:::::D     D:::::DN::::::N   N:::::::::::N       SSSSSS::::S     .|
 |.      D:::::D     D:::::DN::::::N    N::::::::::N            S:::::S    .|
 |.      D:::::D    D:::::D N::::::N     N:::::::::N            S:::::S    .|
 |.    DDD:::::DDDDD:::::D  N::::::N      N::::::::NSSSSSSS     S:::::S    .|
 |.    D:::::::::::::::DD   N::::::N       N:::::::NS::::::SSSSSS:::::S    .|
 |.    D::::::::::::DDD     N::::::N        N::::::NS:::::::::::::::SS     .|
 |.    DDDDDDDDDDDDD        NNNNNNNN         NNNNNNN SSSSSSSSSSSSSSS       .|
"@
    $BANNER2 = @"
 |.       ____                           __   ________              __     .|
 |.      / __ \___  _________  _________/ /  / ____/ /_  ___  _____/ /__   .|
 |.     / /_/ / _ \/ ___/ __ \/ ___/ __  /  / /   / __ \/ _ \/ ___/ //_/   .|
 |.    / _, _/  __/ /__/ /_/ / /  / /_/ /  / /___/ / / /  __/ /__/ ,<      .|
 |.   /_/ |_|\___/\___/\____/_/   \__,_/   \____/_/ /_/\___/\___/_/|_|     .|
 |.                                                                        .|
"@
    # Display centered banners
    Clear-Host
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-CenteredText $BANNER1 -ForegroundColor Green
    Write-CenteredText $BANNER2 -ForegroundColor Green
    Write-Host ""
    Write-Host ""
    Write-CenteredText "This script will verify a DNS record by"
    Write-CenteredText "querying both forward and backward lookup zones" -ForegroundColor Yellow
    Write-CenteredText "for a given computer name." -ForegroundColor Yellow    
    Write-Host ""
    Write-Host ("*" * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor Red
    Write-Host ""

    # Gather device information for the DNS comparison.
    $deviceInfo = Read-Host -Prompt '   Input the computer name to view DNS information'

    try {
        # Use the computer hostname to get DNS information.
        $dnsInfo = Resolve-DnsName -Name $deviceInfo -ErrorAction Stop
        $dnsHostname = $dnsInfo.Name
        $ipAddress = $dnsInfo.IP4Address

        if ($ipAddress) {
            # Use IP address to get reverse DNS information.
            $ptrInfo = Resolve-DnsName -Name $ipAddress -ErrorAction Stop
            $ptrHostname = $ptrInfo.NameHost

            # Compare the hostname from the A and PTR records.
            if ($dnsHostname -eq $ptrHostname) {
                # If returns true then the hostnames match.
                Write-Host "   The hostnames are a match...`n" -ForegroundColor Green
                Write-Host "   Displaying DNS Information." -ForegroundColor Green
                $dnsInfo | Select-Object Name, IP4Address, Type, TTL | Format-List
                Write-Host "   Displaying Reverse DNS Information." -ForegroundColor Green
                $ptrInfo | Format-List
            } else {
                # If returns false then the hostnames do not match.
                Write-Host "   The hostnames are NOT a match.`n" -ForegroundColor Red
                Write-Host "   Displaying DNS Information." -ForegroundColor Red
                $dnsInfo | Select-Object Name, IP4Address, Type, TTL | Format-List
                Write-Host "   Displaying Reverse DNS Information." -ForegroundColor Red
                $ptrInfo | Format-List
            }
        } else {
            Write-Host "   No IP address found for the given computer name." -ForegroundColor Red
        }
    } catch {
        Write-Host "   An error occurred: $_" -ForegroundColor Red
    }

    # Ask if the user wants to exit
    $exitResponse = Read-Host "   Do you want to exit? (yes/no)"
    if ($exitResponse -eq "no") {
        Clear-Host
    } else {
        $exit = $true
    }
}