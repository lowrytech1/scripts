Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

#Header

Write-Host ""
Write-Host "********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*** Get Largest Subdirectory ***" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

#Body

<#  Description
This script will:
1. Prompt for a target directory on that host.
2. Retrieve all subdirectories under the target directory.
3. Calculate the folder sizes for each subdirectory.
4. Output a csv file with the top ten largest subdirectories in descending order by size.
#>

# Ask for the target directory
$targetDirectory = Read-Host -Prompt "Enter the full path of the target directory"

# Get the path to the current user's desktop
$desktopPath = 

# Define the path for the CSV output file on the user's desktop
$outputCsvPath = Join-Path $desktopPath "TopTenLargestSubdirectories.csv"

# Get all subdirectories under the target directory
$subDirectories = Get-ChildItem -Path $targetDirectory -Directory

# Calculate the folder sizes
$folderSizes = $subDirectories | ForEach-Object {
    $subDir = $_
    $size = (Get-ChildItem -Recurse -Path $subDir.FullName -File | Measure-Object -Property Length -Sum).Sum
    [PSCustomObject]@{
        Path = $subDir.FullName
        Size = $size
    }
}

# Sort the folders by size in descending order and select the top ten
$topTenLargest = $folderSizes | Sort-Object -Property Size -Descending | Select-Object -First 10

# Export the top ten largest subdirectories to a CSV file
$topTenLargest | Export-Csv -Path $outputCsvPath -NoTypeInformation

# Output a message to the user
Write-Host "The top ten largest subdirectories have been exported to the CSV file at $outputCsvPath"

# At end of file:
#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"