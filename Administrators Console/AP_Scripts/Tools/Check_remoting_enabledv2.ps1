#Header

Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "******* Test PS Remoting ******" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""
# Define the server name or IP address
$serverName = read-host "Computer or server name or IP address"

# Test if PowerShell remoting is enabled on the server
try {
    Test-WSMan -ComputerName $serverName -ErrorAction Stop
    Write-Host "PowerShell remoting is enabled on $serverName."
} catch {
    Write-Host "PowerShell remoting is not enabled on $serverName. Error: $_"
}