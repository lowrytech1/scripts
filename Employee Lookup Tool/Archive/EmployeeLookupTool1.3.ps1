#Employee lookup tool script by B.Lowry

# Import required modules
Import-Module ActiveDirectory

# Load necessary assemblies for WPF
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Domain list for dropdown
$domains = @(
    "Kern County        KernCounty.com",
    "DA                 KCDA.local",
    "Crime Lab          LAB.da.co.kern.ca.us",
    "Recorder           RCRD.internal",
    "County Council     CCDomain.cc.co.kern.ca.us",
    "Public Health      PHDom.local",
    "Assessor           Assessor.Internal",
    "BHRS               KernBHRS.local",
    "Elections          Elections.accc.co.kern.ca.us",
    "DHS                kernDHS.com",
    "Auditor            ACCC.co.kern.ca.us",
    "PSB/RMANT          RMANT.rma.co.kern.ca.us"
)

# Create the XAML for our WPF interface
[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Multi-Domain AD User Lookup" 
    Height="450" Width="500" 
    WindowStartupLocation="CenterScreen">
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        
        <!-- Domain Selection -->
        <TextBlock Grid.Row="0" Text="Select Domain:" Margin="0,0,0,5"/>
        <ComboBox x:Name="comboDomain" Grid.Row="1" Margin="0,0,0,10"/>
        
        <!-- Admin Username -->
        <Grid Grid.Row="2">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <TextBlock Grid.Column="0" Text="Admin Username:" Margin="0,0,5,5" VerticalAlignment="Center"/>
            <TextBox x:Name="txtAdminUsername" Grid.Column="1" Padding="5" Margin="0,0,0,5"/>
        </Grid>
        
        <!-- UPN Input -->
        <TextBlock Grid.Row="3" Text="Enter User Principal Name (email) to search:" Margin="0,10,0,5"/>
        
        <Grid Grid.Row="4">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            <TextBox x:Name="txtUPN" Grid.Column="0" Padding="5" Margin="0,0,5,0"/>
            <Button x:Name="btnSearch" Grid.Column="1" Content="Search" Padding="15,5"/>
        </Grid>
        
        <!-- Results -->
        <GroupBox Grid.Row="5" Header="User Information" Margin="0,10">
            <Grid Margin="10">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>
                
                <TextBlock Grid.Row="0" Grid.Column="0" Text="Full Name:" Margin="0,0,10,5" FontWeight="Bold"/>
                <TextBlock Grid.Row="0" Grid.Column="1" x:Name="txtFullName" Text="" Margin="0,0,0,5"/>
                
                <TextBlock Grid.Row="1" Grid.Column="0" Text="Phone Number:" Margin="0,0,10,5" FontWeight="Bold"/>
                <TextBlock Grid.Row="1" Grid.Column="1" x:Name="txtPhone" Text="" Margin="0,0,0,5"/>
                
                <TextBlock Grid.Row="2" Grid.Column="0" Text="Department:" Margin="0,0,10,5" FontWeight="Bold"/>
                <TextBlock Grid.Row="2" Grid.Column="1" x:Name="txtDepartment" Text="" Margin="0,0,0,5"/>
                
                <TextBlock Grid.Row="3" Grid.Column="0" Text="Title:" Margin="0,0,10,5" FontWeight="Bold"/>
                <TextBlock Grid.Row="3" Grid.Column="1" x:Name="txtTitle" Text="" Margin="0,0,0,5"/>
                
                <TextBlock Grid.Row="4" Grid.Column="0" Text="Employee ID:" Margin="0,0,10,5" FontWeight="Bold"/>
                <TextBlock Grid.Row="4" Grid.Column="1" x:Name="txtEmployeeID" Text="" Margin="0,0,0,5"/>
                
                <TextBlock Grid.Row="5" Grid.Column="0" Text="Canonical Name:" Margin="0,0,10,5" FontWeight="Bold"/>
                <TextBlock Grid.Row="5" Grid.Column="1" x:Name="txtCanonicalName" Text="" Margin="0,0,0,5" TextWrapping="Wrap"/>
                
                <Button x:Name="btnOpenADUC" Grid.Row="6" Grid.ColumnSpan="2" Content="Open in ADUC" Padding="10,5" 
                        HorizontalAlignment="Right" Margin="0,10,0,0" IsEnabled="False"/>
            </Grid>
        </GroupBox>
    </Grid>
</Window>
'@

# Create a form and read the XAML
$reader = New-Object System.Xml.XmlNodeReader $XAML
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Store form objects in PowerShell variables
$comboDomain = $Window.FindName("comboDomain")
$txtAdminUsername = $Window.FindName("txtAdminUsername")
$txtUPN = $Window.FindName("txtUPN")
$btnSearch = $Window.FindName("btnSearch")
$txtFullName = $Window.FindName("txtFullName")
$txtPhone = $Window.FindName("txtPhone")
$txtDepartment = $Window.FindName("txtDepartment")
$txtTitle = $Window.FindName("txtTitle")
$txtEmployeeID = $Window.FindName("txtEmployeeID")
$txtCanonicalName = $Window.FindName("txtCanonicalName")
$btnOpenADUC = $Window.FindName("btnOpenADUC")

# Add domains to the combobox
foreach ($domain in $domains) {
    [void]$comboDomain.Items.Add($domain)
}

# Select first domain by default
if ($comboDomain.Items.Count -gt 0) {
    $comboDomain.SelectedIndex = 0
}

# Store user data for ADUC navigation later
$global:CurrentUser = $null
$global:CurrentDomain = $null
$global:CurrentCredential = $null

# Function to map selected domain to actual domain name
function Get-DomainName {
    param($selectedItem)
    
    switch -Wildcard ($selectedItem) {
        "*Kern County*"     { "kerncounty.com" }
        "*DA*"              { "KCDA.local" }
        "*Crime Lab*"       { "LAB.da.co.kern.ca.us" }
        "*Recorder*"        { "RCRD.internal" }
        "*County Council*"  { "CCDomain.cc.co.kern.ca.us" }
        "*Public Health*"   { "PHDom.local" }
        "*Assessor*"        { "Assessor.Internal" }
        "*BHRS*"            { "KernBHRS.local" }
        "*Elections*"       { "Elections.accc.co.kern.ca.us" }
        "*DHS*"             { "kernDHS.com" }
        "*Auditor*"         { "ACCC.co.kern.ca.us" }
        "*PSB/RMANT*"       { "RMANT.rma.co.kern.ca.us" }
        default             { $null }
    }
}

# Function to clear all user information fields
function Clear-UserInfo {
    $txtFullName.Text = ""
    $txtPhone.Text = ""
    $txtDepartment.Text = ""
    $txtTitle.Text = ""
    $txtEmployeeID.Text = ""
    $txtCanonicalName.Text = ""
    $btnOpenADUC.IsEnabled = $false
    $global:CurrentUser = $null
    $global:CurrentDomain = $null
}

# Function to search for a user by UPN in the selected domain
function Search-ADUser {
    param($UPN)
    
    Clear-UserInfo
    
    if ([string]::IsNullOrWhiteSpace($UPN)) {
        [System.Windows.MessageBox]::Show("Please enter a User Principal Name (email).", "Input Required", "OK", "Information")
        return
    }
    
    # Get selected domain
    $selectedItem = $comboDomain.SelectedItem
    $domainName = Get-DomainName -selectedItem $selectedItem
    
    if ([string]::IsNullOrWhiteSpace($domainName)) {
        [System.Windows.MessageBox]::Show("Please select a valid domain.", "Domain Required", "OK", "Information")
        return
    }
    
    # Get admin username
    $adminUsername = $txtAdminUsername.Text
    
    if ([string]::IsNullOrWhiteSpace($adminUsername)) {
        [System.Windows.MessageBox]::Show("Please enter an admin username for the selected domain.", "Admin Username Required", "OK", "Information")
        return
    }
    
    try {
        # Create credential for the domain search
        $Global:domainUsername = "$domainName\$adminUsername" 
        
        # Prompt for password when needed
        $global:credential = Get-Credential -Message "Enter password for $Global:domainUsername" -UserName $Global:domainUsername
        
        # Log the domain name for troubleshooting
        Write-Host "Selected domain: $domainName" 
        
        # Instead of trying to auto-detect a domain controller, just use the domain name directly
        $dcServer = $domainName
        
        # Try both the domain name and adding a DC prefix
        $servers = @($dcServer)
        
        $connected = $false
        $user = $null
        $lastError = $null
        
        # Try different server options
        foreach ($server in $servers) {
            try {
                Write-Host "Attempting connection to: $server"
                
                # Use the AD Module directly with credentials and server parameters
                $adServerParams = @{
                    Server = $server
                    Credential = $global:credential
                    Properties = "DisplayName", "TelephoneNumber", "Department", "Title", "EmployeeID", "CanonicalName"
                    ErrorAction = "Stop"
                }
                
                # First test if we can connect to the server
                # Try a simple query to verify connectivity
                Write-Host "Testing connection to $server with $Global:domainUsername"
                Get-ADDomain -Server $server -Credential $credential -ErrorAction Stop | Out-Null
                Write-Host "Successfully connected to domain"
                
                # If we get here, connection was successful
                $connected = $true
                
                # Now try the actual user query
                if ($UPN -match '@') {
                    $adServerParams.Filter = "UserPrincipalName -eq '$UPN'"
                } else {
                    $adServerParams.Filter = "sAMAccountName -eq '$UPN'"
                }
                
                Write-Host "Searching for user with filter: $($adServerParams.Filter)"
                $user = Get-ADUser @adServerParams
                
                if ($user) {
                    Write-Host "User found: $($user.Name)"
                    break # Exit the loop if user found
                }
            }
            catch {
                $lastError = $_
                Write-Host "Error with server $server`: $($_.Exception.Message)"
                # Continue to try the next server
            }
        }
               
        if ($user) {
            $txtFullName.Text = $user.DisplayName
            $txtPhone.Text = $user.TelephoneNumber
            $txtDepartment.Text = $user.Department
            $txtTitle.Text = $user.Title
            $txtEmployeeID.Text = $user.EmployeeID
            $txtCanonicalName.Text = $user.CanonicalName
            $btnOpenADUC.IsEnabled = $true
            
            # Store user and domain for ADUC navigation
            $global:CurrentUser = $user
            $global:CurrentDomain = $domainName
            $global:CurrentCredential = $global:credential
            $global:CurrentDC = $dcServer
        }
        else {
            [System.Windows.MessageBox]::Show("User not found or unable to connect to domain '$domainName'. Try using a different domain or check your credentials.", "Not Found or Connection Issue", "OK", "Warning")
        }
    }
    catch {
        # Provide more detailed error information
        $errorMessage = $_.Exception.Message
        $innerException = $_.Exception.InnerException
        
        if ($innerException) {
            $errorMessage += " Inner Exception: $($innerException.Message)"
        }
        
        # Log detailed error info
        Write-Host "Error details: $errorMessage"
        
        # Show a more helpful error message to the user
        if ($errorMessage -like "*target name is incorrect*") {
            [System.Windows.MessageBox]::Show("Cannot connect to domain '$domainName'. Please verify the domain name is correct and your computer can reach it.", "Connection Error", "OK", "Error")
        }
        elseif ($errorMessage -like "*rejected the client credentials*") {
            [System.Windows.MessageBox]::Show("The credentials you provided were rejected. Please verify your username and password for the domain.", "Authentication Error", "OK", "Error")
        }
        else {
            [System.Windows.MessageBox]::Show("Error searching for user: $errorMessage", "Error", "OK", "Error")
        }
    }
}

# Function to launch ADUC directly with credentials
Function Get-ADUC {
    Param (
        [string]$domain,
        [string]$userName,
        [pscredential]$credential,
        [string]$distinguishedName = $null
    )
    
    # Make sure domain is properly formatted
    # Strip any spaces and convert to lowercase for consistency
    $domain = $domain.Trim().ToLower()
    
    # Format credential string
    $credString = "$Global:domainUsername"
    Write-Host "Launching ADUC for domain: $domain with username: $credString"
    
    # Use direct runas approach
    try {
        $command = "C:\Windows\System32\dsa.msc /domain=$domain"
        write-host "Command: $command"
        write-host "Credential: $credString"
        
        # Launch runas directly with the command
        Start-Process "runas.exe" -ArgumentList "/netonly /user:$credString `"mmc.exe $command`"" -Wait:$false
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error launching ADUC: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }

}

# Function to open ADUC in the selected domain
function Open-ADUC {
    if ($global:CurrentUser -and $global:CurrentDomain) {
        try {
            # Get the domain info
            $domainName = $global:CurrentDomain
            Write-host "domainName = $domainName"

            # Get admin username
            $adminUsername = $txtAdminUsername.Text
            
            if ($global:credential) {
                # Launch ADUC with the credentials
                Get-ADUC -domain $domainName -userName $adminUsername -credential $global:credential
            }
        }
        catch {
            [System.Windows.MessageBox]::Show("Error opening ADUC: $($_.Exception.Message)", "Error", "OK", "Error")
        }
    }
    else {
        [System.Windows.MessageBox]::Show("Please search for a user first.", "No User Selected", "OK", "Warning")
    }
}

# Add button click event handlers
$btnSearch.Add_Click({ Search-ADUser -UPN $txtUPN.Text })
$btnOpenADUC.Add_Click({ Open-ADUC })

# Add key press event to search when Enter is pressed in UPN textbox
$txtUPN.Add_KeyDown({
    if ($_.Key -eq 'Return') {
        Search-ADUser -UPN $txtUPN.Text
    }
})

# Show the form
[void]$Window.ShowDialog()