#Header
# Start a loop that will run until the user selects the "Exit" option
$exit = $false
while (!$exit) {
    Write-Host ""
    Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "******* DNS Record Check ******" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "This script gets the DNS information for a computer and compares it to the reverse DNS information." -ForegroundColor Green
    Write-Host ""
    # Gather device information for the DNS comparison.
    $deviceInfo = Read-Host -Prompt 'Input the computer name to view DNS information'

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
                Write-Host "The hostnames are a match...`n" -ForegroundColor Green
                Write-Host "Displaying DNS Information." -ForegroundColor Green
                $dnsInfo | Select-Object Name, IP4Address, Type, TTL | Format-List
                Write-Host "Displaying Reverse DNS Information." -ForegroundColor Green
                $ptrInfo | Format-List
            } else {
                # If returns false then the hostnames do not match.
                Write-Host "The hostnames are NOT a match.`n" -ForegroundColor Red
                Write-Host "Displaying DNS Information." -ForegroundColor Red
                $dnsInfo | Select-Object Name, IP4Address, Type, TTL | Format-List
                Write-Host "Displaying Reverse DNS Information." -ForegroundColor Red
                $ptrInfo | Format-List
            }
        } else {
            Write-Host "No IP address found for the given computer name." -ForegroundColor Red
        }
    } catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }

    # Ask if the user wants to exit
    $exitResponse = Read-Host "Do you want to exit? (yes/no)"
    if ($exitResponse -eq "no") {
        Clear-Host
    } else {
        $exit = $true
    }
}