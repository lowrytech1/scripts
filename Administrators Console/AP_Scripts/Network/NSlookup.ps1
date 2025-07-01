# Define input and output file paths
$inputFilePath = read-host "Enter the path to the input CSV file"
$outputFilePath = read-host "Enter the path to the output CSV file"

# Read the list of IP addresses from the input CSV file
$ipAddresses = Import-Csv -Path $inputFilePath

# Check if IP addresses were read correctly
if ($ipAddresses.Count -eq 0) {
    Write-Host "No IP addresses found in the input file." -ForegroundColor Red
    exit
}

# Create an array to store the results
$results = @()

# Perform DNS lookup for each unique IP address
$uniqueIPs = $ipAddresses.IPAddress | Select-Object -Unique
foreach ($ip in $uniqueIPs) {
    try {
        $dnsResult = [System.Net.Dns]::GetHostEntry($ip)
        $hostName = $dnsResult.HostName
    } catch {
        $hostName = "Lookup failed"
    }
    $results += [PSCustomObject]@{
        IPAddress = $ip
        HostName = $hostName
    }
}

# Check if results were generated
if ($results.Count -eq 0) {
    Write-Host "No results to write to the output file." -ForegroundColor Red
    exit
}

# Export the results to the output CSV file
$results | Export-Csv -Path $outputFilePath -NoTypeInformation

Write-Host "DNS lookup results have been written to $outputFilePath" -ForegroundColor Green
