# House Music Script by Brian Lowry - 2025

Set-Location $PSScriptRoot

# Add helper function for centering text
function Write-CenteredText {
    param([string]$Text, [System.ConsoleColor]$ForegroundColor = [System.ConsoleColor]::White)
    
    # Split the text into lines
    $lines = $Text -split "`n"
    $maxLength = ($lines | Measure-Object -Property Length -Maximum).Maximum
    $windowWidth = $Host.UI.RawUI.WindowSize.Width
    
    foreach ($line in $lines) {
        # Calculate padding based on the maxLength for consistent alignment
        $padding = [Math]::Max(0, [Math]::Floor(($windowWidth - $maxLength) / 2))
        Write-Host (" " * $padding) -NoNewline
        Write-Host $line -ForegroundColor $ForegroundColor
    }
}

<# function Test-EscKey{
	# key code for esc key:
	$key = 27    
    
	# this is the c# definition of a static Windows API method:
	$Signature = @'
    [DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
    public static extern short GetAsyncKeyState(int virtualKeyCode); 
'@

	Add-Type -MemberDefinition $Signature -Name Keyboard -Namespace PsOneApi
	[bool]([PsOneApi.Keyboard]::GetAsyncKeyState($key) -eq -32767)
} #>

# Get StartTime
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

# Set Environment Variables
[console]::windowwidth=66;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.WindowTitle="A Better Funky House Script V2";

$PSModuleAutoLoadingPreference = "All"
$WarningPreference = "SilentlyContinue"
$ErrorActionPreference = "SilentlyContinue"

Clear-Host

# Header
$BANNER1 = @"
██   ██  ██████  ██    ██ ███████ ███████ 
██   ██ ██    ██ ██    ██ ██      ██      
███████ ██    ██ ██    ██ ███████ █████   
██   ██ ██    ██ ██    ██      ██ ██      
██   ██  ██████   ██████  ███████ ███████ 
"@

$BANNER2 = @"
 ██████   ██████                     ███          
░░██████ ██████                     ░░░           
 ░███░█████░███  █████ ████  █████  ████   ██████ 
 ░███░░███ ░███ ░░███ ░███  ███░░  ░░███  ███░░███
 ░███ ░░░  ░███  ░███ ░███ ░░█████  ░███ ░███ ░░░ 
 ░███      ░███  ░███ ░███  ░░░░███ ░███ ░███  ███
 █████     █████ ░░████████ ██████  █████░░██████ 
░░░░░     ░░░░░   ░░░░░░░░ ░░░░░░  ░░░░░  ░░░░░░  
"@

# Display centered banners
Clear-Host
Write-Host ""
Write-Host ""
Write-Host ""
Write-CenteredText $BANNER1 -ForegroundColor Cyan
Write-CenteredText $BANNER2 -ForegroundColor Cyan
Write-Host ""
Write-Host ""
Write-CenteredText "This script demonstrates the sound capabilities of PS Scripts." -ForegroundColor Yellow
Write-CenteredText "Press [Enter] to stop the music." -ForegroundColor Yellow
Write-Host ""
Write-Host ("*" * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor Red
Write-Host ""


$sound = New-Object Media.SoundPlayer("$PSScriptRoot\..\Media\funky-house.wav")
$sound.Play();
Read-Host "Press [Enter] to stop the music."
$sound.Stop()

<#-===============================================================
(New-Object -ComObject Sapi.spvoice).speak("Hey, $(([adsi]"LDAP://$(whoami /fqdn)").givenName), Get Funky!")
#start-sleep -seconds 3
$sound = New-Object Media.SoundPlayer('.\AP_Scripts\media\funky-house.wav')
$sound.PlayLooping(); 
<# if($Output -eq "1")
{
    $sound.Stop()
} #>