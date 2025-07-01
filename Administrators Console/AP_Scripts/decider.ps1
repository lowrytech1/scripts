Clear-Host

# Initialize the $exit variable to $false
$exit = $false
	
# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {

#Header
Write-Host ""
Write-Host "                               *******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                               *******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                               ********* The Decider! ********" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                               *******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                               *******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

#Body
Write-host "Welcome to the decider where all of your important questions will be answered!"
Write-host "1. Close your eyes and ask your question."
Write-host "2. Press 1 when ready, the oracle will answer!"
Write-host "3. Press 2 to exit."
	  # Prompt the user for a selection
	  $selection = Read-Host
	
	  # Use a switch statement to execute different codes based on the user's selection
	  switch ($selection) {
	    1 {
	      # If the user selects option 1, display a message and do something for option 1
	        Write-host "The oracle is thinking about it....." -ForegroundColor yellow
          Write-host ""
          Write-host "*****************************************"
          Write-host ""
          #Play drumroll
          $sound = New-Object Media.SoundPlayer('.\AP_Scripts\Media\DRUMROLL.WAV')
          $sound.Play();
          Start-sleep -seconds 2
          $sound = New-Object Media.SoundPlayer('.\AP_Scripts\Media\EXPLODE.WAV')
          $sound.Play();
          start-sleep -seconds 3
          Clear-host

	      # Do something for option 1
          $Answer = ("Fo Sho!", "I guess so", "100%!", "Yes def", "Fully so", "Yup", "Ummm, sure", "Looks that  way", "Of Course- Duh!", "The stars are in your favor", "Say what?", "Pssssh- whatever!", "I could tell you, but then I'd have to kill you", "Wish I knew", "Try Harder", "Oh hell no!", "No Way", "I can't even", "Nah", "Ummm, No" | Get-Random)
          Write-host ""
          Write-host ""
          Write-host ""
          Write-host "*****************************************"
          Write-host "Answer:"
          Write-Host $Answer -ForegroundColor green
          # Create a new SpVoice objects
          $voice = New-Object -ComObject Sapi.spvoice
          # Set the speed - positive numbers are faster, negative numbers, slower
          $voice.rate = 0
          # Say something
          $voice.speak($Answer) | out-Null
          Write-host ""
          Write-host "*****************************************"
          Write-host ""
          Write-Host "The Oracle has spoken!" -ForegroundColor white
          Write-host ""
          Write-host "*****************************************"
          start-sleep -seconds 5
          Clear-Host
          
	    }
	    2 {
          # If the user selects option 2, set $exit to $true to exit the loop
          $exit = $true
        }
    }
}  