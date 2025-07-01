#*******************************************************************************************
# 1. Check if AZ powershell module installed
# 2. The Azure PowerShell module will be installed if absent.
# 3. Get AZ Credentials
# 4. Get current membership list to check if new user is already a member, quit if listed
# 5. Add user to membership list
#********************************************************************************************

Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

$SuppressAzurePowerShellBreakingChangeWarnings = $true
$WarningPreference = 0

# Header
Write-Host "***********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "***********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "****** License User for M365 ******" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "***********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "***********************************" -ForegroundColor yellow -BackgroundColor Blue

Write-host "       *** This script requires Microsoft PowerShell 7 or higher. ***     *" -ForegroundColor red -BackgroundColor Black
Write-host "                    Windows PowerShell is insufficient.                    " -ForegroundColor red -BackgroundColor Black

# Check for AZ Module installed:
<#
$AZinstalled = Get-InstalledModule -Name Az
If (-not ($AZinstalled)) {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Install-Module -Name Az -Repository PSGallery -Force
    Import-Module -name az
    write-host "Azure module successfully installed"
}
Else {
    Write-host "Azure Module is installed"
}
#>

# Collect user info:
$UserUpn = Read-Host -Prompt "Please enter the first part of the email address of the user to add (UPN)"
#$DisplayName = Read-Host -Prompt "Users Display Name - Full Name (First Last)"
$Email = ($UserUpn + "@kerncounty.com")
$UPN = ($UserUpn + "@kerncounty.onmicrosoft.com")
$TargetGroupObjectID = "e68a8d67-b116-4d2d-a20d-0e6b6614ac80"
$user = Get-AzADUser -UserPrincipalName $Email
    $userObjectID = $user.Id
    $DisplayName = $user.displayname

# $GroupObjectID = ($GroupObjectID | Select-Object -ExpandProperty Name)

#Verify info:
Write-Host "UserUPN - $UserUpn" -ForegroundColor Blue
Write-Host "DisplayName - $DisplayName" -ForegroundColor Blue
Write-Host "Email - $Email" -ForegroundColor Blue
Write-Host "UPN - $UPN" -ForegroundColor Blue

Write-Host "                                                                           "
Write-Host "   ************************************************************************"
Write-Host "   *                                                                      *"
Write-Host "   *                        Connecting to Azure...                        *"
Write-Host "   *                                                                      *"
Write-Host "   ************************************************************************"
Write-Host ""

#VERIFY AZ CONNECT.
$counter = 0
$IsConnected = get-AZContext
if ( !$IsConnected ) {
    While ($counter -lt 4) {
        write-host "Not connected" -ForegroundColor red
        Connect-AzAccount
        $counter++
        If ($counter -GT 3) {
            write-host "Unable connect to Azure" -ForegroundColor red
        }
    }
}
Else {Write-host "                         *** Connected to Azure ***                        " -ForegroundColor black -BackgroundColor Green}


Write-Host "                                                                           "
Write-Host "   ************************************************************************"
Write-Host "   *                                                                      *"
Write-Host "   *                Adding user to O365 licensing group...                *"
Write-Host "   *                                                                      *"
Write-Host "   ************************************************************************"
Write-Host ""
Write-Host "*  Checking if user is already a member of the licensing security group.  *"
Write-Host "*                           Please stand by..."                           *""

# Get membership list to check if user is already included:

$groupMembers = Get-AzADGroupMember -GroupObjectId $TargetGroupObjectID
$memberExists = $groupMembers | Where-Object {$_.Id -eq $userObjectID}
if ($memberExists) {
    Write-Output "The user is a member of the Azure AD group."
} else {
    Write-Output "The user is not a member of the Azure AD group."
}

#Prove Correct Vars:
#Write-host "IsMember - $MemberExists.displayname" -ForegroundColor Blue
Write-Host $MemberExists.displayname -ForegroundColor Blue
#Write-host ("CurrentMember = $CurrentMember") -ForegroundColor Blue

#Add user to sec. group:
If (!$memberExists){
    Write-Host "                 *** $DisplayName is not licensed. Adding member***                      " -ForegroundColor white -BackgroundColor Red
    #$UserID = Get-AZADUser -Identity $UserUpn | Select-Object -ExpandProperty ObjectGUID
    Add-AzADGroupMember -TargetGroupObjectId $TargetGroupObjectID -memberObjectId $userObjectID
    start-sleep -Seconds 5

    # Recheck membership list to see if add was successful:
    $groupMembers = Get-AzADGroupMember -GroupObjectId $TargetGroupObjectID
    $memberExists = $groupMembers | Where-Object {$_.Id -eq $userObjectId}
    if (!$memberExists) {
        Write-Host "                *** License not set. Please use M365 Console. ***                   " -ForegroundColor white -BackgroundColor Red
        exit
    } Else {
    Write-Host "User $DisplayName has been added to the O365 licensing security group and is now licensed."-ForegroundColor white -BackgroundColor Green
    }
}







