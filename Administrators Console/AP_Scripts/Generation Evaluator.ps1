#Header

# Initialize the $exit variable to $false
$exit = $false
	
# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {

Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "**** Generation Evaluator *****" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

#Body
#Generation Evaluator:
#Clear-Host

Write-Host "This script will determine which Generation you belong to based on your birthdate." -ForegroundColor gray -BackgroundColor Black
Write-Host ""
Write-Host "What generation are you from?" -ForegroundColor Red -BackgroundColor Black
$BirthYear = Read-Host -Prompt "What year were you born?"
If ($Birthyear -le 1964) {
    Write-Host "You are a Baby Boomer!" -ForegroundColor Yellow -BackgroundColor Black
} ElseIf ($BirthYear -ge 1965 -and $BirthYear -le 1980) {
    Write-Host "You are part of the Awesome GENERATION-X!" -ForegroundColor Yellow -BackgroundColor Black
} ElseIf ($BirthYear -ge 1981 -and $BirthYear -le 1996) {
    Write-Host "You are an Amazing Millenial!" -ForegroundColor Yellow -BackgroundColor Black
} ElseIf ($BirthYear -ge 1997 -and $BirthYear -le 2012) {
    Write-Host "You are part of the incredibly talented GenZ!" -ForegroundColor Yellow -BackgroundColor Black
} ElseIf ($BirthYear -ge 2013 -and $BirthYear -le 2025) {
    Write-Host "You are part of the new Generation Alpha" -ForegroundColor Yellow -BackgroundColor Black
}
}
# At end of file:
<#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"#>