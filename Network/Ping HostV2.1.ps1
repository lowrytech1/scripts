# Function to ping a host
function Ping-Host {
    param (
        [string]$Computer,
        [switch]$Continuous
    )

    $formatTable = @{
        Label = "Status"
        Expression = {
            if ($_.Status -eq "Success") {
                $color = "Green"
            } else {
                $color = "Red"
            }
            $status = $_.Status.ToString()
            $Host.UI.RawUI.ForegroundColor = $color
            Write-Output $status
            $Host.UI.RawUI.ForegroundColor = "White"
        }
    }

    try {
        if ($Continuous) {
            Write-Host "Press Ctrl+C to stop pinging..." -ForegroundColor Yellow
            while ($true) {
                $result = Test-Connection -ComputerName $Computer -Count 1 -ErrorAction Stop
                if ($result) {
                    Write-Host "Reply from $Computer : time=$($result.ResponseTime)ms" -ForegroundColor Green
                }
                Start-Sleep -Seconds 1
            }
        } else {
            $result = Test-Connection -ComputerName $Computer -Count 4 -ErrorAction Stop
            foreach ($ping in $result) {
                Write-Host "Reply from $Computer : time=$($ping.ResponseTime)ms" -ForegroundColor Green
            }
        }
    }
    catch {
        Write-Host "Unable to ping $Computer : $($_.Exception.Message)" -ForegroundColor Red
    }
}

#Set Environment Values
[console]::windowwidth=50;
[console]::windowheight=70;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.WindowTitle="PING";

# Start a loop that will run until the user selects the "Exit" option
$exit = $false
while (!$exit) {
    Clear-Host
    # Header
    # Banner text definitions
    $BANNER1 = @" 
__________.___ _______    ________ 
\______   \   |\      \  /  _____/ 
 |     ___/   |/   |   \/   \  ___ 
  |    |   |   /    |    \    \_\  \
  |____|   |___\____|__  /\______  /
                      \/        \/ 
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
    Write-Host ($padding + $line) -ForegroundColor Magenta
    }
    Write-Host ""
    Write-Host ""
    Write-Host ("*" * $hostWidth) -ForegroundColor Red
    #Command
    $computer = Read-Host -Prompt "   Domain Name or IP address"

    # Ask user for ping type
    Write-Host ""
    Write-Host "       Ping Type:"
    Write-Host "        1) Four Pings" -ForegroundColor Green
    Write-Host "        2) Continuous Ping" -ForegroundColor Green
    Write-Host ""
    $pingType = Read-Host -Prompt "   Enter a selection (1 or 2):"

    if ($pingType -eq "1") {
        Ping-Host -Computer $computer
    } elseif ($pingType -eq "2") {
        Ping-Host -Computer $computer -Continuous
    } else {
        Write-Host "   Invalid Selection. Defaulting to Four Pings." -ForegroundColor Red
        Ping-Host -Computer $computer
    }

    # Ask user what to do next
    while ($true) {
        Write-Host ""
        Write-Host "    What Now?"
        Write-Host "     1) Ping Again" -ForegroundColor Green
        Write-Host "     2) Ping new Host" -ForegroundColor Green
        Write-Host "     3) Exit" -ForegroundColor Green
        Write-Host ""
        $doNext = Read-Host -Prompt "Enter a selection (1, 2, or 3):"

        switch ($doNext) {
            "1" {
                # Repeat the same ping with same settings
                if ($pingType -eq "1") {
                    Ping-Host -Computer $computer
                } elseif ($pingType -eq "2") {
                    Ping-Host -Computer $computer -Continuous
                }
            }
            "2" { 
                break  # Exit the inner loop to prompt for a new host
            }
            "3" { 
                $exit = $true
                break  # Exit the inner loop and the outer loop
            }
            default {
                Write-Host "   Invalid Selection" -ForegroundColor Red
            }
        }

        if ($doNext -eq "2" -or $doNext -eq "3") {
            break
        }
    }
}