Clear-Host
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

# Header
Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "******* All DHCP Scopes *******" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

# Define the path to the CSV file
$csvFilePath = Read-Host "path\to\domains.csv"  # Update with the actual path to your CSV file

# Define the path to the output file
$outputFilePath = Read-Host "path\to\output.csv"  # Update with the actual path to your output CSV file

# Function to read domains from CSV file
function Get-DomainsFromCsv {
    param (
        [Parameter(Mandatory=$true)]
        [string]$csvFilePath
    )

    $domains = Import-Csv -Path $csvFilePath
    return $domains
}

# Function to get a list of all DCs in a domain
function Get-DomainControllers {
    param (
        [Parameter(Mandatory=$true)]
        [string]$domain
    )

    $dcs = Get-ADDomainController -Filter * -Server $domain | Select-Object -ExpandProperty HostName
    return $dcs
}

# Function to get a list of DHCP servers in a domain
function Get-DhcpServers {
    param (
        [Parameter(Mandatory=$true)]
        [string]$domain
    )

    $dhcpServers = Get-DhcpServerInDC -ComputerName $domain | Select-Object -ExpandProperty DNSName
    return $dhcpServers
}

# Function to get a list of all scopes on a DHCP server
function Get-DhcpScopes {
    param (
        [Parameter(Mandatory=$true)]
        [string]$dhcpServer
    )

    $scopes = Get-DhcpServerv4Scope -ComputerName $dhcpServer | Select-Object -ExpandProperty ScopeId
    return $scopes
}

# Main script execution
try {
    $domains = Get-DomainsFromCsv -csvFilePath $csvFilePath

    $output = @()
    foreach ($domain in $domains) {
        $domainName = $domain.Domain
        $output += "Domain: $domainName"

        $dcs = Get-DomainControllers -domain $domainName
        foreach ($dc in $dcs) {
            $output += "`tDC: $dc"

            $dhcpServers = Get-DhcpServers -domain $dc
            foreach ($dhcpServer in $dhcpServers) {
                $output += "`t`tDHCP Server: $dhcpServer"

                $scopes = Get-DhcpScopes -dhcpServer $dhcpServer
                foreach ($scope in $scopes) {
                    $output += "`t`t`tScope: $scope"
                }
            }
        }
    }

    # Write the output to a CSV file
    $output | Out-File -FilePath $outputFilePath -Encoding utf8

    Write-Host "Report generated successfully."
} catch {
    Write-Error "An error occurred: $_"
}

#Script Execution Stats
$endTime = Get-Date
# Calculate time difference between start and end time
$Duration = New-TimeSpan -Start $StartTime -End $EndTime
#Format the duration time as dd:HH:mm:ss
$formattedDuration = "{0:D2}:{1:D2}:{2:D2}:{3:D2}" -f $Duration.Days, $Duration.Hours, $Duration.Minutes, $Duration.Seconds
Write-Host "Script Duration time (dd:HH:mm:ss):" -NoNewline
Write-Host "  $formattedDuration" -foregroundcolor "yellow"

# Keep the PowerShell window open
Read-Host "Press Enter to exit"