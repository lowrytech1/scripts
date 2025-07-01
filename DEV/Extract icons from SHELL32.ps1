# Add required assemblies
Add-Type -AssemblyName System.Drawing

# Extract icons from SHELL32.dll and save them as .ico files

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class IconExtractor
{
    [DllImport("shell32.dll", CharSet=CharSet.Auto)]
    public static extern IntPtr ExtractIcon(IntPtr hInst, string lpszExeFileName, int nIconIndex);

    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool DestroyIcon(IntPtr hIcon);
}
"@

# Set paths
$shell32Path = "$env:SystemRoot\System32\SHELL32.dll"
$outputBaseFolder = "C:\IconExtract"
$subFolders = @("Small", "Medium", "Large")

# Create output folders
$subFolders | ForEach-Object {
    $folder = Join-Path $outputBaseFolder $_
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force
    }
}

# Extract icons (SHELL32.dll contains approximately 300 icons)
0..299 | ForEach-Object {
    $iconIndex = $_
    $iconHandle = [IconExtractor]::ExtractIcon([IntPtr]::Zero, $shell32Path, $iconIndex)
    
    if ($iconHandle -ne [IntPtr]::Zero) {
        $icon = [System.Drawing.Icon]::FromHandle($iconHandle)
        
        # Save in different sizes
        foreach ($folder in $subFolders) {
            # Fix: Use proper Join-Path syntax with -Path and -ChildPath parameters
            $folderPath = Join-Path -Path $outputBaseFolder -ChildPath $folder
            $outputPath = Join-Path -Path $folderPath -ChildPath "icon_$($iconIndex).ico"
            try {
                $fs = [System.IO.File]::Create($outputPath)
                $icon.Save($fs)
                $fs.Close()
            }
            catch {
                Write-Warning "Failed to save icon $iconIndex to $outputPath"
            }
        }
        
        # Clean up
        [IconExtractor]::DestroyIcon($iconHandle)
        $icon.Dispose()
    }
}

Write-Host "Icon extraction complete. Check the folders in $outputBaseFolder"