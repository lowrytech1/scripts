#ToDo: Add "Complete" chime to the end of the script
#ToDo: Verify it works with all 3 policy types (Security, Registry, SoftwareInstallation), and user config policies.
#ToDo: Get-GPO does not support the -Domain parameter.  Need to find a way to search all domains in the forest.
#ToDo:     Most likely will need to perform a remote session to a DC in each domain to search for the GPOs.
# GPO Search Script by Brian Lowry - 2025

#Requires -RunAsAdministrator

param (
    [string]$SettingName,
    [string]$GUID
)

Set-Location $PSScriptRoot
Clear-Host

# Ensure the GroupPolicy module is installed
if (-not (Get-Module -ListAvailable -Name GroupPolicy)) {
    Write-Host "GroupPolicy module is not installed. Installing..." -ForegroundColor red
    Add-WindowsCapability -Online -Name Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0
    Import-Module GroupPolicy
    Write-Host "GroupPolicy module is now installed" -ForegroundColor green
} Else {
    Write-Host "GroupPolicy module is installed" -ForegroundColor green
}

$domains = @(
"your_domain.com"
)
$defaultSelection = 1

# Add helper function for centering text
function Write-CenteredText {
    param([string]$Text, [System.ConsoleColor]$ForegroundColor = [System.ConsoleColor]::White)
    
    # Split the text into lines
    $lines = $Text -split "`n"
    $maxLength = ($lines | Measure-Object -Property Length -Maximum).Maximum
    $windowWidth = $Host.UI.RawUI.WindowSize.Width
    
    foreach ($line in $lines) {
        # Calculate padding without trimming spaces
        $padding = [Math]::Max(0, [Math]::Floor(($windowWidth - $line.Length) / 2))
        Write-Host (" " * $padding) -NoNewline
        Write-Host $line -ForegroundColor $ForegroundColor
    }
}

# Define the function to play sounds
<#function #Invoke-Sound {
    param (
        [string]$soundPath
    )
    $player = New-Object System.Media.SoundPlayer
    $player.SoundLocation = $soundPath
    $player.Load()
    $player.Play()
}#>

# Define the function to search settings in GPOs
function Search-GPOsForSetting {
    param (
        [string]$SettingName
    )
    #Invoke-Sound "$PSScriptRoot\..\Media\Jeopardy-theme-song.wav"

    Write-Host "Selected domain: $selectedDomain" -ForegroundColor Yellow
    Write-Host "Using credentials: $($domainCred.UserName)" -ForegroundColor Yellow

    # Get all GPOs in the domain
    $gpos = Get-GPO -All -Server $selectedDomain

    Write-Host "Number of GPOs found: $($gpos.Count)" -ForegroundColor Yellow

    # Initialize progress bar variables
    $GPOcount = $gpos.count
    $CurrentIndex = 0

    # Initialize an array to hold matching GPOs
    $matchingGPOs = @()

    # Check if the Reports directory exists, create if it doesn't
    if (!(Test-Path -Path "$PSScriptRoot\Reports" -PathType Container)) {
        New-Item -ItemType Directory -Path "$PSScriptRoot\Reports"
    } else {
        # Clear existing reports
        Get-ChildItem -Path "$PSScriptRoot\Reports" -File | Remove-Item -Force
    }

    foreach ($gpo in $gpos) { # Iterate through each GPO found
        # Sanitize the GPO display name
        $sanitizedDisplayName = $gpo.DisplayName -replace '[\\/:*?"<>|]', '_'
    
        # Generate file paths
        $gpoReportComputerPath = "$PSScriptRoot\Reports\$sanitizedDisplayName-Computer.xml"
        $gpoReportUserPath = "$PSScriptRoot\Reports\$sanitizedDisplayName-User.xml"
    
        <# Debug: Verify paths
        Write-Host "Computer report path: $gpoReportComputerPath" -ForegroundColor Yellow
        Write-Host "User report path: $gpoReportUserPath" -ForegroundColor Yellow#>
    
        # Generate GPO reports
        $gpoReportComputer = Get-GPOReport -Guid $gpo.Id -ReportType Xml -Path $gpoReportComputerPath
        $gpoReportUser = Get-GPOReport -Guid $gpo.Id -ReportType Xml -Path $gpoReportUserPath
    
        # Load the XML reports
        $xmlComputer = [xml](Get-Content -Path $gpoReportComputerPath)
        $xmlUser = [xml](Get-Content -Path $gpoReportUserPath)
    
        # Search for the setting in all relevant nodes
        $foundInComputer = $xmlComputer.GPO.Computer.Registry.Policy | Where-Object {
            $_.Name -like "*$SettingName*" -or $_.Value -like "*$SettingName*"
        }
    
        $foundInUser = $xmlUser.GPO.User.Registry.Policy | Where-Object {
            $_.Name -like "*$SettingName*" -or $_.Value -like "*$SettingName*"
        }
    
        # Search in other nodes if necessary (e.g., ExtensionData)
        $foundInComputerExtensions = $xmlComputer.GPO.Computer.ExtensionData.Extension | Where-Object {
            $_.InnerXml -like "*$SettingName*"
        }
    
        $foundInUserExtensions = $xmlUser.GPO.User.ExtensionData.Extension | Where-Object {
            $_.InnerXml -like "*$SettingName*"
        }
    
        if ($foundInComputer -or $foundInUser -or $foundInComputerExtensions -or $foundInUserExtensions) {
            Write-Host "Setting '$SettingName' found in GPO: $($gpo.DisplayName)" -ForegroundColor Green
            $matchingGPOs += $gpo
            Write-Verbose "GPO = $($gpo)"
            ##Invoke-Sound -soundPath "$PSScriptRoot\..\Media\R2D2-Happy1.wav" -ErrorAction SilentlyContinue
        }
    }

    # Return all matching GPOs
    return $matchingGPOs
}

