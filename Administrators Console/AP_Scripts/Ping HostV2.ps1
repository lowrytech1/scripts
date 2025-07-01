# Function to ping a host
function Ping-Host {
    param (
        [string]$Computer,
        [switch]$Continuous
    )

    if ($Continuous) {
        # Continuous ping
        Test-Connection -TargetName $Computer -Continuous -ipv4
    } else {
        # Send four pings
        Test-Connection -TargetName $Computer -Count 4 -ipv4
    }
}

# Start a loop that will run until the user selects the "Exit" option
$exit = $false
while (!$exit) {
    Clear-Host

    #Header
    Write-Host ""
    Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "********** Ping Host **********" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host ""

    #Command
    $computer = Read-Host -Prompt "Domain Name or IP address of host to Ping"

    # Ask user for ping type
    Write-Host ""
    Write-Host "    Ping Type:"
    Write-Host "     1) Four Pings" -ForegroundColor Green
    Write-Host "     2) Continuous Ping" -ForegroundColor Green
    Write-Host ""
    $pingType = Read-Host -Prompt "Enter a selection (1 or 2):"

    if ($pingType -eq "1") {
        Ping-Host -Computer $computer
    } elseif ($pingType -eq "2") {
        Ping-Host -Computer $computer -Continuous
    } else {
        Write-Host "Invalid Selection. Defaulting to Four Pings." -ForegroundColor Red
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

        If ($doNext -eq "1") {
            Clear-Host
            Write-Host ""
            Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "********** Ping Host **********" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host ""
        
            # Ask user for ping type again
            Write-Host ""
            Write-Host "    Ping Type:"
            Write-Host "     1) Four Pings" -ForegroundColor Green
            Write-Host "     2) Continuous Ping" -ForegroundColor Green
            Write-Host ""
            $pingType = Read-Host -Prompt "Enter a selection (1 or 2):"

            if ($pingType -eq "1") {
                Ping-Host -Computer $computer
            } elseif ($pingType -eq "2") {
                Ping-Host -Computer $computer -Continuous
            } else {
                Write-Host "Invalid Selection. Defaulting to Four Pings." -ForegroundColor Red
                Ping-Host -Computer $computer
            }
        } ElseIf ($doNext -eq "2") {
            break  # Exit the inner loop to prompt for a new host
        } Elseif ($doNext -eq "3") {
            $exit = $true
            break  # Exit the inner loop and the outer loop
        } Else {
            write-host "Invalid Selection" -ForegroundColor Red
        }
    }
}