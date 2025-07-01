#House Music Script
#Plays a repeating bass hit.
$BPM = 250
function Bassline {
        [console]::beep(50,200)
        Write-Output "Boom"
        start-sleep -Milliseconds $BPM
        [console]::beep(2500,100)
        Write-Output  "chk"
        start-sleep -Milliseconds $BPM
        [console]::beep(50,200)
        Write-Output "Boom"
        start-sleep -Milliseconds $BPM
        [console]::beep(50,200)
        Write-Output "Boom"
        start-sleep -Milliseconds $BPM
        [console]::beep(2500,100)
        Write-Output  "chk"
        start-sleep -Milliseconds $BPM
}
$x = 1
While ($x -gt 0) {
    Bassline
}