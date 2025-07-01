# Define the path to the CSV file
#$csvFilePath = Read-Host "Enter the path to the domains CSV file"  # Prompt user to enter the actual path to the CSV file

# Define the path to the output file
$outputFilePath = "c:\1ts\DC-DNS-DHCP-Scopes.csv" # Read-Host" "Enter the path to the output CSV file"  # Prompt user to enter the actual path to the output CSV file

# Function to read domains from CSV file
function Get-DomainsFromCsv {
    param (
        [Parameter(Mandatory=$true)]
        [string]$csvFilePath
    )

    try {
        $domains = Import-Csv -Path $csvFilePath
        return $domains
    } catch {
        Write-Error "Error reading CSV file: $_"
        throw $_
    }
}

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

# Function to get a list of all scopes on a DHCP server
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
}

# Example usage
try {
    $domains = Get-DomainsFromCsv -csvFilePath $csvFilePath

    foreach ($domain in $domains) {
        $domainName = $domain.Domains
        Write-Host "Processing domain: ${domainName}"

        $dcs = Get-DomainControllers -domain $domain.Domains
        Write-Host "Domain Controllers: $(${dcs} -join ', ')"

        $dhcpServers = Get-DhcpServers -domain $domainName
        Write-Host "DHCP Servers: $(${dhcpServers} -join ', ')"

        foreach ($dhcpServer in $dhcpServers) {
            $scopes = Get-DhcpScopes -dhcpServer $dhcpServer
            Write-Host "DHCP Scopes on ${dhcpServer}: $(${scopes} -join ', ')"
        }
    }
} catch {
    Write-Error "An error occurred: $_"
}