<# ToDo:
2. Description
3. error handling
4. Status messages
5. Format table
#>

#Set Environment Values
[console]::windowwidth=150;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
#$host.UI.RawUI.BackgroundColor="black";
#$host.UI.RawUI.ForegroundColor="a";
$host.UI.RawUI.WindowTitle="PS-NSLookup V2";

# Header
Clear-Host
# Banner text definitions
$BANNER1 = @" 
   ███████████   █████████        ██████   █████  █████████  █████                         █████                              █████   █████  ████████ 
  ░░███░░░░░███ ███░░░░░███      ░░██████ ░░███  ███░░░░░███░░███                         ░░███                              ░░███   ░░███  ███░░░░███
   ░███    ░███░███    ░░░        ░███░███ ░███ ░███    ░░░  ░███         ██████   ██████  ░███ █████ █████ ████ ████████     ░███    ░███ ░░░    ░███
   ░██████████ ░░█████████  ██████░███░░███░███ ░░█████████  ░███        ███░░███ ███░░███ ░███░░███ ░░███ ░███ ░░███░░███    ░███    ░███    ███████ 
  ░███░░░░░░   ░░░░░░░░███ ░░░░░░ ░███ ░░██████  ░░░░░░░░███ ░███       ░███ ░███░███ ░███ ░██████░   ░███ ░███  ░███ ░███    ░░███   ███    ███░░░░  
   ░███         ███    ░███       ░███  ░░█████  ███    ░███ ░███      █░███ ░███░███ ░███ ░███░░███  ░███ ░███  ░███ ░███     ░░░█████░    ███      █
   █████       ░░█████████        █████  ░░█████░░█████████  ███████████░░██████ ░░██████  ████ █████ ░████████  ░███████        ░░███     ░██████████
 ░░░░░         ░░░░░░░░░  ░      ░░░░    ░░░░░  ░░░░░░░░░  ░░░░░░░░░░░  ░░░░░░   ░░░░░░  ░░░░ ░░░░░    ░░░░░░░  ░███░░░          ░░░      ░░░░░░░░░░ 
                                                                                 ░███                                 
                                                                                 █████                                
                                                                                ░░░░░                                 
"@      
# Display centered banners
Clear-Host
Write-Host ""
Write-Host ""
Write-Host ""
$banner1Lines = $BANNER1.TrimEnd() -split "`n"
$maxWidth = ($banner1Lines | Measure-Object -Property Length -Maximum).Maximum
$hostWidth = $Host.UI.RawUI.WindowSize.Width

foreach ($line in $banner1Lines) {
    $line = $line.TrimEnd()
    $paddingLength = [Math]::Max(0, [math]::Floor(($hostWidth - $line.Length) / 2))
    $padding = if ($paddingLength -gt 0) { " " * $paddingLength } else { "" }
    Write-Host ($padding + $line) -ForegroundColor DarkYellow
}

Write-Host ""
Write-Host ""

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
