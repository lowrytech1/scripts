#ToDo: Add "Complete" chime to the end of the script
#ToDo: Verify it works with all 3 policy types (Security, Registry, SoftwareInstallation), and user config policies.
#ToDo: Add a search option for "Domain".  This will allow the user to search for a setting in a specific domain.
#ToDo: add the jeopardy jingle to play during search?
param (
    [string]$SettingName,
    [string]$GUID
)

# Define the function to search settings in GPOs
function Search-GPOsForSetting {
    param (
        [string]$SettingName
    )

    # Import the GroupPolicy module
    Import-Module GroupPolicy

    # Get all GPOs in the domain
    $gpos = Get-GPO -All

    # Initialize progress bar variables
    $GPOcount = $gpos.count
    $CurrentIndex = 0

    # Initialize an array to hold matching GPOs
    $matchingGPOs = @()

    # Search the GPOs for the specified setting
    foreach ($gpo in $gpos) {
        # Initialize the progress bar
        $CurrentIndex++
        $ProgressPercent = ($CurrentIndex / $GPOcount) * 100

        # Update the progress bar
        Write-Progress -Activity "Searching GPOs" -Status "Processing GPO $CurrentIndex of $GPOcount" -PercentComplete $ProgressPercent

        $gpoReport = Get-GPOReport -Guid $gpo.Id -ReportType Xml
        if ($gpoReport -match $SettingName) {
            Write-Host "Setting '$SettingName' found in GPO: $($gpo.DisplayName)" -ForegroundColor Green
            $matchingGPOs += $gpo
            Write-Verbose "GPO = $($gpo)"
            Invoke-Sound -soundPath 'R2D2-Happy1.wav' -errorAction SilentlyContinue
        }
    }

    # Return all matching GPOs
    return $matchingGPOs
}

# Define the function to play sounds
function Invoke-Sound {
    param (
        [string]$soundPath
    )
    $player = New-Object System.Media.SoundPlayer
    $player.SoundLocation = $soundPath
    $player.Load()
    $player.Play()
}

