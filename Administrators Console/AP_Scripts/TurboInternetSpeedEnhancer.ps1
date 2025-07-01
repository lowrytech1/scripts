Write-Host ""
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue -NoNewline
Write-Host "  V2.1" -ForegroundColor red
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "**     Internet Speed Booster     **" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""
Write-Host " This script is designed to enhance your internet settings." -ForegroundColor Green
Write-Host " After pressing Enter, your internet speeds will double."
Write-Host ""
Write-Host ""
$enter = Read-Host "Press Enter to continue..."
If ($enter) {
    $sound = New-Object Media.SoundPlayer('.\Media\dial-up-modem-01.wav"')
    $sound.Play();
    Write-Host "Enhancing your internet speed..." -ForegroundColor Green
    Write-Host ""
    start-sleep -Seconds 26
    Write-Host "Your internet speed has been enhanced." -ForegroundColor Green
    Write-Host ""
    Write-Host "Thank you for using the Internet Speed Booster." -ForegroundColor Green
    Write-Host ""
    Write-Host "Press Enter to exit..." -ForegroundColor Green
    $exit = Read-Host ""
    If ($exit -ne $null) {
        Exit
    }
}

