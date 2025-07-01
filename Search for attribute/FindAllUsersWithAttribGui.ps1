# Find and clear AD user attribute script by B.Lowry

# Import the Active Directory module
Import-Module ActiveDirectory

# Function to clear the attribute value for a user
function Clear-AttributeValue {
    param (
        [Parameter(Mandatory = $true)]
        [string]$UserSamAccountName,
        [Parameter(Mandatory = $true)]
        [string]$AttributeName
    )

    try {
        Set-ADUser -Identity $UserSamAccountName -Clear $AttributeName
        Write-Host "Cleared $AttributeName for user $UserSamAccountName" -ForegroundColor Green
    } catch {
        Write-Error "Failed to clear $AttributeName for user $UserSamAccountName: $_"
    }
}

Write-Host ""
Write-Host "******************************************************************************"
Write-Host ""
Write-Host "This script will search all user accounts in a given AD Domain looking for`nany accounts with a specific attribute set."
Write-Host "If any accounts are found, you will be presented with a list of detected`naccounts and prompted to clear the attribute value or quit."
Write-Host ""
Write-Host "******************************************************************************"
Write-Host ""

# Confirm the domain to access
$domainName = Read-Host "Enter the domain to connect to (leave blank for the default domain)"
if (-not [string]::IsNullOrWhiteSpace($domainName)) {
    # Set the Active Directory domain context
    $domainContext = Get-ADDomain -Server $domainName
    Write-Host "Connected to domain: $($domainContext.Name)" -ForegroundColor Cyan
} else {
    $domainContext = Get-ADDomain
    Write-Host "Connected to the default domain: $($domainContext.Name)" -ForegroundColor Cyan
}

# Define the attribute to search for and its value
$attributeName = Read-Host "AttributeName"  # Replace with the attribute name you want to search for
$attributeValue = Read-Host "Value"         # Replace with the value of the attribute you are looking for

# Search for users with the specified attribute set
try {
    $users = Get-ADUser -Filter * -Properties $attributeName -Server $domainContext.Name | Where-Object {
        $_.$attributeName -eq $attributeValue
    }

    if ($users.Count -gt 0) {
        Write-Host "Found the following users with $attributeName set to $attributeValue:"
        $users | ForEach-Object {
            Write-Host $_.SamAccountName
        }

        # Prompt to clear the attribute value
        $confirmClear = Read-Host "Do you want to clear the $attributeName value for these users? (Y/N)"
        if ($confirmClear -eq "Y") {
            $users | ForEach-Object {
                Clear-AttributeValue -UserSamAccountName $_.SamAccountName -AttributeName $attributeName
            }
        } else {
            Write-Host "No changes were made."
        }
    } else {
        Write-Host "No users found with $attributeName set to $attributeValue."
    }
} catch {
    Write-Error "An error occurred while querying Active Directory: $_"
}