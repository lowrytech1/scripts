# PS-NMAP Scanner script by Brian Lowry - 2024.@
param(
    [string]$InputFile,
    [string]$OutputFile,
    [string]$NmapPath = "C:\Program Files (x86)\Nmap\nmap.exe",
    [switch]$DetailedScan,
    [string]$SingleIP
)

# Enable verbose output if -Verbose is used
if ($PSBoundParameters['Verbose']) {
    $VerbosePreference = 'Continue'
}

# Set Environment Values with better error handling
try {
    if (-not $Host.UI.RawUI.MaxWindowSize.Width) {
        throw "Console window size cannot be modified in this environment"
    }
    [console]::WindowWidth = [math]::Min(100, $Host.UI.RawUI.MaxWindowSize.Width)
    [console]::WindowHeight = [math]::Min(40, $Host.UI.RawUI.MaxWindowSize.Height)
    [console]::BufferWidth = [console]::WindowWidth
    $host.UI.RawUI.WindowTitle = "PSNMAP Scanner V2.1"
    $hostWidth = $Host.UI.RawUI.WindowSize.Width
}
catch {
    Write-Warning "Unable to set console window size: $_"
    $hostWidth = 80  # fallback width
}

# Function to check if the script is running as administrator
function Test-IsAdmin {
    Write-Verbose "Checking for Admin access..."
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to check if winget is installed
function Test-WingetInstalled {
    Write-Verbose "Testing if Winget is installed..."
    try {
        winget --version
        return $true
    } catch {
        return $false
    }
}

# Function to check if NMAP is installed
function Test-NMAPInstalled {
    Write-Host ""
    Write-Verbose "Testing if NMAP is already installed..."
    try {
        test-path -path "C:\Program Files (x86)\Nmap\nmap.exe"
        If ($true) {
            return $true
        }
    } catch {
        return $false
    }
}

# Function to install or update NMAP using winget with a progress bar
function Install-Or-Update-NMAP {
    if (Test-WingetInstalled) {
        Write-Host "Winget is installed." -ForegroundColor Green
    } else {
        Write-Host "Winget is not installed. Please install Winget and try again." -ForegroundColor Red
        exit
    }
    Write-Verbose "Installing or updating NMAP using Winget..."
    if (Test-NMAPInstalled) {
        Write-Host "NMAP is already installed. Checking for updates..." -ForegroundColor Yellow
        $wingetArgs = "upgrade --id Insecure.Nmap --silent --accept-package-agreements --accept-source-agreements"
    } else {
        Write-Host "NMAP is not installed. Installing..." -ForegroundColor Yellow
        $wingetArgs = "install --id Insecure.Nmap --silent --accept-package-agreements --accept-source-agreements"
    }

    Write-Host ""

    # Start the winget process and capture the output
    Write-Host "Installing NMAP with Winget..."
    $process = Start-Process -FilePath "winget" -ArgumentList $wingetArgs -NoNewWindow -PassThru -RedirectStandardOutput "winget_output.txt"

    try {
        # Initialize the progress bar variables
        $progressActivity = "Installing NMAP"
        $progressStatus = "In Progress"
        $progressPercent = 0

        # Start the installation process (assuming $process is already defined)
        while (-not $process.HasExited) {
            # Update progress bar
            Write-Progress -Activity $progressActivity -Status $progressStatus -PercentComplete $progressPercent
            Start-Sleep -Seconds 1
            $progressPercent += 5
            if ($progressPercent -gt 100) {
                $progressPercent = 100
            }
        }
        
        # Read the output file to check for success or failure
        Write-Host "Verifying NMAP installation success..."
        if (Test-Path -Path "winget_output.txt") {
            $output = Get-Content -Path "winget_output.txt"
            if ($output -match "Successfully installed" -or $output -match "No applicable update found") {
                Write-Host "NMAP installation or update completed successfully." -ForegroundColor Green
            } else {
                Write-Host "NMAP installation or update failed. See output below:" -ForegroundColor Red
                Write-Host $output
            }
            # Clean up
            Remove-Item -Path "winget_output.txt"
        } else {
            Write-Host "Output file not found. Unable to verify installation status." -ForegroundColor Red
        }
    } catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
}

# Improved Winget installation function
function Install-Winget {
    Write-Verbose "Installing Winget..."
    try {
        $progressPreference = 'silentlyContinue'
        $latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | 
            Where-Object {$_.EndsWith(".msixbundle")}
        
        if (-not $latestWingetMsixBundleUri) {
            throw "Could not find Winget download URL"
        }

        $tempFile = Join-Path $env:TEMP $latestWingetMsixBundleUri.Split("/")[-1]
        Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile $tempFile
        Add-AppxPackage $tempFile
        Remove-Item -Path $tempFile -Force
        return $true
    }
    catch {
        Write-Error "Failed to install Winget: $_"
        return $false
    }
    finally {
        $progressPreference = 'Continue'
    }
}

# Improved NMAP scanning function
function Invoke-NmapScan {
    param(
        [string]$IP,
        [bool]$DetailedScan,
        [string]$NmapPath
    )
    
    try {
        # Perform scan
        $scanOptions = if ($DetailedScan) {
            @("-sS", "-sV", "-O", "--max-retries", "2", "--min-rate", "100")
        } else {
            @("-sn")
        }
        
        $scanResult = & $NmapPath $scanOptions $IP 2>&1

        # Create result object
        $dns = [System.Net.Dns]::GetHostEntry($IP)
        $result = @{
            IPAddress = $IP
            Hostname = if ($dns.HostName) { $dns.HostName } else { "No hostname" }
            Status = switch -Regex ($scanResult) {
                "Host is up \(.*\)" { "Up" }
                "Host seems down" { "Down" }
                default { "Unknown" }
            }
            Timestamp = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
            OpenPorts = $(
                $ports = $scanResult | Select-String -Pattern "(\d+/\w+)\s+(open)\s+(\w+)"
                if ($ports) {
                    ($ports | ForEach-Object { $_.Matches.Groups[0].Value.Trim() }) -join '; '
                } else { "No open ports found" }
            )
            OperatingSystem = $(
                $os = $scanResult | Select-String -Pattern "OS details: (.*)"
                if ($os) {
                    $os.Matches.Groups[1].Value.Trim()
                } else { "OS detection failed" }
            )
        }

        [PSCustomObject]$result
    } catch {
        Write-Warning "Error scanning $IP : $_"
        [PSCustomObject]@{
            IPAddress = $IP
            Hostname = "Scan failed"
            Status = "Error"
            Timestamp = Get-Date
            OpenPorts = "Scan failed"
            OperatingSystem = "Scan failed"
        }
    }
} # Added closing brace here


# Header
Clear-Host
# Banner text definitions
$BANNER1 = @"
|  ██████╗ ███████╗        ███╗   ██╗███╗   ███╗ █████╗ ██████╗   |
|  ██╔══██╗██╔════╝        ████╗  ██║████╗ ████║██╔══██╗██╔══██╗  |
|  ██████╔╝███████╗███████╗██╔██╗ ██║██╔████╔██║███████║██████╔╝  |
|  ██╔═══╝ ╚════██║╚══════╝██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═══╝   |
|  ██║     ███████║        ██║ ╚████║██║ ╚═╝ ██║██║  ██║██║       |
|  ╚═╝     ╚══════╝        ╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝          |
"@

$BANNER2 = @"
███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗███████╗██████╗ 
██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██╔════╝██╔══██╗
███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝
╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗
███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║███████╗██║  ██║
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
"@

# Display centered banners
#Clear-Host
Write-Output ""
Write-Output ""
$banner1Lines = $BANNER1.TrimEnd() -split "`n"
$banner2Lines = $BANNER2.TrimEnd() -split "`n"
$maxWidth = [Math]::Max(($banner1Lines | Measure-Object -Maximum Length).Maximum, 
                       ($banner2Lines | Measure-Object -Maximum Length).Maximum)

foreach ($line in $banner1Lines) {
    $line = $line.TrimEnd()
    $paddingLength = [Math]::Max(0, [math]::Floor(($hostWidth - $line.Length) / 2))
    $padding = if ($paddingLength -gt 0) { " " * $paddingLength } else { "" }
    Write-Host ($padding + $line) -ForegroundColor DarkRed
}

Write-Output ""

foreach ($line in $banner2Lines) {
    $line = $line.TrimEnd()
    $paddingLength = [Math]::Max(0, [math]::Floor(($hostWidth - $line.Length) / 2))
    $padding = if ($paddingLength -gt 0) { " " * $paddingLength } else { "" }
    Write-Host ($padding + $line) -ForegroundColor DarkRed
}

Write-Output ""
Start-Sleep -Seconds 2.5
$Pad = 14
Write-Output ""
Write-Host (" " * $pad) "         PowerShell NMAP Scanner script by Brian Lowry - 2024." -ForegroundColor Yellow
Write-Host (" " * $pad) "This script will scan the IP addresses in the input CSV file using NMAP" -ForegroundColor Gray
Write-Host (" " * $pad) "and save the results to a CSV file." -ForegroundColor Gray
Write-Host (" " * $pad) "The script requires NMAP to be installed on the system and the path to" -ForegroundColor Gray
Write-Host (" " * $pad) "the NMAP executable to be provided." -ForegroundColor Gray
Write-Host ""
Write-Host "Usage: .\NMAP_Scanner.ps1 -InputFile 'C:\path\to\input.csv' -OutputFile 'C:\path\to\output.csv'" -ForegroundColor Green
Write-Host "-NmapPath 'C:\path\to\nmap.exe' -DetailedScan" -ForegroundColor Green
Write-Host ""

# Check if the script is running as administrator
Write-Verbose "Checking if the script is running as administrator..."
if (-not (Test-IsAdmin)) {
    Write-Host "This script must be run as an administrator. Please restart the script with administrative privileges." -ForegroundColor Red
    exit
} 
else {
    Write-Host "Running as administrator..." -ForegroundColor Green
}

# Check if NMAP exists
Write-Verbose "Checking for NMAP installation..."
if (-not (Test-Path $NmapPath)) {
    Write-Error "NMAP not found at $NmapPath. Attempting to install Using WinGet."
    if (-not (Test-WingetInstalled)) {
        Write-Host "Winget is not installed. Installing now." -ForegroundColor Red
        Install-Winget
    } 
    else {
        Write-Host "Winget Is installed" -ForegroundColor Green
    }
    Install-Or-Update-NMAP
}

# Improved input validation
if ([string]::IsNullOrEmpty($InputFile) -and [string]::IsNullOrEmpty($SingleIP)) {
    $inputChoice = Read-Host "Do you want to scan a single IP (S) or use a CSV file (F)?"
    if ($inputChoice.ToUpper() -eq "S") {
        do {
            $SingleIP = Read-Host "Enter the IP address to scan"
        } while (-not ($SingleIP -as [IPAddress]))
    } else {
        do {
            $InputFile = Read-Host "Enter the path to the input file containing IP addresses"
        } while (-not (Test-Path $InputFile))
    }
}

if ([string]::IsNullOrEmpty($OutputFile)) {
    $timeStamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $OutputFile = "NmapScanResults_$timeStamp.csv"
}

$DetailedScan = $DetailedScan -or (Read-Host "Do you want to perform a detailed scan? (Y/N)").ToUpper() -eq "Y"
if ($DetailedScan) {
    Write-Host "Performing detailed scan, this may take a while..." -ForegroundColor Green
} else {
    Write-Host "Performing basic scan..." -ForegroundColor Green
}
# Create array to store results
$results = @()

# Process IP addresses based on input method
if ($SingleIP) {
    Write-Host "Scanning single IP: $SingleIP..." -ForegroundColor Cyan
    $resultObj = Invoke-NmapScan -IP $SingleIP -DetailedScan $DetailedScan -NmapPath $NmapPath
    $results += $resultObj
} else {
    # Read IP addresses from file
    $ipAddresses = Get-Content $InputFile
    foreach ($ip in $ipAddresses) {
        Write-Host "Scanning $ip..." -ForegroundColor Cyan
        $resultObj = Invoke-NmapScan -IP $ip -DetailedScan $DetailedScan -NmapPath $NmapPath
        $results += $resultObj
    }
}

# Export results to CSV
$results | Export-Csv -Path $OutputFile -NoTypeInformation
$Report = Import-Csv $OutputFile
$Report | Format-Table -AutoSize -Property Hostname,IPAddress,Status,OperatingSystem,OpenPorts -RepeatHeader -Wrap
Write-Host ""

Write-Host "Scan complete. Results saved to $OutputFile"
