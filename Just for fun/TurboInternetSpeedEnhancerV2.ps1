Clear-host
Write-Host ""

#Set Environment Values
[console]::windowwidth=70;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
#$host.UI.RawUI.BackgroundColor="black";
#$host.UI.RawUI.ForegroundColor="a";
$host.UI.RawUI.WindowTitle="Turbo Speed Enhancer V2";

# Header
Clear-Host
# Banner text definitions
$TEXT61 = @"
               (             )   
  *   )        )\ )   (   ( /(    
"@ 
$TEXT62 = @"
` )  /(    (  (()/( ( )\  )\())  
"@
$Text62a = @"
 ( )(_))   )\  /(_)))((_)((_)\   
"@
$TEXT63 = @"
(_(_()) _ ((_)(_)) ((_)_   ((_)  
"@
$TEXT64 = @"
|_   _|| | | || _ \ | _ ) / _ \  
  | |  | |_| ||   / | _ \| (_) | 
  |_|   \___/ |_|_\ |___/ \___/  
"@
$TEXT65 = @"
    _____   __________________  _   ______________
   /  _/ | / /_  __/ ____/ __ \/ | / / ____/_  __/
   / //  |/ / / / / __/ / /_/ /  |/ / __/   / /   
 _/ // /|  / / / / /___/ _, _/ /|  / /___  / /    
/___/_/ |_/ /_/ /_____/_/ |_/_/ |_/_____/ /_/      
"@
$TEXT66 = @"
   _______  ___________    ___  ____  ____  _________________ 
  / __/ _ \/ __/ __/ _ \  / _ )/ __ \/ __ \/ __/_  __/ __/ _ \
 _\ \/ ___/ _// _// // / / _  / /_/ / /_/ /\ \  / / / _// , _/
/___/_/  /___/___/____/ /____/\____/\____/___/ /_/ /___/_/|_|  
"@
# Add helper function for centering text
function Write-CenteredText {
    param([string]$Text, [System.ConsoleColor]$ForegroundColor = [System.ConsoleColor]::White)
    
    # Split the text into lines
    $lines = $Text -split "`n"
    $consoleWidth = $host.UI.RawUI.WindowSize.Width
    
    foreach ($line in $lines) {
        # Calculate padding without trimming spaces
        $padding = [Math]::Max(0, [Math]::Floor(($consoleWidth - $line.Length) / 2))
        Write-Host (" " * $padding) -NoNewline
        Write-Host $line -ForegroundColor $ForegroundColor
    }
}

Write-Host ""
Write-Host ""
Write-CenteredText $text61 -ForegroundColor Yellow
Write-CenteredText $text62 -ForegroundColor DarkYellow
Write-CenteredText $text62a -ForegroundColor DarkRed
Write-CenteredText $text63 -ForegroundColor DarkBlue
Write-CenteredText $text64 -ForegroundColor DarkGreen
Write-CenteredText $text65 -ForegroundColor DarkMagenta
Write-CenteredText $text66 -ForegroundColor DarkRed
Write-Output "" 

Write-Host ""
Write-Host ""
Write-CenteredText " This script is designed to enhance your internet settings." -ForegroundColor Green
Write-CenteredText " After pressing Enter, your internet speeds will double."
Write-Host ""
Write-Host ""
$enter = Read-Host "Press Enter to continue..."
if ($null -ne $enter) {
    Write-Host "Enhancing your internet speed..." -ForegroundColor Green
    Write-Host ""
    $soundFilePath = "$PSScriptRoot\..\Media\dial-up-modem-01.wav"
    if (Test-Path $soundFilePath) {
        try {
            $sound = New-Object Media.SoundPlayer
            $sound.SoundLocation = $soundFilePath
            $sound.Load()
            
            # Start playing the sound and show progress bar
            $sound.Play()
            $duration = 26 # Duration in seconds
            for ($i = 0; $i -le $duration; $i++) {
                Write-Progress -Activity "Enhancing your internet speed..." -Status "Connection Speed:" -PercentComplete (($i / $duration) * 100)
                Start-Sleep -Seconds 1
            }

            Write-CenteredText "Congratulations!" -ForegroundColor Green
            Write-CenteredText "Your internet speed has been enhanced to 33.6 BAUD!" -ForegroundColor Green
            Write-Host ""
            Start-Sleep -Seconds 2
            Write-CenteredText "Thank you for using the Internet Speed Booster." -ForegroundColor Green
            Write-Host ""
            Write-CenteredText "Press Enter to exit..." -ForegroundColor Green
            $exit = Read-Host
            If ($null -ne $exit) {
                Exit
            }
        } catch {
            Write-Host "Error: Unable to play sound file." -ForegroundColor Red
            exit
        }
    } else {
        Write-Host "Error: Sound file not found at $soundFilePath" -ForegroundColor Red
        exit
    }
}

