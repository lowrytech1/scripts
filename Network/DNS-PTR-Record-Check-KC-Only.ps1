# Gather device information for the DNS comparison.
$deviceInfo = Read-Host -Prompt 'Input the computer name to view DNS information' 

# DNS Servers currently in use
$dnsServers = @("11.50.26.177", "11.50.26.178", "11.2.48.106", "11.2.48.107")

foreach ($servers in $dnsServers) {
    
    # Use the computer hostname to get DNS information.
    $dnsInfo = Resolve-DnsName -Name $deviceInfo -Server $servers | Where-Object -Property IPAddress -like "11.*.*.*"
    $dnsHostname = $dnsInfo.Name

    # Use IP address to get reverse DNS information.
    $ptrInfo = Resolve-DnsName $dnsInfo.IP4Address -Server $servers -ErrorAction SilentlyContinue
    $ptrHostname = $ptrInfo.NameHost

    if ($null -eq $ptrHostname) {

        Write-Host "No Reverse DNS record found for $dnsHostName on $servers" -ForegroundColor Yellow
        continue
    }

    # Compare the hostname from the A and PTR records.
    if ($dnsHostName -match $ptrHostname) {

        # If returns true then the hostnames match.
        Write-Host "The hostnames for $dnsHostName are a match on $servers." -ForegroundColor Green
        continue
        }
        else {
        # If returns false then the hostnames do not match.
        Write-host "The hostnames for $dnsHostName are NOT a match on $servers.`n" -ForegroundColor Red
        Write-Host "Displaying DNS Information." -ForegroundColor Red
        $dnsInfo | Select-Object name,ip4address,type,ttl | Format-List
        Write-Host "Displaying Reverse DNS Information." -ForegroundColor Red
        $ptrInfo | Format-List
        continue
    }
}