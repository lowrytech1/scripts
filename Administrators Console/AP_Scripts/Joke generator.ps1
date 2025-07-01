# Fun PowerShell Script: Random Jokes

# Set up the console window
[console]::windowwidth = 80
[console]::windowheight = 20
[console]::bufferwidth = [console]::windowwidth
$host.UI.RawUI.BackgroundColor = "black"
$host.UI.RawUI.ForegroundColor = "green"
$host.UI.RawUI.WindowTitle = "Random Jokes"
Clear-Host

# Function to get a random joke from an API
function Get-RandomJoke {
    $response = Invoke-RestMethod -Uri "https://official-joke-api.appspot.com/random_joke"
    return $response
}

# Main loop to display jokes
while ($true) {
    Clear-Host
    $joke = Get-RandomJoke
    Write-Host "Here's a random joke for you:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host $joke.setup -ForegroundColor Cyan
    Start-Sleep -Seconds 2
    Write-Host $joke.punchline -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Press any key to get another joke, or 'q' to quit." -ForegroundColor Yellow

    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    if ($key.Character -eq 'q') {
        break
    }
}

# Reset console colors
$host.UI.RawUI.BackgroundColor = "black"
$host.UI.RawUI.ForegroundColor = "white"
Clear-Host