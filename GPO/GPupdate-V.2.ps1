Clear-Host
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

#Set Environment Values
[console]::windowwidth=57;
[console]::windowheight=23;
[console]::bufferwidth=[console]::windowwidth;
#$host.UI.RawUI.BackgroundColor="black";
#$host.UI.RawUI.ForegroundColor="Gray";
$host.UI.RawUI.WindowTitle="GPupdate V.2";

# Header
$text = "{ GPupdate }"
$boxWidth = $text.Length + 10
$hostWidth = $Host.UI.RawUI.WindowSize.Width
$padding = " " * [math]::Max(0, [math]::Floor(($hostWidth - $boxWidth) / 2))
#Clear-Host
Write-Host ("-" * $hostWidth) -ForegroundColor Cyan
Write-Output ""
Write-Host ($padding + ("*" * $boxWidth)) -ForegroundColor Red
Write-Host ($padding + ("*" * $boxWidth)) -ForegroundColor Red
Write-Host ($padding + "**** $text ****") -ForegroundColor Red
Write-Host ($padding + ("*" * $boxWidth)) -ForegroundColor Red
Write-Host ($padding + ("*" * $boxWidth)) -ForegroundColor Red
Write-Output ""
Write-Host ("-" * $hostWidth) -ForegroundColor Cyan
Write-Host ""

# Body
Read-Host "Press Enter to run GPupdate.exe /force on all computers"
Write-Host "Running GPupdate.exe /force on all computers" -ForegroundColor Green
Invoke-Command { GPupdate.exe /force }

#Script Execution Stats
$endTime = Get-Date
# Calculate time difference between start and end time
$Duration = New-TimeSpan -Start $StartTime -End $EndTime
#Format the duration time as dd:HH:mm:ss
$formattedDuration = "{0:D2}:{1:D2}:{2:D2}:{3:D2}" -f $Duration.Days, $Duration.Hours, $Duration.Minutes, $Duration.Seconds
Write-Host "Script Duration time (dd:HH:mm:ss):" -NoNewline
Write-Host "  $formattedDuration" -foregroundcolor "yellow"