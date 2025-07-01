# Prompt for the target directory
$targetDirectory = Read-Host -Prompt "Enter the full path of the target directory"

# Define the size threshold (2GB in bytes)
$sizeThreshold = 2GB

# Get all subdirectories under the target directory
$subDirectories = Get-ChildItem -Path $targetDirectory -Directory

# Calculate the folder sizes and filter the ones over 2GB
$largeSubDirs = $subDirectories | ForEach-Object {
    $subDir = $_
    $size = (Get-ChildItem -Recurse -Path $subDir.FullName -File | Measure-Object -Property Length -Sum).Sum
    if ($size -gt $sizeThreshold) {
        [PSCustomObject]@{
            Path = $subDir.FullName
            SizeGB = [math]::Round($size / 1GB, 2)
        }
    }
} | Where-Object { $_ -ne $null }

# Output the list of subdirectories over 2GB
$largeSubDirs | Format-Table -Property Path, SizeGB -AutoSize