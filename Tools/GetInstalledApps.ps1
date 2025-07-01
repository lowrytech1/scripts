$computers = @(Get-adcomputer -filter * | Where-Object enabled -eq "true"| select-object distinguishedname)
foreach($pc in $computers) {
    $InstalledSoftware = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
    foreach($obj in $InstalledSoftware){write-host $obj.GetValue('DisplayName') -NoNewline; write-host " - " -NoNewline; write-host $obj.GetValue('DisplayVersion')}
}