function Search-GPOsForRegistryKey {
    param (
        [string]$RegistryKey
    )

    Write-Host "Selected domain: $selectedDomain" -ForegroundColor Yellow
    Write-Host "Using credentials: $($domainCred.UserName)" -ForegroundColor Yellow

    # Get all GPOs in the domain
    $gpos = Get-GPO -All -Server $selectedDomain

    Write-Host "Number of GPOs found: $($gpos.Count)" -ForegroundColor Yellow

    # Initialize an array to hold matching GPOs
    $matchingGPOs = @()

    # Check if the Reports directory exists, create if it doesn't
    if (!(Test-Path -Path "$PSScriptRoot\Reports" -PathType Container)) {
        New-Item -ItemType Directory -Path "$PSScriptRoot\Reports"
    } else {
        # Clear existing reports
        Get-ChildItem -Path "$PSScriptRoot\Reports" -File | Remove-Item -Force
    }

    foreach ($gpo in $gpos) { # Iterate through each GPO found
        # Sanitize the GPO display name
        $sanitizedDisplayName = $gpo.DisplayName -replace '[\\/:*?"<>|]', '_'

        # Generate file paths
        $gpoReportComputerPath = "$PSScriptRoot\Reports\$sanitizedDisplayName-Computer.xml"
        $gpoReportUserPath = "$PSScriptRoot\Reports\$sanitizedDisplayName-User.xml"

        # Generate GPO reports
        $gpoReportComputer = Get-GPOReport -Guid $gpo.Id -ReportType Xml -Path $gpoReportComputerPath
        $gpoReportUser = Get-GPOReport -Guid $gpo.Id -ReportType Xml -Path $gpoReportUserPath

        # Load the XML reports
        $xmlComputer = [xml](Get-Content -Path $gpoReportComputerPath)
        $xmlUser = [xml](Get-Content -Path $gpoReportUserPath)

        # Search for the registry key in Computer Configuration
        $foundInComputer = $xmlComputer.GPO.Computer.Registry.Policy | Where-Object {
            $_.Key -like "*$RegistryKey*" -or $_.Value -like "*$RegistryKey*"
        }

        # Search for the registry key in User Configuration
        $foundInUser = $xmlUser.GPO.User.Registry.Policy | Where-Object {
            $_.Key -like "*$RegistryKey*" -or $_.Value -like "*$RegistryKey*"
        }

        if ($foundInComputer -or $foundInUser) {
            Write-Host "Registry key '$RegistryKey' found in GPO: $($gpo.DisplayName)" -ForegroundColor Green
            $matchingGPOs += $gpo
        }
    }

    # Return all matching GPOs
    return $matchingGPOs
}

