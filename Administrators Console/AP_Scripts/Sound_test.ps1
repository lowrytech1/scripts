$sound = New-Object Media.SoundPlayer('D:\media\DRUMROLL.WAV')
#$sound.PlayLooping();
#$wshell = New-Object -ComObject Wscript.Shell
#$Output = $wshell.Popup("ALARM")
#if($Output -eq "1")
start-sleep -seconds 2
{
    $sound.Stop()
}

#--------------------------
$answer = "This is the end!"
(New-Object -ComObject Sapi.spvoice).speak("Hey, $(([adsi]"LDAP://$(whoami /fqdn)").givenName), $answer")
#--------------------------


[System.Media.SystemSounds]::Asterisk.Play()
[System.Media.SystemSounds]::Beep.Play()
[System.Media.SystemSounds]::Exclamation.Play()
[System.Media.SystemSounds]::Hand.Play()
[System.Media.SystemSounds]::Question.Play()

$answer = "This is the end!"
$wshell = New-Object -ComObject Wscript.Shell
$Output = $wshell.Popup($answer)


