<#
This script will search for keywords in the registry and report back the results.
ToDo:     
    Add menu: Backup, search, restore
    Add option to delete keys from txt file
        Force registry backup before deleting keys in text file
    Add registry restore option
    Increase efficiency
    
    --Add progress bar
    --Add "Open results file?" option after search completes    
    --$Subkeys and $Path are the issues, chicken or egg?
#>

# Get current date/time
$startTime = Get-Date

# Define the output file path
If (!(test-path "C:\temp\")) {
    New-Item -Path "C:\" -Name "temp" -ItemType "directory"
}
If (!(test-path "C:\temp\RegistrySearchResults.txt")) {
    New-Item -Path "C:\temp" -Name "RegistrySearchResults-$TimeStamp.txt" -ItemType "file"
}
$outputFilePath = "C:\temp\RegistrySearchResults-$TimeStamp.txt"

Clear-Host

# Header
Write-Host ""
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue -NoNewline
Write-Host "  V0.3.4" -ForegroundColor red
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "******* Registry Search Tool *******" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

# Prompt the user for a keyword to search for
$keyword = Read-Host "Enter the keyword to search for in the registry"
# Start search timer:
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
$TimeStamp = $startTime.ToString("MM-dd-yy HH:mm")
Write-Host "$formattedStartTime"

# Inform the user
Write-Host "This can take some time, grab a coffee and relax." -ForegroundColor Yellow
Write-Host "I'll log all my findings to:" -ForegroundColor Yellow -noNewline
Write-Host " C:\temp\RegistrySearchResults- $TimeStamp .txt"  -ForegroundColor Blue
Write-Host "*****************************************************************" -ForegroundColor yellow -BackgroundColor Blue

# Define the registry paths to search
$registryPaths = @(
    "HKLM:\Software",
    "HKCU:\Software"
)
write-host "Registry paths: $registryPaths"
Write-Host ""

# Initialize an array to store the results
$results = @()
write-Host "Array initialized"
Write-Host ""

# Get all subkeys and count 'em.
Write-Host "Getting Registry Keys. This might Take a while..."
$subkeys = Get-ChildItem -Path $registryPaths -Recurse -ErrorAction SilentlyContinue
$TotalKeys = $($subkeys.Count)
Write-Host ""
Write-Host "Total number of keys to process: " -NoNewline  -ForegroundColor Yellow
Write-Host "$totalKeys" -ForegroundColor Blue

# Start the progress bar
Write-Progress -Activity "Searching Registry for $keyword" -Status "Initializing" -PercentComplete 0
Write-Host ""

# Search each registry path for the keyword and update the progress bar
Write-Host "Searching Reg Keys..." -ForegroundColor Green
for ($i = 0; $i -lt $totalKeys; $i++) {
    $subkey = $subkeys[$i]
    Write-Progress -Activity "Searching Registry for $keyword" -Status "Processing $($subkey.PSPath)" -PercentComplete (($i / $totalKeys) * 100)
    try {
        # Get all properties of the subkey
        $properties = Get-ItemProperty -Path $subkey.PSPath -ErrorAction SilentlyContinue
        foreach ($property in $properties <#.PSObject.Properties#>) {
            if ($property.Value -like "*$keyword*") {
                $results.Value += "Path: $($subkey.PSPath), Property: $($property.Name), Value: $($property.Value)"
                Write-Host "Path: $($subkey.PSPath), Property: $($property.Name), Value: $($property.Value)"
                Write-Host ""
            }
        }
    } catch {
        Write-Host "Error accessing $subkey : $_" -ForegroundColor Red
    }
}

# Measure Script Execution time
$endTime = Get-Date
# Calculate time difference between start and end time
$Duration = New-TimeSpan -Start $StartTime -End $EndTime
# Format the duration time as dd:HH:mm:ss
$formattedDuration = "{0:D2}:{1:D2}:{2:D2}:{3:D2}" -f $Duration.Days, $Duration.Hours, $Duration.Minutes, $Duration.Seconds
Write-Host "Script Duration time (dd:HH:mm:ss):" -NoNewline
Write-Host "  $formattedDuration" -foregroundcolor "yellow"
Write-Host ""

# Write the results to the text file
$results | Out-File -FilePath $outputFilePath -Encoding utf8
Write-Host "Results written to $outputFilePath"
Write-Host ""

# Inform the user that the search is complete
Write-Host "Registry search complete. Results saved to $outputFilePath"
Write-Host "Open results file? [Y][N]"
$response = Read-Host
if ($response -eq "Y") {
    Invoke-Expression $outputFilePath
} 
Write-Host ""
read-host "press [Enter] key to continue"