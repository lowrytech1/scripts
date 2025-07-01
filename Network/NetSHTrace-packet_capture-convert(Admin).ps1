# Set console dimensions
[console]::WindowWidth = 86
[console]::WindowHeight = 30
[console]::BufferWidth = 86
[console]::BufferHeight = 3000

# Define tool paths at script level
$toolPath = "C:\Program Files\etl2pcapng"
$toolExe = Join-Path $toolPath "etl2pcapng.exe"
$toolUrl = "https://github.com/microsoft/etl2pcapng/releases/download/v1.11.0/etl2pcapng.exe"

# Add tool installation function
function Install-Etl2PcapNG {
    if (-not (Test-Path $toolExe)) {
        Write-Host "etl2pcapng.exe not found. Installing..." -ForegroundColor Yellow
        
        # Create directory if it doesn't exist
        if (-not (Test-Path $toolPath)) {
            New-Item -ItemType Directory -Path $toolPath -Force | Out-Null
        }

        # Download the tool from the official GitHub release page
        try {
            Invoke-WebRequest -Uri $toolUrl -OutFile $toolExe
            Write-Host "etl2pcapng.exe successfully installed." -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to download etl2pcapng.exe. Please download manually." -ForegroundColor Red
            Write-Host "Download URL: $toolUrl" -ForegroundColor Blue
            exit 1
        }
    }
}
Clear-Host
Write-host ""
Write-host " ************************************************************************************" -ForegroundColor Green
Write-host "                       PCAPNG Packet Capture and Conversion Script" -ForegroundColor Red
Write-host ""
Write-host "                This script executes a packet capture using 'netsh trace'." -ForegroundColor White
Write-host "                           Final output will be a .PCAPNG file" -ForegroundColor White
Write-host ""
Write-host " ************************************************************************************" -ForegroundColor Green
Write-host ""
# Get desired collection duration and save path from user
[int]$Duration = Read-Host "   Capture Duration (Minutes)"
$filePath = "c:\capfile.etl"
Write-Host "   Enter the path and filename where you want to save the .pcapng file (.pcapng)"
$pcapFilePath = read-host 
Write-host ""
Write-host "   Capture will automatically stop after $Duration minutes"
Write-host ""
Read-host "   Press [ENTER] to start the packet capture..."

# Begin packet capture
netsh trace start capture=yes tracefile=$filePath

# Initialize progress bar variables
$progressActivity = "Packet Capture in Progress"
$progressStatus = "Capturing packets..."
$totalSeconds = $Duration * 60
$elapsedSeconds = 0

# Update progress bar in a loop
while ($elapsedSeconds -lt $totalSeconds) {
    $percentComplete = ($elapsedSeconds / $totalSeconds) * 100
    Write-Progress -Activity $progressActivity -Status $progressStatus -PercentComplete $percentComplete
    Start-Sleep -Seconds 1
    $elapsedSeconds++
}

# Allow the capture to run for desired Duration.
Start-Sleep -Seconds ($Duration * 60)

# Stop the packet capture
netsh trace stop

Write-Host "   ...Capture Complete." -ForegroundColor Green
Write-host ""
Write-Host "   Converting capture file to WireShark compatible file." -ForegroundColor Yellow

#############################################
# Convert ETL file to PCAP file:
# Install tool if needed
Install-Etl2PcapNG

# Run the conversion
Start-Process -FilePath $toolExe -ArgumentList "$FilePath $pcapFilePath" -NoNewWindow -Wait

# Cleanup - Remove the ETL temp file:
Remove-Item $FilePath

Write-Host "   Conversion completed. The .pcapng file is located at $pcapFilePath" -ForegroundColor Green
Write-host ""


