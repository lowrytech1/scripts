# Fun PowerShell Script: Random Jokes
# Script by Brian Lowry - 2025

# Set up the console window
[console]::windowwidth = 70
[console]::windowheight = 20
[console]::bufferwidth = [console]::windowwidth
$host.UI.RawUI.BackgroundColor = "black"
$host.UI.RawUI.ForegroundColor = "green"
$host.UI.RawUI.WindowTitle = "Joke Generator V2.1"
$ErrorActionPreference = "SilentlyContinue"
$WarningPreference = 'SilentlyContinue'

Clear-Host

# Array of words to substitute "random"
$words = @("funny", "hilarious", "silly", "questionable", "witty", "amusing", "dumb", "stupid", "clever", "corny", "cheesy", "ridiculous", "annoying", "embarrassing", "goofy", "lame", "nerdy", "quirky", "snarky", "wacky", "weird", "zany", "obnoxious", "outrageous", "sassy", "sarcastic", "sardonic", "satirical", "silly", "snide", "whimsical", "absurd", "bizarre", "crazy", "farcical", "idiotic", "impractical", "inane", "ludicrous", "nonsensical", "nutty", "preposterous", "ridiculous", "senseless", "silly", "stupid", "wacky", "zany", "asinine", "cockeyed", "daffy", "dumb", "half-baked", "half-witted", "harebrained")


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
    $Setup = $joke.setup
    $Punchline = $joke.punchline
    $randomWord = $words | Get-Random

    $BANNER1 = @"
   __        _            ___                          _             
   \ \  ___ | | _____    / _ \___ _ __   ___ _ __ __ _| |_ ___  _ __ 
    \ \/ _ \| |/ / _ \  / /_\/ _ \ '_ \ / _ \ '__/ _' | __/ _ \| '__|
 /\_/ / (_) |   <  __/ / /_\\  __/ | | |  __/ | | (_| | || (_) | |   
 \___/ \___/|_|\_\___| \____/\___|_| |_|\___|_|  \__,_|\__\___/|_|   
"@
    Write-Host ""
    Write-CenteredText $BANNER1 -ForegroundColor DarkMagenta
    Write-Host ""
    Write-CenteredText "************************************************************" -ForegroundColor Red
    Write-Host ""
    Write-CenteredText "Here's a $randomWord joke for you:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  " -nonewline
    Write-CenteredText "$Setup"
    (New-Object -ComObject Sapi.spvoice).speak($joke.setup) | Out-Null
    Start-Sleep -Seconds 3
    Write-Host ""
    Write-Host "  " -nonewline
    Write-CenteredText "$Punchline"
    Write-Host ""
    Write-Host ""
    Write-CenteredText "************************************************************" -ForegroundColor Red
    (New-Object -ComObject Sapi.spvoice).speak($joke.punchline) | Out-Null
    Write-Host ""
    $randomWord = $words | Get-Random
    Start-Sleep -Seconds 2
    Write-CenteredText "Only Quitters press Q." -ForegroundColor Red
    Write-CenteredText "Mash any key for more $randomWord jokes." -ForegroundColor Yellow
    
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    if ($key.Character -eq 'q') {
        break
    }
}

# Reset console colors
$host.UI.RawUI.BackgroundColor = "black"
$host.UI.RawUI.ForegroundColor = "white"
Clear-Host

Write-CenteredText "Hey $env:USERNAME, you the man!"
# $(([adsi]"LDAP://$(whoami /fqdn)").givenName)
