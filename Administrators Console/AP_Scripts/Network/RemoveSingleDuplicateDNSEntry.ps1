# Define parameters
$DnsServer = "ITS-KCRFDC01.kerncounty.com"
$ZoneName = "kerncounty.com"
$IPAddress = "11.50.155.180"

# Get all A records for the specified IP address
$dnsRecords = Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -RRType A | Where-Object {
    $_.RecordData.IPv4Address.IPAddressToString -eq $IPAddress
}

# Check if there are multiple records for the same IP address
if ($dnsRecords.Count -gt 1) {
    # Sort records by timestamp in descending order (newest first)
    $sortedRecords = $dnsRecords | Sort-Object -Property {[datetime]$_.Timestamp} -Descending

    # Keep the newest record (first in the sorted list)
    $newestRecord = $sortedRecords[0]

    # Remove all older records
    foreach ($record in $sortedRecords[1..($sortedRecords.Count - 1)]) {
        Remove-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -InputObject $record -Force
        Write-Host "Removed record: HostName=$($record.HostName), IPAddress=$($record.RecordData.IPv4Address.IPAddressToString), Timestamp=$($record.Timestamp)"
    }

    # Log the retained record
    Write-Host "Kept newest record: HostName=$($newestRecord.HostName), IPAddress=$($newestRecord.RecordData.IPv4Address.IPAddressToString), Timestamp=$($newestRecord.Timestamp)"
} else {
    Write-Host "No duplicates found for IP address $IPAddress."
}