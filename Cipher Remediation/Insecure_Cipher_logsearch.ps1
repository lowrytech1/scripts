<#
.SYNOPSIS
    Searches Windows event logs for specific text within specified event IDs and time range.
.DESCRIPTION
    This script allows you to search a specific Windows event log for events containing
    specified text, while filtering by event ID(s) and time range to improve performance.
    Parameters can be provided as command-line arguments or entered interactively.
.PARAMETER LogName
    The name of the Windows event log to search (System)
.PARAMETER EventID
    One or more event IDs to filter by (Best: 36880) 
.PARAMETER SearchText
    The text to search for in event messages:
    0x0002,0x0001,0x0003,0x0008,0x0005,0x0004,0x0009,0x000A,0x0013,0x0033,0x0039,0xC011,0xC013,0xC014
.PARAMETER MaxEvents
    Maximum number of events to retrieve (default: 100)
.PARAMETER StartTime
    The start time for the event search (optional)
.PARAMETER EndTime
    The end time for the event search (optional)
.EXAMPLE
    .\logsearch.ps1 -LogName System -EventID 36880 -SearchText service entered
.EXAMPLE
    .\logsearch.ps1 -LogName Application -SearchText error -StartTime 2025-04-15
#>
# Insecure Cipher Log Search Script by B.Lowry - 2025
param(
    [Parameter(Mandatory=$false)]
    [string]$LogName = System,
    
    [Parameter(Mandatory=$false)]
    [int[]]$EventID = 36880,
    
    [Parameter(Mandatory=$false)]
    [string]$SearchText = 0x0002,0x0001,0x0003,0x0008,0x0005,0x0004,0x0009,0x000A,0x0013,0x0033,0x0039,0xC011,0xC013,0xC014,
    
    [Parameter(Mandatory=$false)]
    [int]$MaxEvents = 100,
    
    [Parameter(Mandatory=$false)]
    [datetime]$StartTime,
    
    [Parameter(Mandatory=$false)]
    [datetime]$EndTime
)

function Show-AvailableLogs {
    Write-Host Retrieving available event logs with entries... -ForegroundColor Cyan
    Get-WinEvent -ListLog * -ErrorAction SilentlyContinue | 
        Where-Object { $_.RecordCount -gt 0 } | 
        Sort-Object LogName |
        Format-Table LogName, RecordCount -AutoSize
}

# Interactive prompts if parameters not provided
if (-not $LogName) {
    # Show available logs with events
    Write-Host Available logs with events: -ForegroundColor Cyan
    Show-AvailableLogs
    
    $LogName = Read-Host Enter the log name to search (e.g., Application, System, Security)
}

if (-not $SearchText) {
    $SearchText = Read-Host Enter the text to search for in event messages
}

$eventIDInput = $null
if (-not $EventID) {
    $eventIDInput = Read-Host Enter event ID(s) to filter by (comma-separated, leave blank for all)
    if ($eventIDInput) {
        $EventID = $eventIDInput -split ',' | ForEach-Object { [int]$_.Trim() }
    }
}

if ($MaxEvents -eq 100) {
    $maxEventsInput = Read-Host Enter maximum number of events to retrieve (default: 100)
    if ($maxEventsInput) {
        $MaxEvents = [int]$maxEventsInput
    }
}

if (-not $StartTime) {
    $startTimeInput = Read-Host Enter start time for search (format: yyyy-MM-dd HH:mm:ss, leave blank for no start time)
    if ($startTimeInput) {
        try {
            $StartTime = [datetime]$startTimeInput
        }
        catch {
            Write-Host Invalid date format. Using no start time filter. -ForegroundColor Yellow
        }
    }
}

if (-not $EndTime) {
    $endTimeInput = Read-Host Enter end time for search (format: yyyy-MM-dd HH:mm:ss, leave blank for current time)
    if ($endTimeInput) {
        try {
            $EndTime = [datetime]$endTimeInput
        }
        catch {
            Write-Host Invalid date format. Using current time as end time. -ForegroundColor Yellow
            $EndTime = Get-Date
        }
    }
    else {
        $EndTime = Get-Date
    }
}

