# Function to get a list of DHCP servers in a domain
function Get-DhcpServers {
    param (
        [Parameter(Mandatory=$true)]
        [string]$domainName,
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$credential
    )

    try {
        # Get the list of domain controllers in the domain
        $domainControllers = Get-ADDomainController -Filter * -Server $domainName -Credential $credential | Select-Object -ExpandProperty HostName

        # Initialize an array to hold the DHCP servers
        $dhcpServers = @()

        # Run the command on each domain controller
        foreach ($dc in $domainControllers) {
            $dcDhcpServers = Invoke-Command -ComputerName $dc -Credential $credential -ScriptBlock {
                Get-DhcpServerInDC | Select-Object -ExpandProperty DNSName
            }
            $dhcpServers += $dcDhcpServers
        }

        # Remove duplicates
        $dhcpServers = $dhcpServers | Sort-Object -Unique

        return $dhcpServers
    } catch {
        Write-Error "Error getting DHCP servers for domain ${domainName}: $_"
        throw $_
    }
}

# Main script
try {
    # Ask user for domain name
    $domainName = Read-Host "Enter the domain name"

    # Prompt user for credentials
    $credential = Get-Credential

    # Get the list of DHCP servers in the given domain
    $dhcpServers = Get-DhcpServers -domainName $domainName -credential $credential

    # Display the DHCP servers
    Write-Host "DHCP Servers in domain ${domainName}:"
    $dhcpServers | ForEach-Object { Write-Host $_ }
} catch {
    Write-Error "An error occurred: $_"
}