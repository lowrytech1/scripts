Write-host ""
Write-host " ****************************************************************************"
Write-host ""
Write-host "   This script executes a packet capture using 'netsh trace'."
#Write-host "   Capture files are saved to '$filePath'."
Write-host ""
Write-host " ****************************************************************************"
Write-host ""
# Get desired collection duration and save path from user
[int]$Duration = Read-Host "Capture Duration (Minutes)"
$filePath = Read-Host "Enter the path where you want to save the .etl file"
Write-host ""
Write-host "Capture will automatically stop after $Duration minutes"
Write-host ""
Read-host "Press [ENTER] to start the packet capture"

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

Write-Host "Capture Complete."
Write-Host "Capture file saved to $filePath"




