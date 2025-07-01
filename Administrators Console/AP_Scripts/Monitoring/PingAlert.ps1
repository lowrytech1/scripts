param(
    [string]$IPAddress = "11.50.27.220",
    [string]$SmtpServer = 'exchange.kerncounty.com',
    [int]$SmtpPort = 25,
    [string]$FromEmail = 'PRTG-PingAlerts@kerncounty.com',
    [string]$ToEmail = 'compute_domain@kerncounty.com',
    [int]$IntervalSeconds = 60
)

# Host Ping Monitor script by Brian Lowry - 2024.
# This script will test the availability of a server by sending an PING request to the specified URL.
# If the PING request fails to get a response, an email alert will be sent to the specified recipients.

Clear-Host
Write-Host ""
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue -NoNewline
Write-Host "  V1.1" -ForegroundColor red
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "******** Host Ping Monitor *********" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                  " -NoNewline
Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""
Write-Host "  This script will monitor the availability of a server by sending a PING request" -ForegroundColor Green
Write-Host "  to the specified IP Address or hostname every $IntervalSeconds seconds." -ForegroundColor Green
Write-Host "  If the server does not respond for a period of $TimeoutSeconds seconds after the request is sent," -ForegroundColor Green
Write-Host "  an email alert will be sent to the specified recipients." -ForegroundColor Green
Write-Host ""

<# Create email credential object
$SecurePassword = ConvertTo-SecureString $EmailPassword -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($FromEmail, $SecurePassword)
#>
$ping = Test-Connection -ComputerName $IPAddress -Count 1 -ErrorAction Stop

while ($true) {
    try {
        $ping
        Write-Host "$(Get-Date) - Ping successful to $IPAddress"
    }
    catch {
        $Subject = "Ping Alert - Server at $IPAddress is unreachable"
        $Body = "Unable to ping $IPAddress at $(Get-Date)`nError: $($_.Exception.Message)"
        
        # Send email
        Send-MailMessage -From $FromEmail `
                        -To $ToEmail `
                        -Subject $Subject `
                        -Body $Body `
                        -SmtpServer $SmtpServer `
                        -Port $SmtpPort 
                        #-UseSsl `
                        #-Credential $Credential

        Write-Host "$(Get-Date) - Ping failed, alert email sent"
    }
    
    Start-Sleep -Seconds $IntervalSeconds
}
