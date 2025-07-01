@{
    Root = 'C:\Users\lowryb\OneDrive\Documents\Scripts\GUI\Working\Employee Lookup Tool\EmployeeLookupTool1.4.ps1'
    OutputPath = 'C:\Users\lowryb\OneDrive\Documents\Scripts\GUI\Working\Employee Lookup Tool'
    Package = @{
        ApplicationIconPath = 'C:\Users\lowryb\OneDrive\Documents\Scripts\GUI\_Images\ADUC.ico'
        Copyright = 'B.Lowry'
        DotNetVersion = 'v4.6.2'
        Enabled = $true
        FileDescription = 'Find user information and open ADUC for any KC domain.'
        FileVersion = '1.4'
        HideConsoleWindow = $true
        Host = 'Default'
        PowerShellVersion = 'Windows PowerShell'
        ProductName = 'Employee Lookup Tool'
        ProductVersion = '1.4'
        RuntimeIdentifier = 'win-x64'
    }
    Bundle = @{
        Enabled = $true
        Modules = $true
    }
}
