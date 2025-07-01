Clear-Host
Set-Location "C:\"
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

[console]::windowwidth=120;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.WindowTitle="Duplicate File Finder V2";

$BANNER1 = @"
|.  _____               _ _                         _______ _ _          _______ _           _              .|
|. (____ \             | (_)           _           (_______|_) |        (_______|_)         | |             .|
|.  _   \ \ _   _ ____ | |_  ____ ____| |_  ____    _____   _| | ____    _____   _ ____   _ | | ____  ____  .|
|. | |   | | | | |  _ \| | |/ ___) _  |  _)/ _  )  |  ___) | | |/ _  )  |  ___) | |  _ \ / || |/ _  )/ ___) .|
|. | |__/ /| |_| | | | | | ( (__( ( | | |_( (/ /   | |     | | ( (/ /   | |     | | | | ( (_| ( (/ /| |     .|
|. |_____/  \____| ||_/|_|_|\____)_||_|\___)____)  |_|     |_|_|\____)  |_|     |_|_| |_|\____|\____)_|     .|
|.               |_|                                                                                        .|
"@#

# Display centered banners
Clear-Host
Write-Host ""
Write-Host ""
Write-Host ""
$banner1Lines = $BANNER1.TrimEnd() -split "`n"
$maxWidth = ($banner1Lines | Measure-Object -Property Length -Maximum).Maximum
$hostWidth = $Host.UI.RawUI.WindowSize.Width
foreach ($line in $banner1Lines) {
    $line = $line.TrimEnd()
    $paddingLength = [Math]::Max(0, [math]::Floor(($hostWidth - $line.Length) / 2))
    $padding = if ($paddingLength -gt 0) { " " * $paddingLength } else { "" }
    Write-Host ($padding + $line) -ForegroundColor Cyan
}
Write-Host ""
Write-Host ""
Write-Host ("*" * $hostWidth) -ForegroundColor Red
Write-Host ""

$Var = Read-Host -Prompt "Which folder do you want to check?"
$var2 = Read-Host -Prompt "Where should the duplicates be placed?"
Write-Host "Searching for duplicate files. Please be patient..." -ForegroundColor Yellow
if(!(Test-Path -PathType Container $var2)){ New-Item -ItemType Directory -Path $var2 | Out-Null }
Get-ChildItem -Path $var -File -Recurse |
    Group-Object -Property Length |
    Where-Object { $_.count -gt 1 } |
    Select-Object -ExpandProperty Group |
    Get-FileHash -Algorithm MD5 |
    Group-Object -Property Hash |
    Where-Object { $_.count -gt 1 } |
    ForEach-Object { $_.Group | Select-Object Path, Hash, Length } |
    Out-GridView -Title "Select the duplicate file(s) to move." -PassThru |
    Move-Item -Destination $var2 -Force -Verbose

#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"

