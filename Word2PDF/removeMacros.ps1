Write-Host "opening word"
$word = New-Object -ComObject Word.Application
$word.Visible = $false

Write-Host "getting files"
$folderPath = read-Host "Enter the 'C:\Path\To\Your\Documents'"
Write-Host "searching for .doc files in $folderPath"
$files = Get-ChildItem -Path $folderPath -Filter *.doc
write-Host "found $($files.Count) files"

Write-Host "removing macros"
foreach ($file in $files) {
    write-Host "Removing macros from $file.FullName"
    $doc = $word.Documents.Open($file.FullName)
    $doc.Application.Run("RemoveAllMacros")
    $doc.SaveAs([ref] $file.FullName, [ref] 0) # Save as .docx
    $doc.Close()
}
write-Host "closing word"
$word.Quit()
