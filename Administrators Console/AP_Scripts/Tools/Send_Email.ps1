#Header
Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "******** Send an Email ********" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""

Write-Host "please enter full address for the recipient and sender"

#Body

$From = Read-Host -prompt "From"
$Recipient = Read-Host -prompt "Recipient"
$Subject = Read-Host -prompt "Subject"
$SMTPserver = 'exchange.kerncounty.com'
$Message = Read-Host -prompt "Message"

Send-MailMessage -to $Recipient -from $From -Subject $Subject -Body ($message | Out-String) -SmtpServer $SMTPserver

Write-Host "Email sent to $Recipient from $From with subject $Subject" -ForegroundColor Green
