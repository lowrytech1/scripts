# PS Packet Capture and Conversion Script by Brian Lowry - 2025

# Check for elevated permissions
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "   This script requires administrator privileges. Please run as Administrator." -ForegroundColor Red
    Write-Host "   Right-click the script and select 'Run as Administrator'." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    exit 1
}

# Set console dimensions with error handling
try {
    # First set buffer size (must be larger than window)
    [console]::BufferWidth = 150
    [console]::BufferHeight = 3000
    
    # Then set window size (must be smaller than buffer)
    [console]::WindowWidth = 150
    [console]::WindowHeight = 50
    
    $host.UI.RawUI.WindowTitle = "PS Packet Capture and Conversion"
}
catch {
    # If custom sizes fail, try safe defaults
    try {
        [console]::BufferWidth = [console]::WindowWidth
        [console]::BufferHeight = 3000
        Write-Host "   Using default console dimensions" -ForegroundColor Yellow
    }
    catch {
        Write-Host "   Unable to set console dimensions. Continuing with current settings." -ForegroundColor Yellow
    }
}

# Define tool paths at script level
$toolPath = "C:\Program Files\etl2pcapng"
$toolExe = Join-Path $toolPath "etl2pcapng.exe"
$toolUrl = "https://github.com/microsoft/etl2pcapng/releases/download/v1.11.0/etl2pcapng.exe"

# Define file paths
$filePath = Join-Path $env:TEMP "temp_capture.etl"

# Add error handling function
function Write-ErrorLog {
    param([string]$ErrorMessage)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] ERROR: $ErrorMessage"
    Write-Host $logMessage -ForegroundColor Red
    # Optionally log to file
    $logMessage | Out-File -Append -FilePath "$env:TEMP\PacketCapture_Error.log"
}

# Add cleanup function
function Invoke-Cleanup {
    param([string]$FilePath)
    if (Test-Path $FilePath) {
        try {
            Remove-Item $FilePath -Force
            Write-Host "   Cleaned up temporary files." -ForegroundColor Yellow
        }
        catch {
            Write-ErrorLog "   Failed to clean up temporary file: $FilePath"
        }
    }
}

