Clear-Host
Set-Location "C:\"
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

[console]::windowwidth=78;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.WindowTitle="Duplicate File Finder ";

Write-Host "                                                                           "
Write-Host "   ************************************************************************"
Write-Host "   *                                                                      *"
Write-Host "   *                         Duplicate File Finder                        *"
Write-Host "   *                                                                      *"
Write-Host "   ************************************************************************"
Write-Host ""


$Var = Read-Host -Prompt "Which folder do you want to check?"
$var2 = Read-Host -Prompt "Where should the duplicates be placed?"
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

