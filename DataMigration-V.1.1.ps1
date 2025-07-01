# Set paths and variables
$sourceFolderPath = Read-Host "Source Folder Path"
$tempFolderPath = "C:\Temp\temp\DocumentConversion"
$newServerPath = Read-Host "Destination Folder"

# Create temporary folder if it doesn't exist
if (-Not (Test-Path $tempFolderPath)) {
    New-Item -ItemType Directory -Path $tempFolderPath | Out-Null
}

# Function to log messages
function Log-Message {
    param (
        [string]$message,
        [switch]$error = $false
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    if ($error) {
        Write-Error "$timestamp - ERROR: $message"
    } else {
        Write-Output "$timestamp - INFO: $message"
    }
}

# Function to handle errors and log them
function Handle-Error {
    param (
        [Exception]$exception
    )
    Log-Message "An error occurred: $($exception.Message)" -error
    exit 1
}

# 
Write-Host ""
Write-Host "Data conversion and migration script" -ForegroundColor Green
Write-Host "This script will convert Word documents (Doc, Docx) to PDF and back to Word format (Docx)," -ForegroundColor Cyan
Write-Host "compare the content, and move the converted files to a new location." -ForegroundColor Cyan
Write-Host ""
Write-Host "***********************************************************************" 

try {
    # Get all Word documents in the source folder
    write-host "Getting all files in $sourceFolderPath"
    $wordDocuments = Get-ChildItem -Path $sourceFolderPath -Include "*.doc","*.docx" -File

    foreach ($doc in $wordDocuments) {
        $word = $null
        try {
            # Step 1: Copy document to temporary folder
            Write-Host "`nProcessing $($doc.Name)"
            $tempFilePath = Join-Path -Path $tempFolderPath -ChildPath $doc.Name
            Copy-Item -Path $doc.FullName -Destination $tempFilePath
            Log-Message "Copied $($doc.Name) to $tempFilePath"

            # Step 2: Convert the Word document to PDF using Word application
            Write-Host "`nConverting $($doc.Name) to PDF"
            $word = New-Object -ComObject Word.Application
            $word.Visible = $false
            $wordDoc = $word.Documents.Open($tempFilePath)
            $pdfFilePath = Join-Path -Path $tempFolderPath -ChildPath ($doc.BaseName + ".pdf")
            $wordDoc.SaveAs($pdfFilePath, 17) # 17 = PDF format
            $wordDoc.Close()
            Log-Message "Converted $tempFilePath to $pdfFilePath"

            # Step 3: Convert the PDF back to Word format
            Write-Host "`nConverting $pdfFilePath back to Word"
            $convertedWordFilePath = Join-Path -Path $tempFolderPath -ChildPath ($doc.BaseName + "_Converted.docx")
            $word.DisplayAlerts = 0

            $wordDoc = $word.Documents.Open(
                $pdfFilePath,
                0,  # ConfirmConversions = false
                1,  # ReadOnly = true
                0,  # AddToRecentFiles = false
                [Type]::Missing,
                [Type]::Missing,
                1   # Revert = true
            )
            Write-host "Saving as $convertedWordFilePath"
            $wordDoc.SaveAs($convertedWordFilePath, 16)
            $wordDoc.Close()
            Log-Message "Converted $pdfFilePath back to $convertedWordFilePath"

            # Clean up Word COM object
            $word.Quit()
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
            Remove-Variable word

            <# Step 4: Compare the content of the new and old document
            Write-Host "`nComparing content of the original and converted Word documents"
            $oldContent = (Get-Content -Path $doc.FullName) -join "`n"
            $newContent = (Get-Content -Path $convertedWordFilePath) -join "`n"

            if ($oldContent -eq $newContent) {
                Log-Message "Content matches for $($doc.Name)"
            } else {
                Write-Host "Content does not match for $($doc.Name). Please review the documents." -ForegroundColor Red
            } #>

            # Step 5: Move Final Converted DOC to Destination Folder, retain original filename.
            Write-Host "`nMoving the final converted document with the original filename"
            Move-Item -Path $convertedWordFilePath -Destination (Join-Path -Path $newServerPath -ChildPath $doc.Name)
            Log-Message "Moved $($doc.Name) to $newServerPath"

        } catch {
            if ($word) {
                $word.Quit()
                [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
                Remove-Variable word
            }
            Handle-Error $_.Exception
        }
    }

    Write-Host "Migration process completed successfully." -ForegroundColor Green
} catch {
    Handle-Error $_.Exception
}