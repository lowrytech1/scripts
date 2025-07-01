# Insecure Cipher Remediation script by B.Lowry - 2025

#Requires -RunAsAdministrator 
set-strictmode -Version latest
$cs = Get-TlsCipherSuite
 
$csOk = 'TLS_AES_256_GCM_SHA384', 
        'TLS_AES_128_GCM_SHA256', 
        'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384', 
        'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256', 
        'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384',
        'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256',
        'TLS_DHE_RSA_WITH_AES_256_GCM_SHA384',
        'TLS_DHE_RSA_WITH_AES_128_GCM_SHA256',
        'TLS_PSK_WITH_AES_256_GCM_SHA384',
        'TLS_PSK_WITH_AES_128_GCM_SHA256'

# Array to track disabled cipher suites
$disabledCiphers = @()
 
foreach ($c in $cs) {
    if ($csOk.Contains($c.Name)) {
        $c.Name + ' Valid - Enable'
        Enable-TlsCiphersuite -Name $c.Name
    } else {
        $c.Name + ' Disable'
        try {
            Disable-TlsCiphersuite -Name $c.Name
            # Add to disabled ciphers list
            $disabledCiphers += $c
        } catch {
            $PSItem.Exception.Message
        }
    }
}

# Summary of disabled cipher suites
Write-Host "`n`n== DISABLE CIPHER SUITES COMPLETE ==" -ForegroundColor Yellow
Write-Host "`n`n== SUMMARY OF DISABLED CIPHER SUITES ==" -ForegroundColor Yellow
Write-Host "Total cipher suites disabled: $($disabledCiphers.Count)" -ForegroundColor Cyan

if ($disabledCiphers.Count -gt 0) {
    Write-Host "`nDisabled cipher suites details:" -ForegroundColor Cyan
    foreach ($cipher in $disabledCiphers) {
        Write-Host "  • $($cipher.Name)" -ForegroundColor White
        Write-Host "    - Protocol: $($cipher.Protocol)" -ForegroundColor Gray
        Write-Host "    - KeyExchange: $($cipher.KeyExchange)" -ForegroundColor Gray
        Write-Host "    - Encryption: $($cipher.Encryption)" -ForegroundColor Gray
        Write-Host "    - Hash: $($cipher.Hash)" -ForegroundColor Gray
    }
}