# Display search parameters
Write-Host `nSearch Parameters: -ForegroundColor Cyan
Write-Host ------------------------------------- -ForegroundColor Cyan
Write-Host Log: $LogName -ForegroundColor Cyan
if ($EventID) {
    Write-Host Event ID(s): $($EventID -join ', ') -ForegroundColor Cyan
}
Write-Host Search Text: '$SearchText' -ForegroundColor Cyan
Write-Host Maximum Events: $MaxEvents -ForegroundColor Cyan
if ($StartTime) {
    Write-Host Start Time: $StartTime -ForegroundColor Cyan
}
if ($EndTime) {
    Write-Host End Time: $EndTime -ForegroundColor Cyan
}
Write-Host ------------------------------------- -ForegroundColor Cyan

try {
    # Build the filter hashtable
    $filterHashtable = @{
        LogName = $LogName
    }
    
    # Add EventID to filter if specified
    if ($EventID) {
        $filterHashtable.Add(ID, $EventID)
    }
    
    # Add time filters if specified
    if ($StartTime) {
        $filterHashtable.Add(StartTime, $StartTime)
    }
    
    if ($EndTime) {
        $filterHashtable.Add(EndTime, $EndTime)
    }
    
    # Display exact filter being used
    Write-Host Filter criteria: -ForegroundColor Cyan
    $filterHashtable.GetEnumerator() | ForEach-Object {
        Write-Host   $($_.Key): $($_.Value) -ForegroundColor Cyan
    }
    
    # Get events using the filter - DON'T limit results yet
    Write-Host Searching events, please wait... -ForegroundColor Cyan
    
    # Get events without MaxEvents first to see what's available
    $allEvents = Get-WinEvent -FilterHashtable $filterHashtable -ErrorAction Stop
    
    # Display total count of events matching filter criteria
    Write-Host Total log entries matching filter criteria: $($allEvents.Count) -ForegroundColor Cyan
    
    # Apply MaxEvents limit for search
    $allEvents = $allEvents | Select-Object -First $MaxEvents
    
    # If no events were found, exit early
    if ($allEvents.Count -eq 0) {
        Write-Host No log entries found matching the filter criteria. -ForegroundColor Yellow
        return
    }
    
    # Use a reliable case-insensitive search
    $searchTerms = $SearchText -split ',' | ForEach-Object { $_.Trim() }
    if ($searchTerms.Count -gt 1) {
        Write-Host Searching for any of these terms: '$($searchTerms -join ', ')') -ForegroundColor Cyan
    } else {
        Write-Host Searching for text: '$SearchText' -ForegroundColor Cyan
    }
    $events = @()
    
    foreach ($evt in $allEvents) {
        # Split search text by commas and search for any matching term
        $searchTerms = $SearchText -split ',' | ForEach-Object { $_.Trim() }
        $found = $false
        
        foreach ($term in $searchTerms) {
            if ($term -and ($evt.Message -match [regex]::Escape($term) -or 
                $evt.ToXml() -match [regex]::Escape($term))) {
                $found = $true
                break
            }
        }
        
        if ($found) {
            $events += $evt
        }
    }
    
    if ($events.Count -eq 0) {
        Write-Host No entries contained the search text '$SearchText'. -ForegroundColor Yellow
        
        # Debug info - show sample of what we're searching through
        Write-Host `nDebug: Showing sample of events being searched: -ForegroundColor Yellow
        $sample = $allEvents | Select-Object -First 3
        foreach ($evt in $sample) {
            Write-Host `nSample Event ID: $($evt.Id) -ForegroundColor Yellow
            Write-Host Time: $($evt.TimeCreated) -ForegroundColor Yellow
            Write-Host Source: $($evt.ProviderName) -ForegroundColor Yellow
            Write-Host Message: -ForegroundColor Yellow
            Write-Host $evt.Message
            Write-Host ------------------------------------- -ForegroundColor Yellow
        }
    }
    else {
        Write-Host Found $($events.Count) entries containing '$SearchText': -ForegroundColor Green
        
        # Format and display matching events
        $events | ForEach-Object {
            Write-Host `nEvent ID: $($_.Id) -ForegroundColor Green
            Write-Host Time: $($_.TimeCreated) -ForegroundColor Green
            Write-Host Source: $($_.ProviderName) -ForegroundColor Green
            Write-Host Level: $($_.LevelDisplayName) -ForegroundColor Green
            Write-Host Message: -ForegroundColor Green
            Write-Host $_.Message
            Write-Host ------------------------------------- -ForegroundColor Cyan
        }
    }
}
catch {
    if ($_.Exception.Message -like *No events were found that match the specified selection criteria*) {
        Write-Host No events found in the $LogName log with the specified criteria. -ForegroundColor Yellow
    }
    elseif ($_.Exception.Message -like *The specified channel could not be found*) {
        Write-Host Error: The event log '$LogName' could not be found. -ForegroundColor Red
        Write-Host Available logs: -ForegroundColor Cyan
        Get-WinEvent -ListLog * -ErrorAction SilentlyContinue | Where-Object { $_.RecordCount -gt 0 } | 
            Select-Object LogName | Sort-Object LogName | Format-Table -AutoSize
    }
    else {
        Write-Host Error: $_ -ForegroundColor Red
    }
}

