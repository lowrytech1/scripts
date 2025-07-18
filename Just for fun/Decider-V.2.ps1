# DECIDER Script by Brian Lowry - 2025

#Set Environment Values
[console]::windowwidth=100;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
#$host.UI.RawUI.BackgroundColor="black";
#$host.UI.RawUI.ForegroundColor="a";
$host.UI.RawUI.WindowTitle="The DECIDER-V.2";
$ErrorActionPreference = "SilentlyContinue"
$WarningPreference = 'SilentlyContinue'

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

# Initialize the $exit variable to $false
$exit = $false
	
# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {

#Header
Write-Host ""
$BANNER1 = @"
     _____        ______         _____    ____      _____        ______        _____   
 ___|\    \   ___|\     \    ___|\    \  |    | ___|\    \   ___|\     \   ___|\    \  
|    |\    \ |     \     \  /    /\    \ |    ||    |\    \ |     \     \ |    |\    \ 
|    | |    ||     ,_____/||    |  |    ||    ||    | |    ||     ,_____/||    | |    |
|    | |    ||     \--'\_|/|    |  |____||    ||    | |    ||     \--'\_|/|    |/____/ 
|    | |    ||     /___/|  |    |   ____ |    ||    | |    ||     /___/|  |    |\    \ 
|    | |    ||     \____|\ |    |  |    ||    ||    | |    ||     \____|\ |    | |    |
|____|/____/||____ '     /||\ ___\/    /||____||____|/____/||____ '     /||____| |____|
|    /    | ||    /_____/ || |   /____/ ||    ||    /    | ||    /_____/ ||    | |    |
|____|____|/ |____|     | / \|___|    | /|____||____|____|/ |____|     | /|____| |____|
  \(    )/     \( |_____|/    \( |____|/   \(    \(    )/     \( |_____|/   \(     )/  
   '    '       '    )/        '   )/       '     '    '       '    )/       '     '   
                     '             '                                '                  
"@
Write-Host ""
Write-Host ""
Write-CenteredText $BANNER1 -ForegroundColor DarkBlue
#Body
Write-host "           Welcome to the decider where all of your important questions will be answered!"
Write-host "                         1. Close your eyes and ask your question."
Write-host "                         2. Press 1 when ready, the oracle will answer!"
Write-host "                         3. Press 2 to exit."
	  # Prompt the user for a selection
	  $selection = Read-Host
	
	  # Use a switch statement to execute different codes based on the user's selection
	  switch ($selection) {
	    1 {
	    # If the user selects option 1, display a message and do something for option 1
        Write-CenteredText "The oracle is thinking about it....." -ForegroundColor yellow
        Write-host ""
        #Play drumroll
        $sound = New-Object Media.SoundPlayer('.\AP_Scripts\Media\DRUMROLL.WAV')
        $sound.Play();
        Start-sleep -seconds 2
        $sound = New-Object Media.SoundPlayer('.\AP_Scripts\Media\EXPLODE.WAV')
        $sound.Play();
        start-sleep -seconds 3
        #Clear-host

	    # Do something for option 1
        $Answer = ("Fo Sho!", "I guess so", "100%!", "Yes def", "Fully so", "Yup", "Ummm, sure", "Looks that  way", "Of Course- Duuuuuuh!", "The stars are in your favor", "Say what?", "Pssssh- whatever!", "I could tell you, but then I'd have to kill you", "Wish I knew", "Try Harder", "Oh hell no!", "Meh...", "I can't even", "Nah", "Ummm, No", "That's the dumbest question yet!" | Get-Random)
        Write-host ""
        #Write-host ""
        #Write-host ""
        Write-CenteredText "*****************************************"
        Write-host ""
        Write-CenteredText "Answer:"
        Write-CenteredText $Answer -ForegroundColor green
        Write-host ""
        Write-CenteredText "*****************************************"
        # Create a new SpVoice objects
        $voice = New-Object -ComObject Sapi.spvoice
        # Set the speed - positive numbers are faster, negative numbers, slower
        $voice.rate = 0
        # Say something
        $voice.speak($Answer) | out-Null
        Write-host ""
        Write-CenteredText "The Oracle has spoken!" -ForegroundColor white
        Write-host ""
        Write-CenteredText "*****************************************"
        start-sleep -seconds 5
        Clear-Host
	    }

	    2 {
          # If the user selects option 2, set $exit to $true to exit the loop
          $exit = $true
        }
    }
}  