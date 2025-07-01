# Set Environment Values
[console]::windowwidth = 36
[console]::windowheight = 5
[console]::bufferwidth = [console]::windowwidth
$host.UI.RawUI.BackgroundColor = "black"
$host.UI.RawUI.ForegroundColor = "blue"
$host.UI.RawUI.WindowTitle = "Process Timer V2"
[System.Console]::CursorVisible = $false  # Hide the cursor

# Start a loop that will run until the user selects the `"Exit`" option
$exit = $false
while (!$exit) {
    # Execute Stopwatch
    $stopWatch = [system.diagnostics.stopwatch]::startNew()
    while ($True) {
        $ts = $stopwatch.Elapsed
        $elapsedTime = "{0:00}:{1:00}:{2:00}" -f $ts.Hours, $ts.Minutes, $ts.Seconds
        Clear-Host
        Write-Host ""
        Write-Host "    Current duration is " -NoNewline -ForegroundColor Blue
        Write-Host "$elapsedTime" -ForegroundColor DarkRed
        Write-Host ""
        Write-Host "   Press `[SPACE`] to stop the timer" -ForegroundColor Red 
        Start-Sleep -Seconds 1

        # Check for key press
        if ($host.UI.RawUI.KeyAvailable) {
            $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            if ($key.VirtualKeyCode -eq 32) {  # Space bar key code is 32
                $totalTime = $elapsedTime
                $stopWatch.Stop()
                break
            }
        }
    }
    Clear-Host
    Write-Host ""
    Write-Host "      `e[90m Total Time: `e[0m `e[5;31m $($totalTime)`e[25;0m" -ForegroundColor Yellow
    
    # Option to exit or continue
    Start-sleep -seconds 3
    Write-Host ""
    Write-Host "        Press 'E' to exit, " -ForegroundColor Red #-NoNewline
    Write-Host "     Right-click to restart." -ForegroundColor Yellow -NoNewline
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    if ($key.Character -eq 'E' -or $key.Character -eq 'e') {
        $exit = $true
    }
}


 