function Search-GPOsForAllLocations {
    param (
        [string]$SearchString
    )

    Write-Host "Selected domain: $selectedDomain" -ForegroundColor Yellow
    Write-Host "Using credentials: $($domainCred.UserName)" -ForegroundColor Yellow

    # Get all GPOs in the domain
    $gpos = Get-GPO -All -Server $selectedDomain

    Write-Host "Number of GPOs found: $($gpos.Count)" -ForegroundColor Yellow

    # Initialize an array to hold matching GPOs
    $matchingGPOs = @()

    # Check if the Reports directory exists, create if it doesn't
    if (!(Test-Path -Path "$PSScriptRoot\Reports" -PathType Container)) {
        New-Item -ItemType Directory -Path "$PSScriptRoot\Reports"
    } else {
        # Clear existing reports
        Get-ChildItem -Path "$PSScriptRoot\Reports" -File | Remove-Item -Force
    }

    foreach ($gpo in $gpos) { # Iterate through each GPO found
        # Sanitize the GPO display name
        $sanitizedDisplayName = $gpo.DisplayName -replace '[\\/:*?"<>|]', '_'

        # Generate file paths
        $gpoReportComputerPath = "$PSScriptRoot\Reports\$sanitizedDisplayName-Computer.xml"
        $gpoReportUserPath = "$PSScriptRoot\Reports\$sanitizedDisplayName-User.xml"

        # Generate GPO reports
        $gpoReportComputer = Get-GPOReport -Guid $gpo.Id -ReportType Xml -Path $gpoReportComputerPath
        $gpoReportUser = Get-GPOReport -Guid $gpo.Id -ReportType Xml -Path $gpoReportUserPath

        # Load the XML reports
        $xmlComputer = [xml](Get-Content -Path $gpoReportComputerPath)
        $xmlUser = [xml](Get-Content -Path $gpoReportUserPath)

        # Search in Policy Name
        if ($gpo.DisplayName -like "*$SearchString*") {
            Write-Host "Policy Name '$SearchString' found in GPO: $($gpo.DisplayName)" -ForegroundColor Green
            $matchingGPOs += $gpo
            continue
        }

        # Search in GUID
        if ($gpo.Id -like "*$SearchString*") {
            Write-Host "GUID '$SearchString' found in GPO: $($gpo.DisplayName)" -ForegroundColor Green
            $matchingGPOs += $gpo
            continue
        }

        # Search for the registry key in Computer Configuration
        $foundInComputer = $xmlComputer.GPO.Computer.Registry.Policy | Where-Object {
            $_.Key -like "*$SearchString*" -or $_.Value -like "*$SearchString*"
        }

        # Search for the registry key in User Configuration
        $foundInUser = $xmlUser.GPO.User.Registry.Policy | Where-Object {
            $_.Key -like "*$SearchString*" -or $_.Value -like "*$SearchString*"
        }

        # Search in ExtensionData for Computer Configuration
        $foundInComputerExtensions = $xmlComputer.GPO.Computer.ExtensionData.Extension | Where-Object {
            $_.InnerXml -like "*$SearchString*"
        }

        # Search in ExtensionData for User Configuration
        $foundInUserExtensions = $xmlUser.GPO.User.ExtensionData.Extension | Where-Object {
            $_.InnerXml -like "*$SearchString*"
        }

        # Search in Administrative Templates (if applicable)
        $foundInComputerAdmTemplates = $xmlComputer.GPO.Computer.AdministrativeTemplates.Policy | Where-Object {
            $_.Name -like "*$SearchString*" -or $_.Value -like "*$SearchString*"
        }

        $foundInUserAdmTemplates = $xmlUser.GPO.User.AdministrativeTemplates.Policy | Where-Object {
            $_.Name -like "*$SearchString*" -or $_.Value -like "*$SearchString*"
        }

        # Combine all results
        if ($foundInComputer -or $foundInUser -or $foundInComputerExtensions -or $foundInUserExtensions -or $foundInComputerAdmTemplates -or $foundInUserAdmTemplates) {
            Write-Host "Search string '$SearchString' found in GPO: $($gpo.DisplayName)" -ForegroundColor Green
            $matchingGPOs += $gpo
        }
    }

    # Return all matching GPOs
    return $matchingGPOs
}

# Set Environment Values
[console]::windowwidth=93;
[console]::windowheight=35;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.BackgroundColor="black";
$host.UI.RawUI.WindowTitle="GPO Search V3.5";

$PSModuleAutoLoadingPreference = "All"
$WarningPreference = "SilentlyContinue"
$ErrorActionPreference = "SilentlyContinue"

$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"


Clear-Host

