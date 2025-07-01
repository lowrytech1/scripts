Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -forgroundcolor Yellow
Write-Host " "
Write-Host " "
Write-Host "******************************" -ForegroundColor Yellow
Write-Host "******************************" -ForegroundColor Yellow
Write-Host "*                            *" -ForegroundColor Yellow
Write-Host "*  Welcome to File Renamer!  *" -ForegroundColor Red
Write-Host "*                            *" -ForegroundColor Yellow
Write-Host "******************************" -ForegroundColor Yellow
Write-Host "******************************" -ForegroundColor Yellow
Write-Host " "
Write-Host "This script will rename all files in a folder by creation date, "
Write-Host "appending custom text and an index number to the existing filename."
Write-Host " "

#Functions
function rename-file {
    Rename-Item *.* ($Newname + $Oldname)\.*
}

$Int = 0001
$Newname = ($Int++).sum   #<Incremented integer - associated with place in sorted file list>


$Oldname =  Get-ItemPropertyValue -Name Name
    return filename

$Dir = read-Host "Enter path to desired folder"
$Files = Get-childitem -Path $Dir | Sort-Object -Property LastWriteTime | Write-Host

$Title = "Confirmation"
$Info = "Is this the correct Directory?"
$options = echo Yes No
$defaultchoice = 1
$selected = $host.UI.PromptForChoice($Title , $Info , $Options, $defaultchoice)
$options[$selected]

If ( $selected = No ){
    Quit
}
Else {
    Foreach ($i in $Files){
        rename-file
    }
}
#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"