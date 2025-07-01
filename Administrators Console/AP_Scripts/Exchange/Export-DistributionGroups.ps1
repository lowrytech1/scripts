
$GroupName = Read-Host -Prompt "Input the Display Name of the group to export: "
# First, connect a session to On-Prem Exchange server:
# Exchange Powershell connection script:
Write-Host "************************************************************************"
Write-Host "*                                                                      *"
Write-Host "*               Connecting to On-Prem Exchange Server...               *"
Write-Host "*                                                                      *"
Write-Host "************************************************************************"
Write-host ""

#Obtain On-prem Exchange server credentials:
$UserCredential = Get-Credential -Message "Please enter On-premise Exchange administrative credentials (domain\user)"

# Check if a session already exists and enter, or create new session:
[CmdletBinding()]
[OutputType([int])]

$session = Get-PsSession | Where-Object {
    ($_.ComputerName -match "ITS-EXCH01.kerncounty.com") -and ($_.State -match "Opened")
} # End Where-Object

If (-not ($session)) {
    $Params = @{
    	ConfigurationName = "Microsoft.Exchange"
    	ConnectionUri = "https://ITS-EXCH01.kerncounty.com/PowerShell/"
    	Authentication = "Basic"
    	AllowRedirect = $True
    } # End Params

    $ExchSession = New-PSSession @params -Credential $UserCredential
    Import-PSSession $ExchSession -AllowClobber
} # End -not $session




# CSV file export path
$Csvfile = "C:\scripts\ExportDGs.csv"

# Get all distribution groups
$Groups = Get-DistributionGroup -ResultSize Unlimited | Where-Object {
    ($_.Name -match $GroupName)                       #-ResultSize Unlimited
}

# Loop through distribution groups
$Groups | ForEach-Object {


    $GroupDN = $_.DistinguishedName
    $DisplayName = $_.DisplayName
    $PrimarySmtpAddress = $_.PrimarySmtpAddress
    $SecondarySmtpAddress = $_.EmailAddresses | Where-Object {$_ -clike "smtp*"} | ForEach-Object {$_ -replace "smtp:",""}
    $GroupType = $_.GroupType
    $RecipientType = $_.RecipientType
    $Members = Get-DistributionGroupMember $GroupDN -ResultSize Unlimited
    $ManagedBy = $_.ManagedBy
    $Alias = $_.Alias
    $HiddenFromAddressLists = $_.HiddenFromAddressListsEnabled
    $MemberJoinRestriction = $_.MemberJoinRestriction 
    $MemberDepartRestriction = $_.MemberDepartRestriction
    $RequireSenderAuthenticationEnabled = $_.RequireSenderAuthenticationEnabled
    $AcceptMessagesOnlyFrom = $_.AcceptMessagesOnlyFrom
    $GrantSendOnBehalfTo = $_.GrantSendOnBehalfTo
    $Notes = (Get-Group $GroupDN)

    # Create objects
    [PSCustomObject]@{
        DisplayName                        = $DisplayName
        PrimarySmtpAddress                 = $PrimarySmtpAddress
        SecondarySmtpAddress               = ($SecondarySmtpAddress -join ',')
        Alias                              = $Alias
        GroupType                          = $GroupType
        RecipientType                      = $RecipientType
        Members                            = ($Members.Name -join ',')
        MembersPrimarySmtpAddress          = ($Members.PrimarySmtpAddress -join ',')
        ManagedBy                          = ($ManagedBy.Name -join ',')
        HiddenFromAddressLists             = $HiddenFromAddressLists
        MemberJoinRestriction              = $MemberJoinRestriction 
        MemberDepartRestriction            = $MemberDepartRestriction
        RequireSenderAuthenticationEnabled = $RequireSenderAuthenticationEnabled
        AcceptMessagesOnlyFrom             = ($AcceptMessagesOnlyFrom.Name -join ',')
        GrantSendOnBehalfTo                = ($GrantSendOnBehalfTo.Name -join ',')
        Notes                              = $Notes.Notes
    }

# Export report to CSV file
} | Sort-Object DisplayName | Export-CSV -Path $Csvfile -NoTypeInformation -Encoding UTF8 #-Delimiter ";"