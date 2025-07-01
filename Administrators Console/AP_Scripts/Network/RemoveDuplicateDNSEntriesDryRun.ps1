# Define parameters
$DnsServer = "ITS-KCRFDC01.kerncounty.com"
$ZoneName = "kerncounty.com"

# Get all A records in the DNS zone
$dnsRecords = Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -RRType A

# Filter out static records (records without a timestamp)
$dnsRecords = $dnsRecords | Where-Object { $_.Timestamp -ne $null }

# Group records by IPAddress
$groupedRecords = $dnsRecords | Group-Object -Property { $_.RecordData.IPv4Address.IPAddressToString }

# Process each group of records
foreach ($group in $groupedRecords) {
    $IPAddress = $group.Name
    $records = $group.Group

    # Process only if there are duplicates (more than one record for the same IP address)
    if ($records.Count -gt 1) {
        # Sort records by timestamp in descending order (newest first)
        $sortedRecords = $records | Sort-Object -Property {[datetime]$_.Timestamp} -Descending

        # Keep the newest record (first in the sorted list)
        $newestRecord = $sortedRecords[0]

        # Log the record that would be kept
        Write-Host "KEEP: HostName=$($newestRecord.HostName), IPAddress=$IPAddress, Timestamp=$($newestRecord.Timestamp)" -ForegroundColor Green

        # Log the records that would be removed
        foreach ($record in $sortedRecords[1..($sortedRecords.Count - 1)]) {
            Write-Host "REMOVE: HostName=$($record.HostName), IPAddress=$IPAddress, Timestamp=$($record.Timestamp)" -ForegroundColor Red
        }
    }
}