$searchAgain = $true
while ($searchAgain) {
    # Ask if the user wants to search again
    $response = Read-Host `nDo you want to search again? (Y/N)
    
    if ($response -like Y*) {
        # Allow modifying search parameters
        Write-Host `nYou can modify search parameters or keep existing ones: -ForegroundColor Cyan
        
        $newSearchText = Read-Host Enter new search text (leave empty to keep '$SearchText')
        if ($newSearchText) {
            $SearchText = $newSearchText
        }
        
        $newEventIDInput = Read-Host Enter new event ID(s) to filter by (comma-separated, leave empty to keep existing)
        if ($newEventIDInput) {
            $EventID = $newEventIDInput -split ',' | ForEach-Object { [int]$_.Trim() }
        }
        
        $newMaxEvents = Read-Host Enter new maximum events (leave empty to keep $MaxEvents)
        if ($newMaxEvents) {
            $MaxEvents = [int]$newMaxEvents
        }
        
        # Display updated search parameters
        Write-Host `nUpdated Search Parameters: -ForegroundColor Cyan
        Write-Host ------------------------------------- -ForegroundColor Cyan
        Write-Host Log: $LogName -ForegroundColor Cyan
        if ($EventID) {
            Write-Host Event ID(s): $($EventID -join ', ') -ForegroundColor Cyan
        }
        Write-Host Search Text: '$SearchText' -ForegroundColor Cyan
        Write-Host Maximum Events: $MaxEvents -ForegroundColor Cyan
        if ($StartTime) {
            Write-Host Start Time: $StartTime -ForegroundColor Cyan
        }
        if ($EndTime) {
            Write-Host End Time: $EndTime -ForegroundColor Cyan
        }
        Write-Host ------------------------------------- -ForegroundColor Cyan
        
        # Re-run the search with updated parameters
        try {
            # Build the filter hashtable - IMPORTANT: don't add MaxEvents to the filter hashtable
            $filterHashtable = @{
                LogName = $LogName
            }
            
            # Add EventID to filter if specified
            if ($EventID) {
                $filterHashtable.Add(ID, $EventID)
            }
            
            # Add time filters if specified
            if ($StartTime) {
                $filterHashtable.Add(StartTime, $StartTime)
            }
            
            if ($EndTime) {
                $filterHashtable.Add(EndTime, $EndTime)
            }
            
            # Display exact filter being used
            Write-Host Filter criteria: -ForegroundColor Cyan
            $filterHashtable.GetEnumerator() | ForEach-Object {
                Write-Host   $($_.Key): $($_.Value) -ForegroundColor Cyan
            }
            
            # Get events using the filter - DON'T limit results yet
            Write-Host Searching events, please wait... -ForegroundColor Cyan
            
            # Get events without MaxEvents first to see what's available
            $allEvents = Get-WinEvent -FilterHashtable $filterHashtable -ErrorAction Stop
            
            # Display total count of events matching filter criteria
            Write-Host Total log entries matching filter criteria: $($allEvents.Count) -ForegroundColor Cyan
            
            # Apply MaxEvents limit for search
            $allEvents = $allEvents | Select-Object -First $MaxEvents
            
            # If no events were found, exit early
            if ($allEvents.Count -eq 0) {
                Write-Host No log entries found matching the filter criteria. -ForegroundColor Yellow
                continue
            }
            
            # Use a reliable case-insensitive search
            $searchTerms = $SearchText -split ',' | ForEach-Object { $_.Trim() }
            if ($searchTerms.Count -gt 1) {
                Write-Host Searching for any of these terms: '$($searchTerms -join ', ')') -ForegroundColor Cyan
            } else {
                Write-Host Searching for text: '$SearchText' -ForegroundColor Cyan
            }
            $events = @()
            
            foreach ($evt in $allEvents) {
                # Split search text by commas and search for any matching term
                $searchTerms = $SearchText -split ',' | ForEach-Object { $_.Trim() }
                $found = $false
        
                foreach ($term in $searchTerms) {
                    if ($term -and ($evt.Message -match [regex]::Escape($term) -or 
                        $evt.ToXml() -match [regex]::Escape($term))) {
                        $found = $true
                        break
                    }
                }
                
                if ($found) {
                    $events += $evt
                }
            }
            
            if ($events.Count -eq 0) {
                Write-Host No entries contained the search text '$SearchText'. -ForegroundColor Yellow
                
                # Debug info - show sample of what we're searching through
                Write-Host `nDebug: Showing sample of events being searched: -ForegroundColor Yellow
                $sample = $allEvents | Select-Object -First 1
                Write-Host Sample message content: -ForegroundColor Yellow
                Write-Host $sample.Message
            }
            else {
                Write-Host Found $($events.Count) entries containing '$SearchText': -ForegroundColor Green
                
                # Format and display matching events
                $events | ForEach-Object {
                    Write-Host `nEvent ID: $($_.Id) -ForegroundColor Green
                    Write-Host Time: $($_.TimeCreated) -ForegroundColor Green
                    Write-Host Source: $($_.ProviderName) -ForegroundColor Green
                    Write-Host Level: $($_.LevelDisplayName) -ForegroundColor Green
                    Write-Host Message: -ForegroundColor Green
                    
                    # Highlight the search text in the message
                    $highlightedMessage = $_.Message -replace ($SearchText), `e[93m`$1`e[0m
                    Write-Host $highlightedMessage
                    Write-Host ------------------------------------- -ForegroundColor Cyan
                }
            }
        }
        catch {
            if ($_.Exception.Message -like *No events were found that match the specified selection criteria*) {
                Write-Host No events found in the $LogName log with the specified criteria. -ForegroundColor Yellow
            }
            elseif ($_.Exception.Message -like *The specified channel could not be found*) {
                Write-Host Error: The event log '$LogName' could not be found. -ForegroundColor Red
                Write-Host Available logs: -ForegroundColor Cyan
                Get-WinEvent -ListLog * -ErrorAction SilentlyContinue | Where-Object { $_.RecordCount -gt 0 } | 
                    Select-Object LogName | Sort-Object LogName | Format-Table -AutoSize
            }
            else {
                Write-Host Error: $_ -ForegroundColor Red
            }
        }
    }
    else {
        $searchAgain = $false
    }
}