#*******************************************************************************************
# 1. Get AZ Credentials
# 2. Connect to Azure
# 2. Get current membership list to check if new user is a member, quit if not listed
# 5. Remove user from membership list
#********************************************************************************************
Clear-Host
$startTime = Get-Date
Write-Host "Start script:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"

$SuppressAzurePowerShellBreakingChangeWarnings = $true
$WarningPreference = 0

#Header
Write-Host ""
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "******* Remove M365 Lic. ******" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "*******************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""
Write-host "***************************************************************************" -ForegroundColor red -BackgroundColor Black
Write-host "       *** This script requires Microsoft PowerShell 7 or higher. ***     *" -ForegroundColor red -BackgroundColor Black
Write-host "                    Windows PowerShell is insufficient.                    " -ForegroundColor red -BackgroundColor Black
Write-host "*** This should only be used for users with an @kernCounty.com account. ***" -ForegroundColor Yellow -BackgroundColor Blue
Write-host "***************************************************************************" -ForegroundColor red -BackgroundColor Black

$PSModuleAutoLoadingPreference = "All"

# Collect user info:
#  btest@kerncounty.com
<# $MemberName = Read-Host -Prompt "Please enter the full name for the member you want to unlicense "
$Gname = "SG - Microsoft 365 GCC G5 License ALL"
$MemberID = (Get-AzADUser -DisplayName $MemberName).Id
$userPrincipalName = (Get-AzAdUser -Displayname $MemberName).userPrincipalName#>


# Use this for dynamic group selection instead of named:
#$AADGroup = Get-AzADGroup -Filter "objectID = $groupID"



# Licensing group $GroupName = "SG - Microsoft 365 GCC G5 License ALL"
# Licensaing group GroupID: e68a8d67-b116-4d2d-a20d-0e6b6614ac80

<#Verify User info:
Write-Host "Verify User info:" -f red
Write-Output "DisplayName - $MemberName"
Write-Output "Group - $Gname"
Start-Sleep -Seconds 3#>

Write-Output "                                                                           "
Write-Output "   ************************************************************************"
Write-Output "   *                                                                      *"
Write-Output "   *                        Connecting to Azure...                        *"
Write-Output "   *                                                                      *"
Write-Output "   ************************************************************************"
Write-Output ""

#VERIFY AZ CONNECT
$IsConnected = get-AZContext
if ( !($IsConnected) ) {
        write-host "Not connected" -ForegroundColor red
        Connect-AzAccount
}
Else { 
    Write-host "                         *** Connected to Azure ***                        " -ForegroundColor black -BackgroundColor Green
}

#Get the Azure AD User ID

# Get the user info
$UserUpn = Read-Host -Prompt "Please enter the User Name of the user to remove (E.G.; LowryB)"
$UPN = ($UserUpn + "@kerncounty.com")
$user = Get-AzADUser -UserPrincipalName $UPN
    $userObjectID = $user.Id
$MemberName = $user.displayname

#Get the Azure AD Group ID
$group = Get-AzADGroup -DisplayName "SG - Microsoft 365 GCC G5 License ALL"
    $groupID = $group.Id


Write-Output "                                                                           "
Write-Output "   ************************************************************************"
Write-Output "   *                                                                      *"
Write-Output "   *          Removing $MemberName from O365 licensing group...            *"
Write-Output "   *                                                                      *"
Write-Output "   ************************************************************************"
Write-Output ""
Write-Host "*       Checking if user is a member of the licensing security group.     *" -ForegroundColor yellow
Write-Host "*                            Please stand by...                           *"-ForegroundColor yellow

# Get membership list to check if user is already included:
#$CurrentMemberDN = get-AzADGroupMember -UserPrincipalName $UserUPN

$groupMembers = Get-AzADGroupMember -GroupObjectId $groupId
$memberExists = $groupMembers | Where-Object {
    $_.Id -eq $userObjectId
}
if ($memberExists) {
    Write-Output "The user is a member of the Azure AD group."
} else {
    Write-Output "The user is not a member of the Azure AD group."
}


<#Prove Correct Vars:
$CurrentMember = "$currentmemberDN"
Write-host ("Display Name = $UserDisplayName") -ForegroundColor Blue
Write-host ("CurrentMember = $CurrentMember") -ForegroundColor Blue #>

#Remove user from sec. group:
if ($memberExists) {
    Write-Host "                 *** $MemberName is currently licensed. Removing member ***                     " -ForegroundColor white -BackgroundColor Red
    Remove-AzADGroupMember -GroupObjectId $groupID -MemberObjectId $userObjectID

    #Test if removal was effective
    Write-Host "                           *** Verifying removal was successful ***                              " -ForegroundColor white -BackgroundColor Red
    $groupMembers = Get-AzADGroupMember -GroupObjectId $groupId
    $memberExists = $groupMembers | Where-Object {$_.ObjectId -eq $userObjectId}
    if ($memberExists) {
        write-host "Removal Failed. Try again"
    } else {
        Write-Host "User $DisplayName has been removed from the `n O365 licensing security group and is now unlicensed." -ForegroundColor white -BackgroundColor Green
    }
}

#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"