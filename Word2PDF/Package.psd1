@{
    Root = 'C:\Users\lowryb\OneDrive\Documents\Scripts\GUI\Working\Word2PDF\Word2PDF-V.1.2.ps1'
    OutputPath = 'C:\Users\lowryb\OneDrive\Documents\Scripts\GUI\Working\Word2PDF'
    Package = @{
        ApplicationIconPath = 'C:\Users\lowryb\OneDrive\Documents\Scripts\GUI\_Images\WinWordicon.ico'
        Copyright = 'B.Lowry'
        DotNetVersion = 'v4.6.2'
        Enabled = $true
        FileDescription = 'Convert word to pdf to word docx.'
        FileVersion = '1.2'
        HideConsoleWindow = $true
        Host = 'Default'
        Obfuscate = $true
        PowerShellVersion = 'Windows PowerShell'
        ProductName = 'Word2pdf'
        ProductVersion = '1.2'
        RuntimeIdentifier = 'win-x64'
    }
    Bundle = @{
        Enabled = $true
        Modules = $true
    }
}
