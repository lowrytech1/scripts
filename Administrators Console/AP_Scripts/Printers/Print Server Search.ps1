#Print Server Search by Brian Lowry 2024

Clear-Host
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

# Header
Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "***** Print Server Search *****" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

# Import the Active Directory module
Import-Module ActiveDirectory

# Set the search base to the current domain
$searchBase = (Get-ADDomain).DistinguishedName

# Debugging output
Write-Host "Search base: $searchBase"

# Retrieve all computer objects with Print Services role
try {
    $printServers = Get-ADComputer -Filter 'OperatingSystem -like "*Server*" -and Enabled -eq $true' -SearchBase $searchBase -Property Name, OperatingSystem, ServicePrincipalName | Where-Object { $_.ServicePrincipalName -like "*print*" }
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit
}

# Display the results
If ($null -eq $printServers -or $printServers.Count -eq 0) {
    Write-Host "No print servers found." -ForegroundColor Red
} Else {
    Write-Host "Print Servers found:" -ForegroundColor Green
    Foreach ($server in $printServers) {
        Write-Host $server.Name
    }
}

$endTime = Get-Date
$formattedEndTime = $endTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedEndTime"