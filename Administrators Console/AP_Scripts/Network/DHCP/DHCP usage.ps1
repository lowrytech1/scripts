# This script gets a list of DHCP scopes that are above 80% usage
# then sends an email to NSA@kerncounty.com
# -IM

$DHCPusage = Get-DhcpServerv4ScopeStatistics | Where-Object -FilterScript {$_.PercentageInUse -Gt 80 } | Select ScopeId,AddressesFree,AddressesInUse,ReservedAddresses,PercentageInUse | Sort-Object -Descending PercentageInUse | FL

$Recipient = 'martinezi@kerncounty.com'
$Sender = 'DNS1@kerncounty.com'
$Subject = 'DHCP Scopes above 80% Usage' 
$SMTPserver = 'exchange.kerncounty.com'


Send-MailMessage -to $Recipient -from $Sender -Subject $Subject -Body ($DHCPusage | Out-String) -SmtpServer $SMTPserver
