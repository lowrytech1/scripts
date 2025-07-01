$GPOReport = foreach($GPO in (Get-GPO -All)) {
    [XML]$GPOInfoReport = Get-GPOReport $GPO.ID -ReportType XML
    $securityFilter = ((Get-GPPermissions -Name $GPO.DisplayName -All | where{$_.Permission -eq "GpoApply"}).Trustee | where{$_.SidType -ne "Unknown"}).name -Join ','
    [pscustomobject]@{
        Name            = $GPO.DisplayName
        LinksPath       = $GPOInfoReport.GPO.LinksTo.SOMPath
        LinksEnabled    = $GPOInfoReport.GPO.LinksTo.Enabled
        WMIFilter       = $GPO.WmiFilter
        CreatedTime     = $GPOInfoReport.GPO.CreatedTime
        ModifiedTime    = $GPOInfoReport.GPO.ModifiedTime
        CompEnabled     = $GPOInfoReport.GPO.Computer.Enabled
        UserEnabled     = $GPOInfoReport.GPO.User.Enabled
        SecurityFilter  = $securityFilter
        GPOEnabled      = $GPOInfoReport.GPO.LinksTo.Enabled
        Enforced        = $GPOInfoReport.GPO.LinksTo.NoOverride
    }
}
