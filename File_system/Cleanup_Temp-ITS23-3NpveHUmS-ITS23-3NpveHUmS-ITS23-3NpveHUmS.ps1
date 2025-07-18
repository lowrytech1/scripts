param(
    [string]$TempPath = "C:\Temp",
    [int]$RetentionDays = 30,
    [string]$LogPath = "C:\Logs\TempCleanup.log",
    [int]$IntervalHours = 24
)

# Script banner
Clear-Host
Write-Host ""
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor Yellow -BackgroundColor Blue -NoNewline
Write-Host "  V1.0" -ForegroundColor Red
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor Yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "******** TEMP FILE CLEANUP *********" -ForegroundColor Yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor Yellow -BackgroundColor Blue
Write-Host ""
Write-Host "This script will monitor a specified folder for temporary files" -ForegroundColor Green
Write-Host "   and delete any files older than a specified number of days." -ForegroundColor Green
Write-Host "The cleanup process will run at regular intervals to ensure that" -ForegroundColor Green
Write-Host "   the folder does not become cluttered with old files." -ForegroundColor Green
Write-Host "The script will log its activities to a file for reference." -ForegroundColor Green
Write-Host ""
Write-Host "You can execute the script with custom parameters to fit your needs:"
Write-Host "E.G.: .\Cleanup_Temp.ps1 -TempPath 'D:\CustomTemp' -RetentionDays 7 -IntervalHours 12"
Write-Host ""
Write-Host ""

# Create log directory if it doesn't exist
$LogDir = Split-Path $LogPath -Parent
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force
}

function Write-Log {
    param($Message)
    $LogMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
    Add-Content -Path $LogPath -Value $LogMessage
    Write-Host $LogMessage
}

function Cleanup-TempFiles {
    try {
        if (-not (Test-Path $TempPath)) {
            Write-Log "Temp directory does not exist: $TempPath"
            return
        }

        $cutoffDate = (Get-Date).AddDays(-$RetentionDays)
        $files = Get-ChildItem -Path $TempPath -Recurse -File | Where-Object { $_.LastWriteTime -lt $cutoffDate }
        
        foreach ($file in $files) {
            try {
                Remove-Item $file.FullName -Force
                Write-Log "Deleted: $($file.FullName)"
            }
            catch {
                Write-Log "Error deleting $($file.FullName): $_"
            }
        }
        
        Write-Log "Cleanup completed. $($files.Count) files processed."
    }
    catch {
        Write-Log "Error during cleanup: $_"
    }
}

# Main loop
Write-Log "Starting temp file cleanup service..."
Write-Log "Monitoring folder: $TempPath"
Write-Log "Retention period: $RetentionDays days"
Write-Log "Cleanup interval: $IntervalHours hours"

while ($true) {
    Cleanup-TempFiles
    Start-Sleep -Hours $IntervalHours
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         