# Add restart function
function Restart-Script {
    param(
        [string]$ErrorMessage,
        [int]$CurrentAttempt = 1,
        [int]$MaxAttempts = 3
    )
    
    Write-ErrorLog $ErrorMessage
    
    if ($CurrentAttempt -ge $MaxAttempts) {
        Write-Host "   Maximum retry attempts ($MaxAttempts) reached. Exiting script." -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    Write-Host "   Attempting to restart script (Attempt $CurrentAttempt of $MaxAttempts)..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    
    # Store the attempt count in an environment variable
    $env:SCRIPT_ATTEMPT = $CurrentAttempt + 1
    
    # Restart the script
    & $PSCommandPath
    exit
}

# Add tool installation function
function Install-Etl2PcapNG {
    if (-not (Test-Path $toolExe)) {
        try {
            Write-Host "   etl2pcapng.exe not found. Installing..." -ForegroundColor Yellow
            
            if (-not (Test-Path $toolPath)) {
                New-Item -ItemType Directory -Path $toolPath -Force -ErrorAction Stop | Out-Null
            }

            Invoke-WebRequest -Uri $toolUrl -OutFile $toolExe -ErrorAction Stop
            
            if (-not (Test-Path $toolExe)) {
                throw "   Installation failed - executable not found after download"
            }
            
            Write-Host "   etl2pcapng.exe successfully installed." -ForegroundColor Green
        }
        catch {
            Restart-Script "   Failed to install etl2pcapng.exe: $_" $currentAttempt
        }
    }
}

# Add helper function for centering text
function Write-CenteredText {
    param([string]$Text, [System.ConsoleColor]$ForegroundColor = [System.ConsoleColor]::White)
    
    # Split the text into lines
    $lines = $Text -split "`n"
    $maxLength = ($lines | Measure-Object -Property Length -Maximum).Maximum
    $windowWidth = $Host.UI.RawUI.WindowSize.Width
    
    foreach ($line in $lines) {
        # Calculate padding without trimming spaces
        $padding = [Math]::Max(0, [Math]::Floor(($windowWidth - $line.Length) / 2))
        Write-Host (" " * $padding) -NoNewline
        Write-Host $line -ForegroundColor $ForegroundColor
    }
}

Clear-Host
# Header

# Get StartTime
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

$BANNER1 = @"
ooooooooo.                       oooo                      .          .oooooo.                            .                                  
'888   'Y88.                     '888                    .o8         d8P'  'Y8b                         .o8                                  
 888   .d88'  .oooo.    .ooooo.   888  oooo   .ooooo.  .o888oo      888           .oooo.   oo.ooooo.  .o888oo oooo  oooo  oooo d8b  .ooooo.  
 888ooo88P'  'P  )88b  d88' '"Y8  888 .8P'   d88' '88b   888        888          'P  )88b   888' '88b   888   '888  '888  '888""8P d88' '88b 
 888          .oP"888  888        888888.    888ooo888   888        888           .oP"888   888   888   888    888   888   888     888ooo888 
 888         d8(  888  888   .o8  888 '88b.  888    .o   888 .      '88b    ooo  d8(  888   888   888   888 .  888   888   888     888    .o 
o888o        'Y888""8o 'Y8bod8P' o888o o888o 'Y8bod8P'   "888"       'Y8bood8P'  'Y888""8o  888bod8P'   "888"  'V88V"V8P' d888b    'Y8bod8P' 
                                                                                            888                                              
                                                                                           o888o                                             
"@
$BANNER2 = @"
              8    .d88b                                    w                 w               8
.d88 8d8b. .d88    8P    .d8b. 8d8b. Yb  dP .d88b 8d8b d88b w .d8b. 8d8b.    w8ww .d8b. .d8b. 8
8  8 8P Y8 8  8    8b    8' .8 8P Y8  YbdP  8.dP' 8P   'Yb. 8 8' .8 8P Y8     8   8' .8 8' .8 8
'Y88 8   8 'Y88    'Y88P 'Y8P' 8   8   YP   'Y88P 8    Y88P 8 'Y8P' 8   8     Y8P 'Y8P' 'Y8P' 8
"@
                  
# Display centered banners
Write-Host ""
Write-Host ""
Write-CenteredText $BANNER1 -ForegroundColor DarkRed
Write-CenteredText $BANNER2 -ForegroundColor DarkRed
Write-Host ""
Write-Host ""
Write-CenteredText "This script executes a packet capture using 'netsh trace'." -ForegroundColor Yellow
Write-CenteredText "It also downloads a tool to convert the trace file to" -ForegroundColor Yellow
Write-CenteredText "a WireShark-compatible .PCAPNG file for analysis." -ForegroundColor Yellow
Write-CenteredText "Final output will be a .PCAPNG file." -ForegroundColor Yellow
Write-Host ""
Write-Host ("*" * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor Red
Write-Host ""

# Get current attempt number from environment
$currentAttempt = [int]($env:SCRIPT_ATTEMPT ?? 1)

# Get desired collection duration and save path from user
try {
    [int]$Duration = Read-Host "   Capture Duration (Minutes)"
    if ($Duration -lt 1 -or $Duration -gt 60) {
        throw "   Duration must be between 1 and 60 minutes"
    }
} catch {
    Restart-Script "   Invalid duration specified: $_" $currentAttempt
}

# Validate output path
$pcapFilePath = Read-Host "   Enter the path and filename where you want to save the .pcapng file (.pcapng)"
if (-not ($pcapFilePath -match '\.pcapng$')) {
    $pcapFilePath += '.pcapng'
}
try {
    $pcapDirectory = Split-Path $pcapFilePath -Parent
    if (-not (Test-Path $pcapDirectory)) {
        New-Item -ItemType Directory -Path $pcapDirectory -Force -ErrorAction Stop | Out-Null
    }
} catch {
    Write-ErrorLog "   Invalid output path specified: $_"
    exit 1
}

Write-host ""
Write-host "   Capture will automatically stop after $Duration minutes"
Write-host ""
Read-host "   Press [ENTER] to start the packet capture..."

# Begin packet capture
try {
    # Ensure temp directory is accessible
    if (-not (Test-Path $env:TEMP)) {
        throw "   Temporary directory not accessible"
    }
    
    # Remove existing temp file if present
    if (Test-Path $filePath) {
        Remove-Item $filePath -Force
    }
    
    $result = netsh trace start capture=yes tracefile="$filePath"
    if ($result -match "failed") {
        throw "   Failed to start packet capture"
    }

    # Initialize progress bar variables
    $progressActivity = "   Packet Capture in Progress"
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

    $stopResult = netsh trace stop
    if ($stopResult -match "failed") {
        throw "   Failed to stop packet capture"
    }
} catch {
    Invoke-Cleanup -FilePath $filePath
    Restart-Script "   Packet capture error: $_" $currentAttempt
}

Write-Host "   ...Capture Complete." -ForegroundColor Green
Write-host ""
Write-Host "   Converting capture file to WireShark compatible file." -ForegroundColor Yellow
Write-Host "   This process may take several minutes depending on file size..." -ForegroundColor Yellow

# Add a spinning cursor animation during conversion
$spinChars = '|', '/', '-', '\'
$spinIndex = 0
$job = Start-Job -ScriptBlock {
    while ($true) {
        Start-Sleep -Milliseconds 250
    }
}

#############################################
# Convert ETL file to PCAP file:
# Install tool if needed
try {
    Install-Etl2PcapNG
    
    Write-Host "   Starting conversion process..." -ForegroundColor Cyan
    
    # Show spinning cursor during conversion
    $processInfo = Start-Process -FilePath $toolExe -ArgumentList "$FilePath $pcapFilePath" -NoNewWindow -PassThru
    while (-not $processInfo.HasExited) {
        Write-Host "`r   Converting... $($spinChars[$spinIndex])" -NoNewline -ForegroundColor Cyan
        $spinIndex = ($spinIndex + 1) % $spinChars.Length
        Start-Sleep -Milliseconds 250
    }
    
    # Clear the spinning cursor line
    Write-Host "`r                                " -NoNewline
    
    if ($processInfo.ExitCode -ne 0) {
        throw "   Conversion process failed with exit code: $($processInfo.ExitCode)"
    }

    # Verify conversion succeeded
    if (-not (Test-Path $pcapFilePath)) {
        throw "   Conversion failed - output file not found"
    }

    # Cleanup only if conversion successful
    Invoke-Cleanup -FilePath $filePath

    Write-Host "   Conversion completed. The .pcapng file is located at $pcapFilePath" -ForegroundColor Green
} catch {
    Stop-Job $job
    Remove-Job $job
    Invoke-Cleanup -FilePath $filePath
    Restart-Script "   Conversion error: $_" $currentAttempt
}

Stop-Job $job
Remove-Job $job

# Clean up environment variable at successful completion
$env:SCRIPT_ATTEMPT = $null

Write-host ""


