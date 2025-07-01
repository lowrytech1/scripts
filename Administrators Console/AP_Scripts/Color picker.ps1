# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {
    # Do stuff
    Write-Host "What is your favorite color?" | out-string
    Write-Host "Red `(R`)," -ForegroundColor "DarkRed" -NoNewline  | out-string
    Write-Host " Blue (B)," -ForegroundColor "DarkBlue" -NoNewline   | out-string
    Write-Host " or Green (G)" -ForegroundColor "DarkGreen" -NoNewline   | out-string
    Write-Host "? Quit (Q)" | out-string
    # Allow user to input a response
    $response = Read-Host | out-string
    # Use an if statement to output a message based on the user's response
    if ($response -eq "R") {
        Write-Host "Red is your favorite color!" -Foregroundcolor "DarkRed" | out-string 
        Write-Host "" | out-string
        Write-Host "Try again? (Y/N)" | out-string
            $response = Read-Host | out-string
            if ($response -ne "Y") {
                $exit = $true
            }
    } Elseif ($response -eq "B") {
        Write-Host "Blue is your favorite color!" -Foregroundcolor "DarkBlue" 
                Write-Host ""
        Write-Host "Try again? (Y/N)"
            $response = Read-Host
            if ($response -ne "Y") {
                $exit = $true
            }
    } Elseif ($response -eq "G") {
        Write-Host "Green is your favorite color!" -Foregroundcolor "Darkgreen" 
        Write-Host ""
        Write-Host "Try again? (Y/N)"
            $response = Read-Host
            if ($response -ne "Y") {
                $exit = $true
            }
    } Elseif ($response -eq "Q") {
        $exit = $true
    } Else {
        Write-Host "Oops! That`'s not a selection. Try again? (Y/N)"
        $response = Read-Host
        if ($response -ne "Y") {
            $exit = $true
        }
    } Clear-Host
}