#House Music Script
function Test-EscKey
{
	# key code for esc key:
	$key = 27    
    
	# this is the c# definition of a static Windows API method:
	$Signature = @'
    [DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
    public static extern short GetAsyncKeyState(int virtualKeyCode); 
'@

	Add-Type -MemberDefinition $Signature -Name Keyboard -Namespace PsOneApi
	[bool]([PsOneApi.Keyboard]::GetAsyncKeyState($key) -eq -32767)
}

Write-Warning 'Close this window to stop music'
(New-Object -ComObject Sapi.spvoice).speak("Hey, $(([adsi]"LDAP://$(whoami /fqdn)").givenName), Get Funky!")

do
{
	$sound = New-Object Media.SoundPlayer("$PSScriptRoot\..\Media\funky-house.wav")
	$sound.Play();
	$pressed = Test-EscKey
	if ($pressed){
		break 
	}
	Start-Sleep -Seconds 60
} while ($true)

<#-===============================================================
(New-Object -ComObject Sapi.spvoice).speak("Hey, $(([adsi]"LDAP://$(whoami /fqdn)").givenName), Get Funky!")
#start-sleep -seconds 3
$sound = New-Object Media.SoundPlayer('.\AP_Scripts\media\funky-house.wav')
$sound.PlayLooping(); 
<# if($Output -eq "1")
{
    $sound.Stop()
} #>