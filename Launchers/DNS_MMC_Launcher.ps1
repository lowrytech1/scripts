Write-Host "DNS Management Console Launcher" -ForegroundColor Cyan
Write-Host "----------------------------" -ForegroundColor Cyan

# Get domain and credentials
$domain = Read-Host "Enter the DNS server name or IP"
$username = Read-Host "Enter username (domain\username format)"

# Create a credential object
$password = Read-Host -AsSecureString "Enter password"
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

# Launch DNS MMC with credentials
Write-Host "Launching DNS Manager for $domain..." -ForegroundColor Yellow

$processArgs = @{
    FilePath = "runas.exe"
    ArgumentList = "/netonly /user:$username `"mmc.exe c:\windows\system32\dnsmgmt.msc /server=$domain`""
    NoNewWindow = $true
    Wait = $false
}

Start-Process @processArgs

Write-Host "`nDNS Management Console has been launched." -ForegroundColor Green
Write-Host "Note: You may need to enter your credentials again in the runas dialog." -ForegroundColor Yellow

