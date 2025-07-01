# Fun PowerShell Script: Random Jokes

# Set up the console window
[console]::windowwidth = 60
[console]::windowheight = 16
[console]::bufferwidth = [console]::windowwidth
$host.UI.RawUI.BackgroundColor = "black"
$host.UI.RawUI.ForegroundColor = "green"
$host.UI.RawUI.WindowTitle = "Joke Generator"
Clear-Host

# Array of words to substitute "random"
$words = @("funny", "hilarious", "silly", "witty", "amusing", "dumb", "stupid", "clever", "corny", "cheesy", "ridiculous", "annoying", "embarrassing", "goofy", "lame", "nerdy", "quirky", "snarky", "wacky", "weird", "zany", "obnoxious", "outrageous", "sassy", "sarcastic", "sardonic", "satirical", "silly", "snide", "whimsical", "absurd", "bizarre", "crazy", "farcical", "idiotic", "impractical", "inane", "ludicrous", "nonsensical", "nutty", "preposterous", "ridiculous", "senseless", "silly", "stupid", "wacky", "zany", "asinine", "cockeyed", "daffy", "dumb", "half-baked", "half-witted", "harebrained")


# Function to get a random joke from an API
function Get-RandomJoke {
    $response = Invoke-RestMethod -Uri "https://official-joke-api.appspot.com/random_joke"
    return $response
}

# Main loop to display jokes
while ($true) {
    Clear-Host
    [console]::CursorVisible = $false  # Hide the cursor
    $joke = Get-RandomJoke
    $randomWord = $words | Get-Random
    Write-Host ""
    Write-Host "************************************************************" -ForegroundColor Red
    Write-Host ""
    Write-Host "             Here's a $randomWord joke for you:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  " -nonewline
    $joke.setup
    (New-Object -ComObject Sapi.spvoice).speak($joke.setup) | Out-Null
    Start-Sleep -Seconds 3
    Write-Host ""
    Write-Host "  " -nonewline
    $joke.punchline
    Write-Host ""
    Write-Host ""
    Write-Host "************************************************************" -ForegroundColor Red
    (New-Object -ComObject Sapi.spvoice).speak($joke.punchline) | Out-Null
    Write-Host ""
    $randomWord = $words | Get-Random
    Start-Sleep -Seconds 2
    Write-Host "                  Only Quitters press Q." -ForegroundColor Red
    Write-Host "           Mash any key for more $randomWord jokes." -ForegroundColor Yellow
    
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    if ($key.Character -eq 'q') {
        break
    }
}

# Reset console colors
$host.UI.RawUI.BackgroundColor = "black"
$host.UI.RawUI.ForegroundColor = "white"
Clear-Host

Write-Host "Hey $env:USERNAME, you the man!"
$(([adsi]"LDAP://$(whoami /fqdn)").givenName)
