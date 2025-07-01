#Requires -RunAsAdministrator 
set-strictmode -Version latest
 
$cs = 'TLS_AES_256_GCM_SHA384',                    
  'TLS_AES_128_GCM_SHA256',
  'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384',
  'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256',
  'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384',     
  'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256',
  'TLS_DHE_RSA_WITH_AES_256_GCM_SHA384',       
  'TLS_DHE_RSA_WITH_AES_128_GCM_SHA256',
  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384',
  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256',
  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384',     
  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256',
  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA',      
  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA',
  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA',        
  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA',
  'TLS_RSA_WITH_AES_256_GCM_SHA384',           
  'TLS_RSA_WITH_AES_128_GCM_SHA256',
  'TLS_RSA_WITH_AES_256_CBC_SHA256',           
  'TLS_RSA_WITH_AES_128_CBC_SHA256',
  'TLS_RSA_WITH_3DES_EDE_CBC_SHA'
 

  Write-Host "Re-enabling cipher suites..." -ForegroundColor Green
foreach ($c in $cs) {
    try {
        'Enabling ' + $c
        Enable-TlsCiphersuite -Name $c
    } catch {
        $PSItem.Exception.Message
    }
}