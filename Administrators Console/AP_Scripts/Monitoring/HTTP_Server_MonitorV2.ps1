# HTTP Server Monitor script by Brian Lowry - 2024.
param(
    [string]$URL = "https://prtg.kerncounty.com/index.htm",
    [string]$SmtpServer = 'exchange.kerncounty.com',
    [int]$SmtpPort = 25,
    [string]$FromEmail = 'PRTG-HTTPmonitor@kerncounty.com',
    [string]$ToEmail = 'compute_domain@kerncounty.com',
    [int]$IntervalSeconds = 60,
    [int]$TimeoutSeconds = 30
)
$WarningPreference = "SilentlyContinue"
# HTTP Server Monitor Test script by Brian Lowry - 2024.
# This script will test the availability of a web server by sending an HTTP request to the specified URL.
# If the server is unreachable, an email alert will be sent to the specified recipients.

Clear-Host
#Set Environment Values
[console]::windowwidth=90;
[console]::windowheight=30;
[console]::bufferwidth=[console]::windowwidth;
#$host.UI.RawUI.BackgroundColor="black";
#$host.UI.RawUI.ForegroundColor="a";
$host.UI.RawUI.WindowTitle="HTTP Server Monitor";

# Header
# Banner text definitions
$BANNER1 = @" 
  _   _ _____ ___________   _____                         
 | | | |_   _|_   _| ___ \ /  ___|                        
| |_| | | |   | | | |_/ / \ `--.  ___ _ ____   _____ _ __ 
|  _  | | |   | | |  __/   `--. \/ _ \ '__\ \ / / _ \ '__|
 | | | | | |   | | | |    /\__/ /  __/ |   \ V /  __/ |   
\_| |_/ \_/   \_/ \_|    \____/ \___|_|    \_/ \___|_|    
"@                                                          
$BANNER2 = @" 
___  ___            _ _             
|  \/  |           (_) |            
| .  . | ___  _ __  _| |_ ___  _ __ 
| |\/| |/ _ \| '_ \| | __/ _ \| '__|
| |  | | (_) | | | | | || (_) | |   
\_|  |_/\___/|_| |_|_|\__\___/|_|    
"@
# Display centered banners
Clear-Host
Write-Host ""
$banner1Lines = $BANNER1 -split "`n"
$banner2Lines = $BANNER2 -split "`n"

# Define host width
$hostWidth = $Host.UI.RawUI.WindowSize.Width

$maxWidth = [Math]::Max(($banner1Lines | Measure-Object -Maximum Length).Maximum, 
                       ($banner2Lines | Measure-Object -Maximum Length).Maximum)

foreach ($line in $banner1Lines) {
    $padding = " " * [math]::Max(0, [math]::Floor(($hostWidth - $line.Length) / 2))
    Write-Host ($padding + $line) -ForegroundColor Green
}
Write-Output ""
foreach ($line in $banner2Lines) {
    $padding = " " * [math]::Max(0, [math]::Floor(($hostWidth - $line.Length) / 2))
    Write-Host ($padding + $line) -ForegroundColor Green
}
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "  This script will monitor the availability of a web server by sending an HTTP request" -ForegroundColor Gray
Write-Host "  to the specified URL every $IntervalSeconds seconds." -ForegroundColor Gray
Write-Host "  If the server does not respond for a period of $TimeoutSeconds seconds after the request is sent," -ForegroundColor Gray
Write-Host "  an email alert will be sent to the specified recipients." -ForegroundColor Gray
Write-Host ""
Write-Host ("*" * $hostWidth) -ForegroundColor Cyan
Write-Host "Date:      Time:      Status:" -ForegroundColor yellow

while ($true) {
    try {
        $request = [System.Net.WebRequest]::Create($URL)
        $request.Timeout = $TimeoutSeconds * 1000
        $response = $request.GetResponse()
        
        if ($response.StatusCode -eq 'OK') {
            Write-Host "$(Get-Date) - HTTP test successful for $URL"
            $response.Close()
        }
    }
    catch {
        $Subject = "HTTP Alert - Server at $URL is unreachable"
        $Body = "Unable to connect to $URL at $(Get-Date)`nError: $($_.Exception.Message)"
        
        # Send email
        Send-MailMessage -From $FromEmail `
                        -To $ToEmail `
                        -Subject $Subject `
                        -Body $Body `
                        -SmtpServer $SmtpServer `
                        -Port $SmtpPort

        Write-Host "$(Get-Date) - HTTP test failed, alert email sent"
    }
    
    Start-Sleep -Seconds $IntervalSeconds
}
