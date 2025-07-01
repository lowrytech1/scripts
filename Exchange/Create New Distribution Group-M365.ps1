<# Script Notes:
We need a lot of authentication to complete this task:
    1. Run this script in an elevated powershell.exe console (Administrator) - Required to install modules
    2. Verify all downloadable modules are installed
    3. Connect to exchange online to commit these changes to the M365 tenant
    4. Connect to On-Prem Exchange simply to load the "Exchange Management shell"
        AKA "Exchange Powershell" module, which is not available for download, 
        only installed for Exchange Server  - required to use the New-DistributionGroup cmdlet
    5. Make sure you have the correct Exchange roles to run that command. Exchange Admin or Recipient Admin. - required

The list of group members sghould be int the format: "user name","user Name","User name"
    
    #>
clear-host

Write-Host "       *** This script requires Microsoft PowerShell 7 or higher. ***     *" -ForegroundColor red -BackgroundColor Black
Write-Host "                    Windows PowerShell is insufficient.                    " -ForegroundColor Yellow -BackgroundColor Blue
Write-Host "   ************************************************************************"
Write-Host "   *                                                                      *"
Write-Host "   *                           Kern County ITS                            *"
Write-Host "   *                                                                      *"
Write-Host "   *                  *** Create New Distribution Group ***               *"
Write-Host "   *                           ***By Brian Lowry***                       *"
Write-Host "   *                                                                      *"
Write-Host "   *                                                                      *"
Write-Host "   ************************************************************************"
Write-Host ""

#********************************************************************************************

#********************************************************************************************
# Check for AZ Module installed, Install AZ module(if necessary):
Write-Host "   ************************************************************************"
Write-Host "   *                                                                      *"
Write-Host "   *              Verifying Azure modules are installed...                *"
Write-Host "   *                                                                      *"
Write-Host "   ************************************************************************"
Write-Host ""

$exonline = Get-InstalledModule -Name ExchangeOnlineManagement
If (-not ($exonline)) {
    Write-Host "                *** Installing Exchange Online Module... ***               " -ForegroundColor white -BackgroundColor Red
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Install-Module -Name ExchangeOnlineManagement -Repository PSGallery -Force
    Import-Module -name ExchangeOnlineManagement
    Write-Host "            *** Exchange Online module successfully installed ***          " -ForegroundColor white -BackgroundColor Green
}
Else {
    Write-Host "                 *** Exchange Online Module is installed ***               " -ForegroundColor black -BackgroundColor yellow
}
$AZinstalled = Get-InstalledModule -Name Az
If (-not ($AZinstalled)) {
    Write-Host "                    *** Installing Azure PS Module... ***                  " -ForegroundColor white -BackgroundColor Red
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Install-Module -Name Az -Repository PSGallery -Force
    Import-Module -name Az
    Write-Host "                 *** Azure module successfully installed ***               " -ForegroundColor white -BackgroundColor Green
}
Else {
    Write-Host "                      *** Azure Module is installed ***                    " -ForegroundColor black -BackgroundColor yellow
}
$AZrinstalled = Get-InstalledModule -Name Az.Resources
If (-not ($AZrinstalled)) {
    Write-Host "              *** Installing Azure Resources PS Module... ***               " -ForegroundColor white -BackgroundColor Red
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Install-Module -Name Az.Resources -Repository PSGallery -Force
    Import-Module -name Az.Resources
    Write-Host "           *** Azure resources module successfully installed ***            " -ForegroundColor white -BackgroundColor Green
}
Else {
    Write-Host "                *** Azure Resources Module is installed ***                 " -ForegroundColor black -BackgroundColor yellow
}

#***************************************************************************************
# Connect to On-Prem Exchange just to import the session and its Exchange Powershell Module.
# Exchange Powershell connection script:
Write-Output "   ************************************************************************"
Write-Output "   *                                                                      *"
Write-Output "   *               Connecting to On-Prem Exchange Server...               *"
Write-Output "   *                                                                      *"
Write-Output "   *                                                                      *"
Write-Output "   *     On-premise Exchange administrative credentials (domain\user)     *" -ForegroundColor red
Write-Output "   *                                                                      *"
Write-Output "   ************************************************************************"
Write-Output ""

# Check if a session already exists and enter, or create new session:
Write-Output "   *                     checking for active session                      *" -ForegroundColor black -BackgroundColor White
Write-Output "Please stand by..."

[CmdletBinding()]
[OutputType([int])]

$session = Get-PsSession | Where-Object {
    ($_.ComputerName -match "ITS-EXCH01.kerncounty.com") -and ($_.State -match "Opened")
} # End Where-Object

If (-not ($session)) {
    $Params = @{
    	ConfigurationName = "Microsoft.Exchange"
    	ConnectionUri = "https://ITS-EXCH01.kerncounty.com/PowerShell/"
    	Authentication = "Basic"
    	AllowRedirect = $True
    } # End Params
    Write-Output "                         *** Creating new session ***                      "

    #Obtain On-prem Exchange server credentials:
    $UserCredential = Get-Credential -Message "Please enter On-premise Exchange administrative credentials (domain\user)"
    $ExchSession = New-PSSession @params -Credential $UserCredential
    Import-PSSession $ExchSession -AllowClobber
} Else {
    Write-Output "                           *** Session exists ***                          " -ForegroundColor black -BackgroundColor green
}

Write-Host "                                                                           "
Write-Host "   ************************************************************************"
Write-Host "   *                                                                      *"
Write-Host "   *                        Connecting to Azure...                        *"
Write-Host "   *                                                                      *"
Write-Host "   ************************************************************************"
Write-Host ""
Connect-AzAccount
#VERIFY AZ CONNECT.
Write-Host "                         *** Connected to Azure ***                        " -ForegroundColor black -BackgroundColor Green

#Get Group Info:
#$GroupName = Read-Host -Prompt "Please enter the desired group name: "
#$Members = Read-Host -Prompt "Please enter comma-separated list of members to add: "

#Create Distribution group:
#New-DistributionGroup -Name $GroupName -Members $Members
New-DistributionGroup -Name "Department Heads" -Members "Andie Sullivan","Glenn Fankhauser","Nicholas Cullen","Devin Brown","Kathleen Krause","Zack Scrivner","David Couch","Leticia Perez","Aaron Ellis","Aaron Duncan","Brynn Carrigan","Glen Stephens","Lorelei Oviatt","Josh Champlin","Gary Ray","Lito Morillo","Jeremy Oliver","William P. Dickinson","Geoffrey Hill","Peter Kang","Ron Brewster","Stacy L. Kuwahara","DONNY YOUNGBLOOD","LARRY MCCURTAIN","Margo Raison","Jordan Kaufman","Jeff Flores","Laura Avila","Kris Lyon","Ahron Hakimi","Jose Lopez","Aimee Espinoza","James Zervis","Alexandra Soper","Brian Marsh","Dominic Brown","Mark Buonauro","Cynthia Zimmer","Elizabeth Chavez","Stacy Kuwahara","Scott Thygerson","Bernave Garcia"