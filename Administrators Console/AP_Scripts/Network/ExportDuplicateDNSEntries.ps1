# Define parameters
$DnsServer = "ITS-KCRFDC01.kerncounty.com"
$ZoneName = "kerncounty.com"
$OutputFile = "C:\Temp\DuplicateDNSRecords.xlsx"

# Ensure output directory exists
if (-not (Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp"
}

# Function to get DNS records and find duplicates
function Get-DuplicateDNSRecords {
    param (
        [string]$DnsServer,
        [string]$ZoneName
    )

    # Query DNS records using Get-DnsServerResourceRecord
    $records = Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer | Where-Object { $_.RecordType -eq 'A' }

    # Parse records into objects
    $dnsObjects = @()
    foreach ($record in $records) {
        $dnsObjects += [PSCustomObject]@{
            HostName  = $record.HostName
            IPAddress = $record.RecordData.IPv4Address.ToString()
            TimeStamp = if ($record.Timestamp -ne $null) { $record.Timestamp } else { "Static" }
        }
    }

    # Group by IP Address to find duplicates
    $duplicates = $dnsObjects | Group-Object -Property IPAddress | Where-Object { $_.Count -gt 1 }

    # Flatten results into exportable format
    $results = @()
    foreach ($group in $duplicates) {
        foreach ($record in $group.Group) {
            $results += [PSCustomObject]@{
                IPAddress = $record.IPAddress
                HostName  = $record.HostName
                TimeStamp = $record.TimeStamp
            }
        }
    }

    return $results
}

# Get duplicate DNS records with accurate timestamps
$duplicateRecords = Get-DuplicateDNSRecords -DnsServer $DnsServer -ZoneName $ZoneName

# Filter out static records before exporting to Excel
$filteredRecords = $duplicateRecords | Where-Object { $_.TimeStamp -ne "Static" }

# Export results to Excel with error handling
try {
    if ($filteredRecords.Count -gt 0) {
        # Remove existing file if necessary (to avoid conflicts)
        if (Test-Path $OutputFile) { Remove-Item -Path $OutputFile -Force }

        # Export data to Excel
        $filteredRecords | Export-Excel -Path $OutputFile -AutoSize `
            -WorksheetName "Duplicates" `
            -Title "Duplicate DNS Records" `
            -TitleBold

        Write-Host "Duplicate DNS records exported to: $OutputFile"
    } else {
        Write-Host "No duplicate DNS records with dynamic timestamps found."
    }
} catch {
    Write-Warning "Failed to export data: $_"
}