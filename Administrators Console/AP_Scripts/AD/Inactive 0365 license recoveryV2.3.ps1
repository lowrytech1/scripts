Clear-Host
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

# Header
Write-Host ""
Write-Host "                    " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue -NoNewline
Write-Host "  V2.3" -ForegroundColor red
Write-Host "                    " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                    " -NoNewline
Write-Host "** Inactive 0365 license recovery **" -ForegroundColor red -BackgroundColor Black
Write-Host "                    " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                    " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

# Ensure the AzureAD module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "Microsoft.Graph module is not installed. Installing..." -ForegroundColor red
    Install-Module -Name Microsoft.Graph -Force -Scope CurrentUser
} Else {
    Write-Host "Microsoft.Graph module is installed" -ForegroundColor green
}

# Import the AzureAD module
Import-Module Microsoft.Graph

# Debugging entry
Write-Host "Module Installation Complete"

Write-Host "                                                                           "
Write-Host "   ************************************************************************"
Write-Host "   *                                                                      *"
Write-Host "   *                    Connecting to Azure\MS Graph...                   *"
Write-Host "   *                                                                      *"
Write-Host "   ************************************************************************"
Write-Host ""

# VERIFY AZ CONNECTION, CONNECT IF NOT.
$IsConnected = Get-MgContext
if ($IsConnected) {
    Write-host "Using established connection" -ForegroundColor Yellow
} Else {
    # Connect to Azure
    write-host "                                 Not connected" -ForegroundColor red
    Write-host "                         *** Connecting to Azure\Graph ***                        " -ForegroundColor black -BackgroundColor Yellow
    Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All" -NoWelcome
    $IsConnected
}
$IsConnected = Get-MgContext
If ( !$IsConnected) {
    write-host "                            Unable to connect to Azure" -ForegroundColor red
    exit   
} Else { 
    Write-host "                          *** Connected to Azure\Graph ***                        " -ForegroundColor black -BackgroundColor Green
}

# Get all users
Write-host "Getting users, this may take a while" -ForegroundColor yellow
$users = Get-MgUser -All

# Filter users with assigned licenses who haven't signed in for the last 90 days
Write-host "Filtering users- offline > 90 days" -ForegroundColor yellow
$unusedLicenses = $users | Where-Object { $_.AssignedLicenses.Count -gt 0 -and $_.LastSignInDateTime -lt (Get-Date).AddDays(-90) } | Select-Object DisplayName, UserPrincipalName, LastSignInDateTime

# Count the number of users with underutilized licenses
Write-host "Counting underutilized licenses found"
$UnusedLicensesCount = $unusedLicenses.Count
If ($UnusedLicensesCount -eq 0) {
    Write-Host "No users found with underutilized licenses. Disconnecting" -ForegroundColor Blue
    #Disconnect-MgGraph
    exit
} Else {
    # Display the unused license holder accounts
    Write-Host "Found $UnusedLicensesCount users with underutilized licenses:" -ForegroundColor Green
    Write-Host "$UnusedLicenses" | Format-Table -AutoSize

    # Generate a report
    $DateStamp = Get-Date -Format "yy-MM-dd--HH:mm"
    $reportPath = "C:\temp\UnderUtilizedO365Licenses-$DateStamp.csv"
    $unusedLicenses | Export-Csv -Path $reportPath -NoTypeInformation

    Write-Host "Report generated at $reportPath"
    #Disconnect-MgGraph
}

#Script Execution Stats
$endTime = Get-Date
# Calculate time difference between start and end time
$Duration = New-TimeSpan -Start $StartTime -End $EndTime
#Format the duration time as dd:HH:mm:ss
$formattedDuration = "{0:D2}:{1:D2}:{2:D2}:{3:D2}" -f $Duration.Days, $Duration.Hours, $Duration.Minutes, $Duration.Seconds
Write-Host "Script Duration time (dd:HH:mm:ss):" -NoNewline
Write-Host "  $formattedDuration" -foregroundcolor "yellow"