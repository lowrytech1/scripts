<#
This script will search for keywords in the registry and report back the results.
ToDo:     
    Add menu: Backup, search, restore
    Add option to delete keys from txt file
        Force registry backup before deleting keys in text file
    Add registry restore option
    Increase efficiency
    
    --Add progress bar
    --Add "Open results file?" option after search completes    
    --$Subkeys and $Path are the issues, chicken or egg?

#>
Clear-Host

#Region MainMenu
# The code below uses a loop to continually prompt the user to select
# an option from a list of options until the user selects the Exit option:
# Initialize the $exit variable to $false
$exit = $false

# Ensure necessary modules load when needed:
$PSModuleAutoLoadingPreference = "All"

# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {
    # Header
    Write-Host ""
    Write-Host "                  " -NoNewline
    Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue -NoNewline
    Write-Host "  V1.2" -ForegroundColor red
    Write-Host "                  " -NoNewline
    Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "                  " -NoNewline
    Write-Host "********** Registry Tool ***********" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "                  " -NoNewline
    Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host "                  " -NoNewline
    Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
    Write-Host ""
    Write-Host ""
    # Display a list of options to the user
    Write-Host "Please select a task from the menu below by typing the option number." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please select from the following options:" -ForegroundColor White   -BackgroundColor DarkRed
    Write-Host "    1. Backup Registry" -f Blue
    Write-Host "    2. Search Registry" -f Blue
    Write-Host "    3. Restore Registry from Backup" -f Blue
    Write-Host "    4. Exit" -f Blue

    # Prompt the user for a selection
    $selection = Read-Host "Enter the number of the above option to execute"

    #################   options   ##################
    # Use a switch statement to execute different codes based on the user's selection
    switch ($selection) {
        1 {
            # If the user selects option 1, display a message and do something for option 1
            Write-Output "You selected Backup Registry."
            # Do something for option 1
            Clear-Host
            ##### execute commands #####
            # Header
            Write-Host ""
            Write-Host "                  " -NoNewline
            Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue -NoNewline
            Write-Host "  V0.4" -ForegroundColor red
            Write-Host "                  " -NoNewline
            Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "                  " -NoNewline
            Write-Host "******* Registry Backup Tool *******" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "                  " -NoNewline
            Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "                  " -NoNewline
            Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host ""
            Write-Host ""

            # Define the registry hives to back up
            $registryHives = @(
                "HKEY_LOCAL_MACHINE\SYSTEM",
                "HKEY_LOCAL_MACHINE\SOFTWARE",
                "HKEY_CURRENT_USER",
                "HKEY_CLASSES_ROOT",
                "HKEY_USERS",
                "HKEY_CURRENT_CONFIG"
            )

            # Specify the backup directory
            $backupDirectory = Read-Host "Enter the path of the destination directory"

            # Create the backup directory if it doesn't exist
            if (-not (Test-Path -Path $backupDirectory)) {
                New-Item -Path $backupDirectory -ItemType Directory
            }

            # Get the current date and time for the backup file names
            $currentDateTime = Get-Date -Format "yyyy-MM-dd_HH-mm"

            # Function to export a registry hive
            function Export-RegistryHive {
                param (
                    [string]$hive,
                    [string]$backupDirectory,
                    [string]$currentDateTime
                )

                try {
                    # Sanitize the hiveName to remove or replace special characters
                    $sanitizedHiveName = $hive -replace '[^a-zA-Z0-9]', '_'

                    # Define the backup file path
                    $hiveName = $hive -replace '\\', '_'
                    $backupFilePath = "$backupDirectory\$sanitizedHiveName-$currentDateTime.reg"

                    # Export the registry hive
                    & reg.exe export $hive $backupFilePath /y

                    Write-Host "Successfully backed up $hive to $backupFilePath" -ForegroundColor Green
                } catch {
                    Write-Host "Error backing up $hive : $_" -ForegroundColor Red
                }
            }

            # Export each registry hive
            foreach ($hive in $registryHives) {
                Write-Host "Backing up $hive..."
                Export-RegistryHive -hive $hive -backupDirectory $backupDirectory -currentDateTime $currentDateTime
                Write-Host ""
            }
            Write-Host ""
            Write-Host "Registry backup complete. Backup files are saved in $backupDirectory" -ForegroundColor Magenta
            Write-Host ""
            Read-Host "Press [ENTER] to continue..."
            Clear-Host
        }
        2 {
            # If the user selects option 2, display a message and do something for option 2
            Write-Output "You selected Search Registry."
            # Do something for option 2
            Clear-Host
            
            # Specify the output directory
            $outputFilePath = Read-Host "Enter the path of the destination directory"

            # Create the backup directory if it doesn't exist
            if (-not (Test-Path -Path $outputFilePath)) {
                New-Item -Path $outputFilePath -ItemType Directory
            }

            # Get the current date and time for the backup file names
            $startTime = Get-Date
            $TimeStamp = $startTime.ToString("MM-dd-yy HH:mm")
            
            Clear-Host

            # Header
            Write-Host ""
            Write-Host "                  " -NoNewline
            Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue -NoNewline
            Write-Host "  V0.3.4" -ForegroundColor red
            Write-Host "                  " -NoNewline
            Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "                  " -NoNewline
            Write-Host "******* Registry Search Tool *******" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "                  " -NoNewline
            Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "                  " -NoNewline
            Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host ""
            Write-Host ""

            # Prompt the user for a keyword to search for
            $keyword = Read-Host "Enter the keyword to search for in the registry"
            
            # Start search timer:
            $formattedStartTime = $startTime.ToString("MM/dd/yy HH:mm")
            Write-Host "$formattedStartTime"

            # Inform the user
            Write-Host "This can take some time, grab a coffee and relax." -ForegroundColor Yellow
            Write-Host "I'll log all my findings to:" -ForegroundColor Yellow -noNewline
            Write-Host " $outputFilePath\RegistrySearchResults- $($TimeStamp) .txt"  -ForegroundColor Blue
            Write-Host "*****************************************************************" -ForegroundColor yellow -BackgroundColor Blue

            # Define the registry paths to search
            $registryPaths = @(
                "HKLM:\Software",
                "HKCU:\Software"
            )
            write-host "Registry paths: $registryPaths"
            Write-Host ""

            # Initialize an array to store the results
            $results = @()
            write-Host "Array initialized"
            Write-Host ""

            # Get all subkeys and count 'em.
            Write-Host "Getting Registry Keys. This might Take a while..."
            $subkeys = Get-ChildItem -Path $registryPaths -Recurse -ErrorAction SilentlyContinue
            $TotalKeys = $($subkeys.Count)
            Write-Host ""
            Write-Host "Total number of keys to process: " -NoNewline  -ForegroundColor Yellow
            Write-Host "$totalKeys" -ForegroundColor Blue

            # Start the progress bar
            Write-Progress -Activity "Searching Registry for $keyword" -Status "Initializing" -PercentComplete 0
            Write-Host ""

            # Search each registry path for the keyword and update the progress bar
            Write-Host "Searching Reg Keys..." -ForegroundColor Green
            for ($i = 0; $i -lt $totalKeys; $i++) {
                $subkey = $subkeys[$i]
                Write-Progress -Activity "Searching Registry for $keyword" -Status "Processing $($subkey.PSPath)" -PercentComplete (($i / $totalKeys) * 100)
                try {
                    # Get all properties of the subkey
                    $properties = Get-ItemProperty -Path $subkey.PSPath -ErrorAction SilentlyContinue
                    foreach ($property in $properties <#.PSObject.Properties#>) {
                        if ($property.Value -like "*$keyword*") {
                            $results.Value += "Path: $($subkey.PSPath), Property: $($property.Name), Value: $($property.Value)"
                            Write-Host "Path: $($subkey.PSPath), Property: $($property.Name), Value: $($property.Value)"
                            Write-Host ""
                        }
                    }
                } catch {
                    Write-Host "Error accessing $subkey : $_" -ForegroundColor Red
                }
            }

            # Measure Script Execution time
            $endTime = Get-Date
            # Calculate time difference between start and end time
            $Duration = New-TimeSpan -Start $StartTime -End $EndTime
            # Format the duration time as dd:HH:mm:ss
            $formattedDuration = "{0:D2}:{1:D2}:{2:D2}:{3:D2}" -f $Duration.Days, $Duration.Hours, $Duration.Minutes, $Duration.Seconds
            Write-Host "Script Duration time (dd:HH:mm:ss):" -NoNewline
            Write-Host "  $formattedDuration" -ForegroundColor "yellow"
            Write-Host ""

            # Write the results to the text file
            $results | Out-File -FilePath $outputFilePath -Encoding utf8
            Write-Host "Results written to $outputFilePath"
            Write-Host ""

            # Inform the user that the search is complete
            Write-Host "Registry search complete. Results saved to $outputFilePath"
            Write-Host "Open results file? [Y][N]"
            $response = Read-Host
            if ($response -eq "Y") {
                Invoke-Expression $outputFilePath
            } 
            Write-Host ""
            read-host "press [Enter] key to continue..."
            Clear-Host
        }   
        3 {
            # If the user selects option 3, display a message and do something for option 3
            Write-Output "You selected Restore Registry from Backup."
            # Do something for option 3
            Clear-Host
            ##### execute commands #####
            # Header
            Write-Host ""
            Write-Host "                  " -NoNewline
            Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue -NoNewline
            Write-Host "  V0.1" -ForegroundColor red
            Write-Host "                  " -NoNewline
            Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "                  " -NoNewline
            Write-Host "******* Registry Restore Tool ******" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "                  " -NoNewline
            Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host "                  " -NoNewline
            Write-Host "************************************" -ForegroundColor yellow -BackgroundColor Blue
            Write-Host ""
            Write-Host ""
            # Prompt the user for the path of the backup directory
            $backupDirectory = Read-Host "Enter the path of the backup directory"

            # Get the backup files in the backup directory
            $backupFiles = Get-ChildItem -Path $backupDirectory -Filter "*.reg"
            
            # Check if there are any .reg files in the directory
            if ($backupFiles.Count -eq 0) {
                Write-Host "No .reg files found in the specified directory. Exiting." -ForegroundColor Red
                exit
            }

            # Restore each backup file
            foreach ($backupFile in $backupFiles) {
                try {
                    # Restore the backup file
                    & reg.exe import $backupFile.FullName

                    Write-Host "Successfully restored $backupFile" -ForegroundColor Green
                } catch {
                    Write-Host "Error restoring $backupFile : $_" -ForegroundColor Red
                }
            }
            Write-Host "Registry restore complete."
            Read-Host "Press [ENTER] to continue..."
            Clear-Host
        }
        4 {
            # If the user selects option 4, display a message and do something for option 4
            Clear-Host
            Write-Host "You selected Exit. Goodbye!" -ForegroundColor Yellow
            Start-Sleep -seconds 2
            clear-host
            $exit = $true
        }
    } 
}
#endregion MainMenu