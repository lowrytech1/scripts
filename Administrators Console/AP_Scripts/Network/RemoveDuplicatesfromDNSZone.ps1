# Define parameters
$DnsServer = "ITS-KCRFDC01.kerncounty.com"
$ZoneName = "kerncounty.com"

# Get all A records in the DNS zone
$dnsRecords = Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -RRType A

# Group records by IPAddress
$groupedRecords = $dnsRecords | Group-Object -Property { $_.RecordData.IPv4Address.IPAddressToString }

# Process each group of records
foreach ($group in $groupedRecords) {
    $IPAddress = $group.Name
    $records = $group.Group

    # Check if there are multiple records for the same IP address
    if ($records.Count -gt 1) {
        # Sort records by timestamp in descending order (newest first)
        $sortedRecords = $records | Sort-Object -Property {[datetime]$_.Timestamp} -Descending

        # Keep the newest record (first in the sorted list)
        $newestRecord = $sortedRecords[0]

        # Remove all older records
        foreach ($record in $sortedRecords[1..($sortedRecords.Count - 1)]) {
            Remove-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -InputObject $record -Force
            Write-Host "Removed record: HostName=$($record.HostName), IPAddress=$IPAddress, Timestamp=$($record.Timestamp)"
        }

        # Log the retained record
        Write-Host "Kept newest record: HostName=$($newestRecord.HostName), IPAddress=$IPAddress, Timestamp=$($newestRecord.Timestamp)"
    } else {
        Write-Host "No duplicates found for IP address $IPAddress."
    }
}