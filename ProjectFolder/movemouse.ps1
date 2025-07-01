# Mouse Movement Simulator
# - Moves mouse every 10 seconds
# - Pauses for 30 seconds if user movement detected
# - Spacebar toggles pause/resume

Add-Type -AssemblyName System.Windows.Forms

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class MouseOperations {
    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int X;
        public int Y;
    }

    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int x, int y);
    
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetCursorPos(out POINT lpPoint);
}
"@

# Function to move the mouse to a specified position
function Move-Mouse {
    param (
        [int]$x,
        [int]$y
    )
    
    [MouseOperations]::SetCursorPos($x, $y)
}

# Function to get current mouse position
function Get-MousePosition {
    $position = New-Object MouseOperations+POINT
    [MouseOperations]::GetCursorPos([ref]$position)
    return $position
}

# Function to check for spacebar press
function Check-Spacebar {
    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)
        if ($key.Key -eq 'Spacebar') {
            return $true
        }
    }
    return $false
}

# Function to wait with countdown while checking for spacebar
function Wait-WithSpacebarCheck {
    param (
        [int]$Seconds,
        [string]$Message,
        [ConsoleColor]$Color = 'Green'
    )
    
    for ($i = $Seconds; $i -gt 0; $i--) {
        Write-Host "`r${Message}: $i seconds remaining" -NoNewline -ForegroundColor $Color
        
        # Check for spacebar press multiple times per second for responsiveness
        for ($j = 0; $j -lt 10; $j++) {
            Start-Sleep -Milliseconds 100
            if (Check-Spacebar) {
                return $true  # Spacebar was pressed
            }
        }
    }
    Write-Host ""
    return $false  # Completed waiting without spacebar press
}

# Get screen dimensions
$screenWidth = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
$screenHeight = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height

# Initialize state
$isPaused = $false
$lastMousePosition = Get-MousePosition

# Display instructions
Write-Host "Mouse Movement Simulator Started" -ForegroundColor Green
Write-Host "Press SPACEBAR to toggle pause/unpause" -ForegroundColor Yellow
Write-Host "The script will automatically pause for 30 seconds if user movement is detected" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------------------" -ForegroundColor DarkGray

try {
    while ($true) {
        # Handle paused state
        if ($isPaused) {
            Write-Host "Script is PAUSED. Press spacebar to resume." -ForegroundColor Yellow
            while ($isPaused) {
                Start-Sleep -Milliseconds 100
                if (Check-Spacebar) {
                    $isPaused = $false
                    Write-Host "Script RESUMED" -ForegroundColor Green
                }
            }
        }

        # Move the mouse to a random position
        $x = Get-Random -Minimum 0 -Maximum $screenWidth
        $y = Get-Random -Minimum 0 -Maximum $screenHeight
        
        Write-Host "Moving mouse to position: $x, $y" -ForegroundColor Green
        Move-Mouse -x $x -y $y
        
        # Important: After moving the mouse programmatically, update our reference position
        # This prevents detecting our own movement as user input
        Start-Sleep -Milliseconds 100  # Brief pause to let the OS process the mouse movement
        $lastPosition = Get-MousePosition
        Write-Host "Position after move: X=$($lastPosition.X), Y=$($lastPosition.Y)" -ForegroundColor Gray
        
        # Wait with smaller intervals while checking for user mouse movement
        $userMovedMouse = $false
        $spacebarPressed = $false
        
        for ($i = 10; $i -gt 0; $i--) {
            Write-Host "`rNext movement: $i seconds remaining" -NoNewline -ForegroundColor Green
            
            # Check multiple times during each second
            for ($j = 0; $j -lt 10; $j++) {
                Start-Sleep -Milliseconds 100
                
                # Check for spacebar
                if (Check-Spacebar) {
                    $spacebarPressed = $true
                    break
                }
                
                # Check for user mouse movement with small tolerance (3 pixels)
                $currentPosition = Get-MousePosition
                $moveX = [Math]::Abs($currentPosition.X - $lastPosition.X)
                $moveY = [Math]::Abs($currentPosition.Y - $lastPosition.Y)
                
                if ($moveX -gt 3 -or $moveY -gt 3) {
                    Write-Host "`nUser movement detected! Movement: $moveX,$moveY pixels" -ForegroundColor Cyan
                    $userMovedMouse = $true
                    break
                }
            }
            
            if ($spacebarPressed -or $userMovedMouse) {
                break
            }
            
            # Update reference position after each second
            $lastPosition = Get-MousePosition
        }
        
        Write-Host "" # Clear the line
        
        if ($spacebarPressed) {
            $isPaused = $true
            Write-Host "Script PAUSED (manually)" -ForegroundColor Yellow
        }
        elseif ($userMovedMouse) {
            Write-Host "Pausing for 30 seconds due to user movement..." -ForegroundColor Cyan
            
            # Wait for 30 seconds with spacebar check
            $spacebarPressed = Wait-WithSpacebarCheck -Seconds 30 -Message "Paused for user activity" -Color Cyan
            
            if ($spacebarPressed) {
                $isPaused = $true
                Write-Host "`nScript PAUSED (manually)" -ForegroundColor Yellow
            } else {
                Write-Host "Resuming after user activity pause" -ForegroundColor Green
            }
        }
        
        # Update the last mouse position for the next iteration
        $lastMousePosition = Get-MousePosition
    }
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
finally {
    Write-Host "Script terminated" -ForegroundColor Red
}