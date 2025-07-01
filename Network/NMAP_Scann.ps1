param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile,
    [string]$OutputFile,
    [string]$NmapPath = "C:\Program Files (x86)\Nmap\nmap.exe",
    [switch]$DetailedScan = $true
)

#NMAP Scanner script by Brian Lowry - 2024.
#This script will scan the IP addresses in the input CSV file using NMAP and save the results to a CSV file.

#Get input file path from user if not provided
if (-not $InputFile) {
    $InputFile = Read-Host "Enter the path to the input file containing IP addresses"
}

# Set default output file name with timestamp if not provided
if (-not $OutputFile) {
    $timeStamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $OutputFile = "NmapScanResults_$timeStamp.csv"
}

Clear-Host
Write-Host ""
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue -NoNewline
Write-Host "  V1.1" -ForegroundColor red
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "*********** NMAP SCANNER ***********" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

# Check if NMAP exists
if (-not (Test-Path $NmapPath)) {
    Write-Error "NMAP not found at $NmapPath. Please install NMAP or correct the path."
    exit 1
}

# Check if input file exists
if (-not (Test-Path $InputFile)) {
    Write-Error "Input file not found: $InputFile"
    exit 1
}

# Create array to store results
$results = @()

# Read IP addresses from file
$ipAddresses = Get-Content $InputFile

foreach ($ip in $ipAddresses) {
    Write-Host "Scanning $ip..."
    
    try {
        if ($DetailedScan) {
            # Detailed scan with OS detection and service versions
            $scanResult = & $NmapPath -sS -sV -O $ip 2>&1
        } else {
            # Basic scan
            $scanResult = & $NmapPath -sn $ip 2>&1
        }

        # Improved parsing logic
        $hostStatus = if ($scanResult -match "Host is up") { "Up" } else { "Down" }
        
        # Parse ports more safely
        $portsMatch = $scanResult | Select-String "\d+/\w+\s+\w+\s+\w+"
        $ports = if ($portsMatch) { $portsMatch -join '; ' } else { "No ports found" }
        
        # Parse OS more safely
        $osMatch = $scanResult | Select-String "OS details:.*"
        $os = if ($osMatch) { 
            $osMatch[0].ToString() -replace "OS details: ", "" 
        } else { 
            "Unknown"
        }
        
        # Create result object
        $resultObj = [PSCustomObject]@{
            IPAddress = $ip
            Status = $hostStatus
            Timestamp = Get-Date
            OpenPorts = $ports
            OperatingSystem = $os
        }
        
        $results += $resultObj
    }
    catch {
        Write-Warning "Error scanning $ip : $_"
        # Add failed scan to results
        $results += [PSCustomObject]@{
            IPAddress = $ip
            Status = "Error"
            Timestamp = Get-Date
            OpenPorts = "Scan failed"
            OperatingSystem = "Scan failed"
        }
    }
}

# Export results to CSV
$results | Export-Csv -Path $OutputFile -NoTypeInformation

Write-Host "Scan complete. Results saved to $OutputFile"
