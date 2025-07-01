<###############################################
######                                     #####
###### Kern County Administrator's Console #####
######       By Brian Lowry - 2024         #####
######                                     #####
################################################
This script presents the user with a menu featuring options to
execute many common administrative tasks and options to generate
reports for Environment Health Assessment.

Selecting each option will spawn a new PS window and execute a
linked script that will prompt the admin for required values and
execute the function.
#>

# Region MainMenu
# The code below uses a loop to continually prompt the user to select an option from a list of options until the user selects the Exit option:
# Set Environment Values
    [console]::windowwidth=72;
    [console]::windowheight=100;
    [console]::bufferwidth=[console]::windowwidth;
$host.UI.RawUI.WindowTitle="Kern County Administrator's Console";

# Initialize the $exit variable to $false
$exit = $false

# Ensure necessary modules load when needed:
$PSModuleAutoLoadingPreference = "All"

# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {
    # Display a list of options to the user
    #Region Header
    Clear-Host
    Write-Host ""
    Write-Host "  v9  " -ForegroundColor White -NoNewline
    Write-Host "|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|" -BackgroundColor DarkRed -ForegroundColor Blue
    Write-Host "      " -NoNewline
    Write-Host "|                                                           |" -BackgroundColor DarkRed -ForegroundColor Blue
    Write-Host "      " -NoNewline
    Write-Host "|" -BackgroundColor DarkRed -ForegroundColor Blue -NoNewline
    Write-Host "                         Welcome to                        "  -BackgroundColor DarkRed -ForegroundColor White -NoNewline
    Write-Host "|" -BackgroundColor DarkRed -ForegroundColor Blue
    Write-Host "      " -NoNewline
    Write-Host "|" -BackgroundColor DarkRed -ForegroundColor Blue -NoNewline
    Write-Host "            Kern County Administrator's Console            "  -BackgroundColor DarkRed -ForegroundColor White -NoNewline
    Write-Host "|" -BackgroundColor DarkRed -ForegroundColor Blue
    Write-Host "      " -NoNewline
    Write-Host "|                                                           |" -BackgroundColor DarkRed -ForegroundColor Blue
    Write-Host "      " -NoNewline
    Write-Host "|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|" -BackgroundColor DarkRed -ForegroundColor Blue
    Write-Host ""
    Write-Host "  Please select a task from the menu below by typing the option number." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please select from the following options:" -ForegroundColor White   -BackgroundColor DarkRed
    Write-Host "   TOOLS:                                " -ForegroundColor Yellow  -BackgroundColor blue
    Write-Host "    1. Start a Timer" -ForegroundColor Blue
    Write-Host "    2. Find Duplicate Files" -ForegroundColor Blue
    Write-Host "    3. File Renamer (By Date)" -ForegroundColor Blue
    Write-Host "    4. Ping Host" -ForegroundColor Blue
    Write-Host "    5. Install WinGet and MS PowerShell Core 7" -ForegroundColor Blue
    Write-Host "    6. Open New Windows PowerShell 5 Window" -ForegroundColor Blue
    Write-Host "    7. Open New Microsoft Powershell 7 Window" -ForegroundColor Blue
    Write-Host "    8. Open New Windows CMD Console" -ForegroundColor Blue
    Write-Host "    9. The Media Collector" -ForegroundColor Blue
    Write-Host "    10. Check for PS remoting enabled" -ForegroundColor Blue
    Write-Host "    11. DNS Record Check" -ForegroundColor Blue
    Write-Host "    12. Perform Packet Capture(requires WireShark)" -ForegroundColor Blue
    Write-Host ""

    Write-Host "   AD ACCOUNT OPERATIONS:                " -ForegroundColor Yellow  -BackgroundColor blue
    Write-Host "    20. Search AD Account" -ForegroundColor Blue
    Write-Host "    21. Reset Password" -ForegroundColor Blue
    Write-Host "    22. Unlock AD Account" -ForegroundColor Blue
    Write-Host "    23. Enable AD Account" -ForegroundColor Blue
    Write-Host "    24. Disable AD Account" -ForegroundColor Blue
    Write-Host "    25. License User for M365" -ForegroundColor Blue
    Write-Host "    26. Remove O365 License" -ForegroundColor Blue
    Write-Host "    27a. List Stale User accounts" -ForegroundColor Blue
    Write-Host "    27b. Export list of stale user accounts" -ForegroundColor Blue
    Write-Host "    28a. List Stale computer accounts" -ForegroundColor Blue
    Write-Host "    28b. Export list of stale computer accounts" -ForegroundColor Blue
    Write-Host "    29a. GPO Report" -ForegroundColor Blue
    Write-Host "    29b. GPO Setting Search" -ForegroundColor Blue
    Write-Host "    29c. GPupdate" -ForegroundColor Blue  
    Write-Host ""
   
    Write-Host "   EXCHANGE OPERATIONS:                  " -ForegroundColor Yellow  -BackgroundColor blue
    Write-Host "    30. Connect to On-Prem Exchange" -ForegroundColor Blue
    Write-Host "    31. Connect to Exchange-Online" -ForegroundColor Blue
    Write-Host "    32. Verify and Set Litigation Hold" -ForegroundColor Blue
    Write-Host "    33. Add license, create mailboxes, enable Lit hold" -ForegroundColor Blue
    Write-Host "    34. Send an Email" -ForegroundColor Blue
    Write-Host ""

    Write-Host "   PRINTER OPERATIONS:                   " -ForegroundColor Yellow  -BackgroundColor blue
    Write-Host "    40. Restart Print Spooler" -ForegroundColor Blue
    Write-Host "    41. Add to Anonymous Proxy" -ForegroundColor Blue
    Write-Host ""

    Write-Host "   Console Launchers:                    " -ForegroundColor Yellow  -BackgroundColor blue
    Write-Host "    50. ADUC" -ForegroundColor Blue
    Write-Host "    51. DHCP" -ForegroundColor Blue
    Write-Host ""
   
    Write-Host "   MISCELLANEOUS:                        "  -ForegroundColor Yellow  -BackgroundColor blue
    Write-Host "    92. Take the Red Pill..." -ForegroundColor Blue
    Write-Host "    93. Joke Generator" -ForegroundColor Blue
    Write-Host "    94. Gimme a Better Beat!" -ForegroundColor Blue
    Write-Host "    95. Gimme a Beat!" -ForegroundColor Blue
    Write-Host "    96. Gimme a Funky Beat!" -ForegroundColor Blue
    Write-Host "    97. The Decider" -ForegroundColor Blue
    Write-Host "    98. Generation Evaluator" -ForegroundColor Blue
    Write-Host "    99. Emoji Test (MS Terminal only)" -ForegroundColor blue
    Write-Host ""
    Write-Host "    100. Exit" -ForegroundColor DarkRed


  # Prompt the user for a selection
  $selection = Read-Host

  # Use a switch statement to execute different codes based on the user's selection
    switch ($selection) {
        <# This is a template for adding additional scripts:
        X {
            # If the user selects option 3, display a message and do something for option 3
            Write-Output "You selected <Name>."
            # Do something for option 3
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="DarkGrey";
                $host.UI.RawUI.ForegroundColor="Darkblue";
                $host.UI.RawUI.WindowTitle="<Title>";
                Clear-host;
            #Execute script
                & "C:\Scripts\AP_Scripts\<script.ps1>"
            }';
        }#>

        1 {   # ToDo: add a stop command to the timer, add delay between pings.
            # If the user selects option 1, display a message and do something for option 1
            Write-Output "You selected start a timer."
            # Do something for option 1
            # Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
                # Set Environment Values
                [console]::windowwidth = 36;
                [console]::windowheight = 3;
                [console]::bufferwidth = [console]::windowwidth;
                $host.UI.RawUI.BackgroundColor = "black";
                $host.UI.RawUI.ForegroundColor = "blue";
                $host.UI.RawUI.WindowTitle = "Process Timer";
                [System.Console]::CursorVisible = $false;  # Hide the cursor

                # Execute Stopwatch
                $stopWatch = [system.diagnostics.stopwatch]::startNew();
                while ($True) {
                    $ts = $stopwatch.Elapsed;
                    $elapsedTime = "{0:00}:{1:00}:{2:00}" -f $ts.Hours, $ts.Minutes, $ts.Seconds;
                    Clear-Host;
                    Write-Host "";
                    Write-Host "    Current duration is " -NoNewline -ForegroundColor Blue;
                    Write-Host "$elapsedTime" -ForegroundColor DarkRed;
                    Start-Sleep -Seconds 1
                }
            }';
        }

        2 {
            # If the user selects option 2, display a message and do something for option 2
            Write-Output "You selected the Duplicate Finder."
            # Do something for option 2
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
                #Set Environment Values
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Duplicate Finder";
                Clear-host
                
                #Execute script
                & ".\AP_Scripts\DuplicateFinder.ps1"
            }';
        }

        3 {
            # If the user selects option 3, display a message and do something for option 3
            Write-Output "You selected File Renamer."
            # Do something for option 3
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="File Renamer";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\File Renamer by Date.ps1"
            }';
        }

        4 {
            # If the user selects option 3, display a message and do something for option 3
            Write-Output "You selected Ping Host."
            # Do something for option 3
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Ping Host";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Ping HostV2.ps1"
            }';
        }

        5 {
            # If the user selects option 5, display a message and do something for option 5
            Write-Output "Install WinGet and MS PowerShell Core 7."
            # Do something for option 5
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Install WinGet and MS PowerShell Core 7";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\GPupdate.ps1"
            }';
        }

        6 {
            # If the user selects option 3, display a message and do something for option 3
            Write-Output "You selected Spawn new Windows PowerShell 5 Window."
            # Do something for option 3
            Clear-Host
            ##### Spawn a New PS Window #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=65;
                [console]::windowheight=50;
                [console]::bufferwidth=[console]::windowwidth;
                #$host.UI.RawUI.BackgroundColor="blue";
                #$host.UI.RawUI.ForegroundColor="yellow";
                $host.UI.RawUI.WindowTitle="Powershell 5";
                Clear-host;
                write-host "Powershell 5 - Enter your command:" -ForegroundColor Yellow;
            }';
        }

        7 {
            # If the user selects option 3, display a message and do something for option 3
            Write-Output "You selected Spawn new Microsoft PowerShell Window."
            # Do something for option 3
            Clear-Host
            ##### Spawn a New PS Window #####
            invoke-expression 'cmd /c start pwsh.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=65;
                [console]::windowheight=50;
                [console]::bufferwidth=[console]::windowwidth;
                #$host.UI.RawUI.BackgroundColor="blue";
                #$host.UI.RawUI.ForegroundColor="yellow";
                $host.UI.RawUI.WindowTitle="Powershell 7";
                Clear-host;
                write-host "Powershell 7 - Enter your command:" -ForegroundColor Yellow;
            }';
        }
        
        8 {
            # If the user selects option 3, display a message and do something for option 3
            Write-Output "You selected Spawn new CMD console."
            # Do something for option 3
            Clear-Host
            ##### Spawn a New PS Window #####
            invoke-expression 'cmd /c start cmd.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=65;
                [console]::windowheight=50;
                [console]::bufferwidth=[console]::windowwidth;
                #$host.UI.RawUI.BackgroundColor="black";
                #$host.UI.RawUI.ForegroundColor="white";
                $host.UI.RawUI.WindowTitle="Windows Command";
                Clear-host;
                write-host "CMD - Enter your command:" -ForegroundColor Yellow;
            }';
        }

        9 {
            # If the user selects option 3, display a message and do something for option 3
            Write-Output "You selected The Media Collector."
            # Do something for option 3
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Media Collector";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Media_Collector_V.2.ps1"
            }';
        }

        10 {
            # If the user selects option 10, display a message and do something for option 10
            Write-Output "Check for PS remoting enabled"
            # Do something for option 10
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Checking if PS remoting is enabled";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Check_remoting_enabledv2.ps1"
            }';
        }

        11 {
            # If the user selects option 11, display a message and do something for option 11
            Write-Output "DNS Record Check"
            # Do something for option 11
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="DNS Record Check";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\DNS-PTR-Record-Check.ps1"
            }';
        }

        12 {
            # If the user selects option 12, display a message and do something for option 12
            Write-Output "Perform Packet Capture"
            # Do something for option 12
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Perform Packet Capture";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\NetSHTrace-packet_capture.ps1"
            }';
        }

        20 {
            # If the user selects option 20, display a message and do something for option 20
            Write-Output "You selected Search AD Account."
            # Do something for option 20
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Searching for an AD Account";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Search-ADAccount.ps1"
            }';
        }

        21 {
            # If the user selects option 21, display a message and do something for option 21
            Write-Output "You selected Reset Password."
            # Do something for option 21
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=50;
                [console]::windowheight=15;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Reset Password";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Password_reset.ps1"
            }';
        }

        22 {
            # If the user selects option 22, display a message and do something for option 22
            Write-Output "You selected Unlock Account."
            # Do something for option 22
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=50;
                [console]::windowheight=15;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Unlock Account";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Unlock_Account.ps1"
            }';
        }

        23 {
            # If the user selects option 23, display a message and do something for option 23
            Write-Output "You selected Enable AD Account."
            # Do something for option 23
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Enable AD Account";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Enable_AD_Account.ps1"
            }';
        }

        24 {
            # If the user selects option 24, display a message and do something for option 24
            Write-Output "You selected Disable AD Account."
            # Do something for option 24
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Disable AD Account";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Disable_AD_Account.ps1"
            }';
        }

        25 {
            # If the user selects option 25, display a message and do something for option 25
            Write-Output "You selected to license a user for M365."
            # Do something for option 25
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="License User for M365";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Add user to O365 license group.ps1"
            }';
        }

        26 {
            # If the user selects option 26, display a message and do something for option 26
            Write-Output "You selected Remove M365 License."
            # Do something for option 26
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Remove M365 License";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Remove M365 License2.ps1"
            }';
        }

        27a {
            # If the user selects option 27a, display a message and do something for option 27a
            Write-Output "You selected List Stale Users."
            # Do something for option 27a
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="List Stale Users";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\List Stale Users.ps1"
            }';
        }
        
        27b {
            # If the user selects option 27b, display a message and do something for option 27b
            Write-Output "You selected Export list of stale user accounts."
            # Do something for option 28a
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Export list of stale user accounts";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Export_Stale_Users_List.ps1"
            }';
        }

        28a {
            # If the user selects option 28a, display a message and do something for option 28a
            Write-Output "You selected List Stale Computers."
            # Do something for option 28a
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="List Stale Computers";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\List Stale Computers.ps1"
            }';
        }
        
        28b {
            # If the user selects option 28b, display a message and do something for option 28b
            Write-Output "You selected Export Stale Computers."
            # Do something for option 28b
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Export Stale Computers";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Export_Stale_Computers_List.ps1"
            }';
        }

        29a {
            # If the user selects option 29a, display a message and do something for option 29a
            Write-Output "Generate GPO report"
            Start-Sleep -Seconds 3
            Wait 
            # Do something for option 29a
            Clear-Host
            ##### Spawn a New PS Window #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=65;
                [console]::windowheight=50;
                [console]::bufferwidth=[console]::windowwidth;
                #$host.UI.RawUI.BackgroundColor="blue";
                #$host.UI.RawUI.ForegroundColor="yellow";
                $host.UI.RawUI.WindowTitle="Generate GPO report";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\GPO Report.ps1"
            }';
        }

        29b {
            # If the user selects option 29b, display a message and do something for option 29b
            Write-Output "GPO Setting Search"
            Start-Sleep -Seconds 3
            Wait 
            # Do something for option 29b
            Clear-Host
            ##### Spawn a New PS Window #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                #[console]::windowwidth=65;
                #[console]::windowheight=50;
                #[console]::bufferwidth=[console]::windowwidth;
                #$host.UI.RawUI.BackgroundColor="blue";
                #$host.UI.RawUI.ForegroundColor="yellow";
                #$host.UI.RawUI.WindowTitle="GPO Setting Search";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\GPO_SearchV2.2.ps1"
            }';
        }

        29c {
            # If the user selects option 29c, display a message and do something for option 29c
            Write-Output "You selected GPupdate."
            # Do something for option 29c
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="GPupdate";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\GPupdate.ps1"
            }';
        }

        30 {
            # If the user selects option 30, display a message and do something for option 30
            Write-Output "You selected Connect to On-Prem Exchange."
            # Do something for option 30
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=78;
                [console]::windowheight=35;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Connecting to On-Prem Exchange";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Connect to KC on-prem Exchange.ps1"
            }';
        }

        31 {
            # If the user selects option 31, display a message and do something for option 31
            Write-Output "You selected Connect to Exchange-Online."
            # Do something for option 31
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Connect to Exchange-Online";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Connect to Exchange-Online.PS1"
            }';
        }

        32 {
            # If the user selects option 32, display a message and do something for option 32
            Write-Output "You selected Verify Litigation Hold."
            # Do something for option 32
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Verify and Set Litigation Hold";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\litholdtest.ps1"
            }';
        }

        33 {
            # If the user selects option 33, display a message and do something for option 33
            Write-Output "You selected Create Remote Mailbox."
            # Do something for option 33
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=77;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Create Remote Mailbox";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Create On-Prem exchange mailbox with litigation hold enabled.ps1"
            }';
        }

        34 {
            # If the user selects option 34, display a message and do something for option 34
            Write-Output "You selected Send an Email."
            # Do something for option 34
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=77;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Send an Email";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Send_Email.ps1"
            }';
        }

        40 {
            # If the user selects option 40, display a message and do something for option 40
            Write-Output "Restart Print Spooler"
            # Do something for option 40
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=77;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Restart Print Spooler";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\restart_spooler.ps1"
            }';
        }

        41 {
            # If the user selects option 41, display a message and do something for option 41
            Write-Output "Add to Anonymous Proxy"
            # Do something for option 41
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=77;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Add to Anonymous Proxy";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Add_Printer_to_anon_proxy_lists.ps1"
            }';
        }

        50 {
            # If the user selects option 50, display a message and do something for option 50
            Write-Output "ADUC Launcher"
            # Do something for option 50
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=77;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="ADUC Launcher V1.1";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\ADUCv1.1.ps1"
            }';
        }

        51 {
            # If the user selects option 51, display a message and do something for option 51
            Write-Output "DHCP Launcher"
            # Do something for option 51
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=77;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="DHCP Launcher";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Universal_DHCP_LauncherV1.5.ps1"
            }';
        }

        52 {
            # If the user selects option 52, display a message and do something for option 52
            Write-Output "Connect to Azure"
            # Do something for option 52
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=77;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Connect to Azure";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Connect to Azure.ps1"
            }';
        }

        92 {
            # If the user selects option 92, display a message and do something for option 92
            Write-Output "Take the Red Pill..."
            # Do something for option 92
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=77;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Take the Red Pill...";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\A_messageV0.3.PS1"
            }';
        }

        93 {
            # If the user selects option 93, display a message and do something for option 93
            Write-Output "Joke Generator"
            Start-Sleep -Seconds 3
            Wait 
            # Do something for option 93
            Clear-Host
            ##### Spawn a New PS Window #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=65;
                [console]::windowheight=50;
                [console]::bufferwidth=[console]::windowwidth;
                #$host.UI.RawUI.BackgroundColor="blue";
                #$host.UI.RawUI.ForegroundColor="yellow";
                $host.UI.RawUI.WindowTitle="Joke Generator V2";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Joke GeneratorV2.ps1"
            }';
        }

        94 {
            # If the user selects option 94, display a message and do something for option 94
            Write-Output "Gimme a better beat!"
            Start-Sleep -Seconds 3
            Wait 
            # Do something for option 94
            Clear-Host
            ##### Spawn a New PS Window #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=65;
                [console]::windowheight=50;
                [console]::bufferwidth=[console]::windowwidth;
                #$host.UI.RawUI.BackgroundColor="blue";
                #$host.UI.RawUI.ForegroundColor="yellow";
                $host.UI.RawUI.WindowTitle="Gimme a better beat!";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\A Better Funky Beat Script.ps1"
            }';
        }

        95 {
            # If the user selects option 95, display a message and do something for option 95
            Write-Output "Gimme a beat!"
            Start-Sleep -Seconds 3
            Wait 
            # Do something for option 95
            Clear-Host
            ##### Spawn a New PS Window #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=65;
                [console]::windowheight=50;
                [console]::bufferwidth=[console]::windowwidth;
                #$host.UI.RawUI.BackgroundColor="blue";
                #$host.UI.RawUI.ForegroundColor="yellow";
                $host.UI.RawUI.WindowTitle="Gimme a beat!";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\House Music Script.ps1"
            }';
        }

        96 {
            # If the user selects option 3, display a message and do something for option 3
            Write-Output "Gimme a Funky beat!"
            Start-Sleep -Seconds 3
            Wait 
            # Do something for option 3
            Clear-Host
            ##### Spawn a New PS Window #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=65;
                [console]::windowheight=50;
                [console]::bufferwidth=[console]::windowwidth;
                #$host.UI.RawUI.BackgroundColor="blue";
                #$host.UI.RawUI.ForegroundColor="yellow";
                $host.UI.RawUI.WindowTitle="Gimme a funky beat!";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Funky Beat Script.ps1"
            }';
        }

        97 {
            # If the user selects option 3, display a message and do something for option 3
            Write-Output "You selected The Decider."
            # Do something for option 3
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="The Decider";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\decider.ps1"
            }';
        }

        98 {
            # If the user selects option 3, display a message and do something for option 3
            Write-Output "You selected The Generation Evaluator."
            # Do something for option 3
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
            #Set Environment Values
                #cd -path $env:homedrive/scripts/;
                [console]::windowwidth=100;
                [console]::windowheight=30;
                [console]::bufferwidth=[console]::windowwidth;
                $host.UI.RawUI.BackgroundColor="black";
                $host.UI.RawUI.ForegroundColor="blue";
                $host.UI.RawUI.WindowTitle="Generation Evaluator";
                Clear-host;
            #Execute script
                & ".\AP_Scripts\Generation Evaluator.ps1"
            }';
        }

        99 {
            # If the user selects option 3, display a message and do something for option 3
            Write-Output "You selected the Emoji Test."
            # Do something for option 3
            Clear-Host
            ##### Spawn a New PS Window and execute commands #####
            invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
                #Set Environment Values
                    #cd -path $env:homedrive/scripts/;
                    [console]::windowwidth=100;
                    [console]::windowheight=30;
                    [console]::bufferwidth=[console]::windowwidth;
                    $host.UI.RawUI.BackgroundColor="black";
                    $host.UI.RawUI.ForegroundColor="blue";
                    $host.UI.RawUI.WindowTitle="Emoji Test";
                    Clear-host;
                #Execute script
                    & ".\AP_Scripts\emoji_test-voice.ps1"
            }';
        }

        100 {
            # If the user selects option 100, set $exit to $true to exit the loop
            $exit = $true
        }
        default { Write-Host "Invalid selection. Please try again." }  
    }
}