# Set Environment Values
[console]::windowwidth=72;
[console]::windowheight=35;
[console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.BackgroundColor="black";
$host.UI.RawUI.WindowTitle="GPO Search";

$startTime = Get-Date
$formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
Write-Host "$formattedStartTime"

$WarningPreference = "SilentlyContinue"
$errorPreference = "SilentlyContinue"

Clear-Host

# Header
Write-Host ""
Write-Host "                   " -NoNewline
Write-Host "********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                   " -NoNewline
Write-Host "********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                   " -NoNewline
Write-Host "****** GPO Setting Search ******" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                   " -NoNewline
Write-Host "********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host "                   " -NoNewline
Write-Host "********************************" -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""
Write-Host " Search Options:"
Write-Host "    1) Search by Policy Name" -ForegroundColor Green
Write-Host "    2) Search by GUID" -ForegroundColor Green
# Write-Host "3) Search by Registry Key" -ForegroundColor Green
Write-Host ""
#Read-Host "Search in this domain (FQDN):"

$Option = Read-Host " Make a selection (1 or 2) and press Enter to continue"

If ($Option -eq "1") {
    Write-Host " *********************************************************************"
    Write-Host ""
    Write-Host "            *** You want to search for the Policy Name. ***" -ForegroundColor Red
    Write-Host ""
    Write-Host ""
    Write-Host "       To find the Policy Name of the setting you want to change,"
    Write-Host "                               GO HERE:"
    Write-Host ""
    Write-Host "                          GPO settings search:"
    Write-Host "                  https://gpsearch.azurewebsites.net/" -ForegroundColor Blue
    Write-Host ""
    Write-Host "         If you are looking for a specific policy, you want to"
    Write-Host "          use the name of the policy as it appears in the GPO."
    Write-Host ""
    Write-Host "               Example: Enable screen saver (No Quotes)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host " The script will then search through all GPOs in the domain and return"
    Write-Host "    the Group Policy Object name where the specified policy is set."
    Write-Host " *********************************************************************"
    Write-Host ""
    
    # Get the setting name from the user if not provided as a parameter
    if (-not $SettingName) {
        Write-Host " Enter the " -ForegroundColor Green -NoNewline
        Write-Host "Policy Name" -ForegroundColor Red -NoNewline
        write-Host " to search for:" -ForegroundColor Green #-NoNewline
        $SettingName = Read-Host " Policy Name"
    }
    # Execute Search
    Try {
        Clear-Host
        Write-Host "Searching for Policy: $SettingName" -ForegroundColor Yellow
        Write-Host ""
        Write-Host ""
        Write-Host "                   " -NoNewline
        Write-Host "********************************" -ForegroundColor yellow -BackgroundColor Blue
        Write-Host "                   " -NoNewline
        Write-Host "********************************" -ForegroundColor yellow -BackgroundColor Blue
        Write-Host "                   " -NoNewline
        Write-Host "****** GPO Setting Search ******" -ForegroundColor yellow -BackgroundColor Blue
        Write-Host "                   " -NoNewline
        Write-Host "********************************" -ForegroundColor yellow -BackgroundColor Blue
        Write-Host "                   " -NoNewline
        Write-Host "********************************" -ForegroundColor yellow -BackgroundColor Blue
        Write-Host ""
        Write-Host ""
        Write-Host "                       Please be very patient." -ForegroundColor DarkMagenta
        Write-Host "   It will take some time to search through all $GPOcount GPOs in the domain" -ForegroundColor DarkMagenta
        Write-Host "                            (~10-15 min)" -ForegroundColor DarkMagenta
        Write-Host ""
        
        # Call the function with the provided setting name
        $gpo = Search-GPOsForSetting -SettingName $SettingName
        if ($null -ne $gpo) {
            Write-Host ""
            Write-Host "Policy found!" -ForegroundColor Green
            Write-Host ""
        } else {
            Write-Host ""
            Write-Host "Setting '$SettingName' not found in any GPO." -ForegroundColor Red
            Write-Host ""
            Invoke-Sound -soundPath 'R2D2-Error3.wav' -errorAction SilentlyContinue
        }
    } Catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
        Invoke-Sound -soundPath 'R2D2-Error1.wav' -errorAction SilentlyContinue
    }
    # Complete the progress bar
    Write-Progress -Activity "Searching GPO settings" -Completed

} Else {
    Write-Host " *********************************************************************"
    Write-Host ""
    Write-Host "                *** Search for a Policy by GUID ***" -ForegroundColor Red
    Write-Host ""
    Write-Host "           Example: {31B2F340-016D-11D2-945F-00C04FB984F9}" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   This script will search through all GPOs in the domain and return"
    Write-Host "         the Group Policy Object(s) associated with the GUID."
    Write-Host ""
    Write-Host " *********************************************************************"
    Write-Host ""
    
    # Get the GUID from the user if not provided as a parameter
    if (-not $GUID) {
        Write-Host " Enter the " -ForegroundColor Green -NoNewline
        Write-Host "GUID" -ForegroundColor Red -NoNewline
        write-Host " to search for:" -ForegroundColor Green #-NoNewline
        $GUID = Read-Host " GUID"
    }

    Try {
        # Execute the search and report findings
        $gpo = Get-GPO -Guid $GUID # -Domain $Domain
        if ($null -ne $gpo) {
            Write-Host ""
            Write-Host "GPO found! GPO Object Name: $($gpo.DisplayName)" -ForegroundColor Green
            Write-Host ""
            Invoke-Sound -soundPath 'R2D2-Happy1.wav' -errorAction SilentlyContinue
        } else {
            Write-Host ""
            Write-Host "Could not find a GPO with GUID '$GUID'." -ForegroundColor Red
            Write-Host ""
            Invoke-Sound -soundPath 'R2D2-Error3.wav' -errorAction SilentlyContinue
        }
    } Catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
        Invoke-Sound -soundPath 'R2D2-Error2.wav' -errorAction SilentlyContinue
    }
    # Complete the progress bar
    Write-Progress -Activity "Searching GPO settings" -Completed
}

Write-Host "Press any key to exit"
Read-Host

#Script Execution Stats
$endTime = Get-Date
# Calculate time difference between start and end time
$Duration = New-TimeSpan -Start $StartTime -End $EndTime
#Format the duration time as dd:HH:mm:ss
$formattedDuration = "{0:D2}:{1:D2}:{2:D2}:{3:D2}" -f $Duration.Days, $Duration.Hours, $Duration.Minutes, $Duration.Seconds
Write-Host "Script Duration time (dd:HH:mm:ss):" -NoNewline
Write-Host "  $formattedDuration" -foregroundcolor "yellow"