# MacroStripper script by Brian Lowry, 2025
# This script will remove macros from Word documents (Doc, Docx) and save in Word format (Docx)

# Initialize the $exit variable to $false
$exit = $false

# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {
    # Banner
    Clear-Host
    Write-Host ""
    Write-Host "***********************************************************************************************"
    Write-Host ""
    Write-Host "                                     MacroStripper script" -ForegroundColor Green
    Write-Host ""
    Write-Host " This script will remove macros from Word documents (Doc, Docx) and save in Word format (Docx)" -ForegroundColor Cyan
    Write-Host " and then move the converted files to a new location. Source documents remain unchanged." -ForegroundColor Cyan
    Write-Host "***********************************************************************************************"

    $sourceFolder = Read-Host "Enter the source folder path"
    $destinationFolder = Read-Host "Enter the destination folder path"
    
    # Validate and clean up paths
    $sourceFolder = $sourceFolder.Trim('"').Trim("'")
    $destinationFolder = $destinationFolder.Trim('"').Trim("'")
    
    # Verify paths exist
    if (-not (Test-Path -Path $sourceFolder)) {
        Write-Host "Error: Source folder does not exist: $sourceFolder" -ForegroundColor Red
        continue
    }
    
    if (-not (Test-Path -Path $destinationFolder)) {
        Write-Host "Creating destination folder: $destinationFolder"
        New-Item -ItemType Directory -Path $destinationFolder -Force | Out-Null
    }
    
    $recursive = Read-Host "Search subfolders? (Combines all files into one Destination folder) (Y/N)"
    $isRecursive = $recursive.ToUpper() -eq 'Y'

    $startTime = Get-Date
    $formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")

    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $word.DisplayAlerts = 0

    # Get all files in source dir(s):
    try {
        if ($isRecursive) {
            Write-Host "`nSearching for Word documents in $sourceFolder and its subfolders..."
            $wordDocuments = Get-ChildItem -LiteralPath $sourceFolder -Include "*.doc","*.docx" -Recurse | Where-Object { !$_.PSIsContainer }
        } else {
            Write-Host "`nSearching for Word documents in $sourceFolder..."
            $wordDocuments = Get-ChildItem -LiteralPath $sourceFolder | Where-Object { !$_.PSIsContainer -and $_.Extension -match '\.docx?' }
        }
    }
    catch {
        Write-Host "Error accessing folder: $_" -ForegroundColor Red
        continue
    }

    ForEach ($file in $wordDocuments) {
        try {
            Write-Host "`nProcessing $($file.Name)"
            
            # Check if destination file already exists
            $macroFreePath = Join-Path $destinationFolder ($file.BaseName + ".docx")
            if (Test-Path $macroFreePath) {
                Write-Host "Warning: File already exists at destination: $macroFreePath" -ForegroundColor Yellow
                $overwrite = Read-Host "Do you want to overwrite? (Y/N)"
                if ($overwrite.ToUpper() -ne 'Y') {
                    Write-Host "Skipping file..." -ForegroundColor Yellow
                    continue
                }
            }

            # Open document with more detailed error handling
            Write-Host "Opening document..." -ForegroundColor Gray
            $doc = $word.Documents.Open($file.FullName)
            if (-not $doc) {
                throw "Failed to open document"
            }

            # Save document with correct parameter handling
            Write-Host "Saving document without macros..." -ForegroundColor Gray
            # WdSaveFormat: wdFormatXMLDocument = 12 (*.docx)
            $saveFormat = 12
            $doc.SaveAs([string]$macroFreePath, [int]$saveFormat)
            
            # Close document
            Write-Host "Closing document..." -ForegroundColor Gray
            $doc.Close($false)
            
            Write-Host "Successfully saved $($file.Name) as $macroFreePath" -ForegroundColor Green
        }
        catch {
            Write-Host "Error processing $($file.Name):" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
            Write-Host "Stack Trace:" -ForegroundColor Red
            Write-Host $_.Exception.StackTrace -ForegroundColor Red
        }
    }

    # Properly close Word
    try {
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
    }
    catch {
        Write-Host "Error cleaning up Word process: $_" -ForegroundColor Red
    }

    Write-Host "`nMigration process completed successfully." -ForegroundColor Green

    #Script Execution Stats
    $endTime = Get-Date
    # Calculate time difference between start and end time
    $Duration = New-TimeSpan -Start $StartTime -End $EndTime
    #Format the duration time as dd:HH:mm:ss
    $formattedDuration = "{0:D2}:{1:D2}:{2:D2}:{3:D2}" -f $Duration.Days, $Duration.Hours, $Duration.Minutes, $Duration.Seconds
    Write-Host "Conversion Duration time (dd:HH:mm:ss):" -NoNewline
    Write-Host "  $formattedDuration" -foregroundcolor "yellow"

    Write-Host "Would you like to try again? (Y/N)"
    $response = Read-Host
    $TryAgain = $response.ToUpper() -eq 'Y'
    if ($TryAgain -ne "Y") {
        $exit = $true
    } Else {
        Clear-Host
    }
}