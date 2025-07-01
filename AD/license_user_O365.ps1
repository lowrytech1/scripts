#******************************************************************************************* 
# 1. Check if AZ powershell module installed
# 2. The Azure PowerShell module will be installed if absent.
# 3. Get AZ Credentials
# 4. Get current membership list to check if new user is already a member, quit if listed
# 5. Add user to membership list
#********************************************************************************************

Write-host "This script requires Microsoft PowerShell 7 or higher - Windows PowerShell is insufficient." -ForegroundColor Yellow -BackgroundColor Blue

# Check for AZ Module installed, Install AZ module(if necessary):
Write-Host "************************************************************************"
Write-Host "*                                                                      *"
Write-Host "*              Verifying Azure module is installed...                  *"
Write-Host "*                                                                      *"
Write-Host "************************************************************************"
Write-host ""
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

# Remove the below lines when combing this script with the mailbox script:
$DisplayName = "Brian Lowry"
$UserUpn = "lowryb"

# Get AZ Credentials:
Connect-AzAccount
Write-host "Connected to Azure"

Write-Host "************************************************************************"
Write-Host "*                                                                      *"
Write-Host "*                 Adding user to O365 licensing group...               *"
Write-Host "*                                                                      *"
Write-Host "************************************************************************"
Write-host ""

# Get membership list to check if user is already included:
$CurrentMember = Get-AzADGroup -ObjectId "e68a8d67-b116-4d2d-a20d-0e6b6614ac80" | get-AzADGroupMember | Select-Object -Property DisplayName
 | Where-Object {
    ($_.DisplayName -match "$DisplayName")
} # End Where-Object

If (-not ($CurrentMember)) {
    $UserID = Get-ADUser -Identity "$UserUpn" | Select-Object -Property ObjectGUID
    Add-AzADGroupMember -TargetGroupObjectId "e68a8d67-b116-4d2d-a20d-0e6b6614ac80" -memberObjectId $UserID
} 
Else {
    Write-Host "User is already a member of the Licensing group."
    Exit
    }

Write-Host User $DisplayName has been added to the O365 licensing security group and is now licensed.