# Header
$BANNER1 = @"
  __________________    _____         _________                               .__      
 /  _____/\______   \  /     \       /   _____/  ____  _____  _______   ____  |  |__   
/   \  ___ |     ___/ /   |   \      \_____  \ _/ __ \ \__  \ \_  __ \_/ ___\ |  |  \  
\    \_\  \|    |    /    |    \     /        \\  ___/  / __ \_|  | \/\  \___ |   Y  \ 
 \______  /|____|    \_______  /    /_______  / \___  >(____  /|__|    \___  >|___|  / 
        \/                   \/             \/      \/      \/             \/      \/  

"@

Write-Host ""
Write-Host ""
Write-CenteredText $BANNER1 -ForegroundColor Blue
Write-Host ""
Write-Host ""
Write-Host ("*" * $hostWidth) -ForegroundColor Red
Write-Host ""

# Domain selection and authentication
Write-Host "                         Select the domain to search GPO settings in:"
for ($i = 0; $i -lt $domains.Count; $i++) {
    Write-Host "                                  " -NoNewline
    Write-Host ($i + 1) ":" $domains[$i]
}
Write-Host ""
$selectionPrompt = "                                Enter the domain number [$defaultSelection]"
$selection = Read-Host $selectionPrompt

if (-not $selection) {
    $selection = $defaultSelection
}

# Explicitly cast $selection to an integer
$selection = [int]$selection

if ($selection -lt 1 -or $selection -gt $domains.Count) {
    Write-CenteredText "Invalid selection. Please enter a number between 1 and $($domains.Count)." -ForegroundColor Red
    Exit
} else {
    Write-CenteredText "Selected domain: $($domains[$selection - 1])" -ForegroundColor Green
}

$selectedDomain = $domains[$selection - 1]
Write-Host "                               " -NoNewline
$domainCred = Get-Credential -Message "Please enter Admin credentials for $selectedDomain"

Write-Host ""
Write-CenteredText "*********************************************************************"
Write-Host ""
Write-CenteredText "*** Search for a Policy, GUID, or Registry Key ***" -ForegroundColor Red
Write-Host ""
Write-CenteredText "Enter any search string (Policy Name, GUID, Registry Key, etc.)" -ForegroundColor Yellow
Write-Host ""
Write-CenteredText "To find the Policy info of the setting you want to change,"
Write-CenteredText "GO HERE:"
Write-Host ""
Write-CenteredText "GPO settings search:"
Write-CenteredText "https://gpsearch.azurewebsites.net/" -ForegroundColor Blue
Write-Host ""
Write-CenteredText "If you are looking for a specific policy, you want to"
Write-CenteredText "use the name of the policy as it appears in the GPO."
Write-Host ""
Write-CenteredText "Example: Enable screen saver (No Quotes)" -ForegroundColor Yellow
Write-Host ""
Write-CenteredText "The script will then search through all GPOs in the domain and return"
Write-CenteredText "the Group Policy Object name where the specified policy is set."
Write-Host ""
Write-CenteredText "*********************************************************************"
Write-Host ""

# Get the search string from the user
$SearchString = Read-Host "Enter the search string (Policy Name, GUID, Registry Key, etc.)"

# Execute Search
Try {
    Clear-Host
    Write-Host ""
    Write-CenteredText "Searching for: $SearchString" -ForegroundColor Yellow
    Write-CenteredText "Please be patient. This may take some time." -ForegroundColor DarkMagenta
    Write-Host ""

    # Call the unified search function
    $gpo = Search-GPOsForAllLocations -SearchString $SearchString
    if ($null -ne $gpo) {
        Write-Host ""
        Write-CenteredText "Search string found!" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host ""
        Write-CenteredText "Search string '$SearchString' not found in any GPO." -ForegroundColor Red
        Write-Host ""
    }
} Catch {
    Write-CenteredText "An error occurred: $_" -ForegroundColor Red
}

Write-CenteredText "Press any key to exit"
Read-Host

#Script Execution Stats
$endTime = Get-Date
# Calculate time difference between start and end time
$Duration = New-TimeSpan -Start $StartTime -End $EndTime
#Format the duration time as dd:HH:mm:ss
$formattedDuration = "{0:D2}:{1:D2}:{2:D2}:{3:D2}" -f $Duration.Days, $Duration.Hours, $Duration.Minutes, $Duration.Seconds
Write-Host "Script Duration time (dd:HH:mm:ss):" -NoNewline
Write-Host "  $formattedDuration" -foregroundcolor "yellow"
