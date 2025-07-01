Clear-Host
$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"
# Define the path to the CSV file
#$csvFilePath = Read-Host "Enter the path to the domains CSV file"  # Prompt user to enter the actual path to the CSV file

# Define the path to the output file
$outputFilePath = "c:\1ts\DC-DNS-DHCP-Scopes.csv" # Read-Host" "Enter the path to the output CSV file"  # Prompt user to enter the actual path to the output CSV file

# Function to get a list of all DCs in a domain
function Get-DomainControllers {
    param (
        [Parameter(Mandatory=$true)]
        [string]$domain
    )

    try {
        $dcs = Get-ADDomainController -Filter * -Server $domain | Select-Object -ExpandProperty HostName
        return $dcs
    } catch {
        Write-Error "Error getting domain controllers for domain ${domain}: $_"
        throw $_
    }
}

# Function to get a list of DHCP servers in a domain
function Get-DhcpServers {
    param (
        [Parameter(Mandatory=$true)]
        [string]$domain
    )

    try {
        $dhcpServers = Get-DhcpServerInDC -ComputerName $domain | Select-Object -ExpandProperty DNSName
        return $dhcpServers
    } catch {
        Write-Error "Error getting DHCP servers for domain ${domain}: $_"
        throw $_
    }
}

<# Function to get a list of all scopes on a DHCP server
function Get-DhcpScopes {
    param (
        [Parameter(Mandatory=$true)]
        [string]$dhcpServer
    )

    try {
        $scopes = Get-DhcpServerv4Scope -ComputerName $dhcpServer
        return $scopes
    } catch {
        Write-Error "Error getting DHCP scopes for server ${dhcpServer}: $_"
        throw $_
    }
}#>

# Example usage
try {
    $domain = Get-ADForest | Select-Object -ExpandProperty Domains

    $domainName = $domain.Domains
    Write-Host "Processing domain: ${domainName}"

    $dcs = Get-ADDomainController -filter * | Select-object HostName
    Write-Host "Domain Controllers: $(${dcs} -join ', ')"

    $dhcpServers = Get-DhcpServerindc -domain $domainName
    Write-Host "DHCP Servers: $(${dhcpServers} -join ', ')"

   <# foreach ($dhcpServer in $dhcpServers) {
        $scopes = Get-DhcpServerv4Scope -ComputerName $dhcpServer
        Write-Host "DHCP Scopes on ${dhcpServer}: $(${scopes} -join ', ')"
    
    }#>
} catch {
    Write-Error "An error occurred: $_"
}
#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"