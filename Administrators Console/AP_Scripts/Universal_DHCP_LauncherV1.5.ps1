#DHCP Launcher script by Brian Lowry, 2024

#Set Environment Values
[console]::windowwidth=60;
[console]::windowheight=23;
[console]::bufferwidth=[console]::windowwidth;
#$host.UI.RawUI.BackgroundColor="black";
#$host.UI.RawUI.ForegroundColor="a";
$host.UI.RawUI.WindowTitle="DHCP Launcher";

Clear-Host
# Initialize the $exit variable to $false
$exit = $false

#Ensure necessary modules load when needed:
$PSModuleAutoLoadingPreference = "All"

# Lookup DHCP server name from a table based on the IP address
$dhcpTable = @{
    "11.15.8"      = "auddc02.accc.co.kern.ca.us"
    "11.2.48"      = "dns1.its.co.kern.ca.us"
    "11.4.8"       = "dns1.its.co.kern.ca.us"
    "11.15.24"     = "dns1.its.co.kern.ca.us"
    "11.15.48"     = "dns1.its.co.kern.ca.us"
    "11.27.248"    = "dns1.its.co.kern.ca.us"
    "11.38.20"     = "dns1.its.co.kern.ca.us"
    "11.76.200"    = "dns1.its.co.kern.ca.us"
    "11.230.0"     = "dns1.its.co.kern.ca.us"
    "11.230.8"     = "dns1.its.co.kern.ca.us"
    "11.230.16"    = "dns1.its.co.kern.ca.us"
    "11.230.252"   = "dns1.its.co.kern.ca.us"
    "11.231.0"     = "dns1.its.co.kern.ca.us"
    "11.35.100"    = "dns1.its.co.kern.ca.us"
    "11.35.110"    = "dns1.its.co.kern.ca.us"
    "11.35.120"    = "dns1.its.co.kern.ca.us"
    "11.35.130"    = "dns1.its.co.kern.ca.us"
    "11.35.140"    = "dns1.its.co.kern.ca.us"
    "11.35.150"    = "dns1.its.co.kern.ca.us"
    "11.35.160"    = "dns1.its.co.kern.ca.us"
    "11.39.16"     = "dns1.its.co.kern.ca.us"
    "11.50.86"     = "dns1.its.co.kern.ca.us"
    "11.50.212"    = "dns1.its.co.kern.ca.us"
    "11.51.20"     = "dns1.its.co.kern.ca.us"
    "11.51.30"     = "dns1.its.co.kern.ca.us"
    "11.76.38"     = "dns1.its.co.kern.ca.us"
    "11.76.86"     = "dns1.its.co.kern.ca.us"
    "11.76.100"    = "dns1.its.co.kern.ca.us"
    "11.76.110"    = "dns1.its.co.kern.ca.us"
    "11.76.112"    = "dns1.its.co.kern.ca.us"
    "11.76.120"    = "dns1.its.co.kern.ca.us"
    "11.76.130"    = "dns1.its.co.kern.ca.us"
    "11.76.140"    = "dns1.its.co.kern.ca.us"
    "11.76.150"    = "dns1.its.co.kern.ca.us"
    "10.253.7"     = "dns1.its.co.kern.ca.us"
    "11.15.57"     = "dns1.its.co.kern.ca.us"
    "11.21.60"     = "dns1.its.co.kern.ca.us"
    "11.21.85"     = "dns1.its.co.kern.ca.us"
    "11.21.90"     = "dns1.its.co.kern.ca.us"
    "11.33.105"    = "dns1.its.co.kern.ca.us"
    "11.34.20"     = "dns1.its.co.kern.ca.us"
    "11.35.10"     = "dns1.its.co.kern.ca.us"
    "11.35.50"     = "dns1.its.co.kern.ca.us"
    "11.35.103"    = "dns1.its.co.kern.ca.us"
    "11.35.113"    = "dns1.its.co.kern.ca.us"
    "11.35.123"    = "dns1.its.co.kern.ca.us"
    "11.35.133"    = "dns1.its.co.kern.ca.us"
    "11.35.143"    = "dns1.its.co.kern.ca.us"
    "11.35.153"    = "dns1.its.co.kern.ca.us"
    "11.35.163"    = "dns1.its.co.kern.ca.us"
    "11.35.210"    = "dns1.its.co.kern.ca.us"
    "11.35.211"    = "dns1.its.co.kern.ca.us"
    "11.35.215"    = "dns1.its.co.kern.ca.us"
    "11.39.12"     = "dns1.its.co.kern.ca.us"
    "11.39.20"     = "dns1.its.co.kern.ca.us"
    "11.39.22"     = "dns1.its.co.kern.ca.us"
    "11.39.100"    = "dns1.its.co.kern.ca.us"
    "11.39.105"    = "dns1.its.co.kern.ca.us"
    "11.45.10"     = "dns1.its.co.kern.ca.us"
    "11.50.4"      = "dns1.its.co.kern.ca.us"
    "11.50.6"      = "dns1.its.co.kern.ca.us"
    "11.50.13"     = "dns1.its.co.kern.ca.us"
    "11.50.19"     = "dns1.its.co.kern.ca.us"
    "11.50.20"     = "dns1.its.co.kern.ca.us"
    "11.50.22"     = "dns1.its.co.kern.ca.us"
    "11.50.24"     = "dns1.its.co.kern.ca.us"
    "11.50.25"     = "dns1.its.co.kern.ca.us"
    "11.50.28"     = "dns1.its.co.kern.ca.us"
    "11.50.29"     = "dns1.its.co.kern.ca.us"
    "11.50.33"     = "dns1.its.co.kern.ca.us"
    "11.50.34"     = "dns1.its.co.kern.ca.us"
    "11.50.45"     = "dns1.its.co.kern.ca.us"
    "11.50.48"     = "dns1.its.co.kern.ca.us"
    "11.50.49"     = "dns1.its.co.kern.ca.us"
    "11.50.50"     = "dns1.its.co.kern.ca.us"
    "11.50.53"     = "dns1.its.co.kern.ca.us"
    "11.50.54"     = "dns1.its.co.kern.ca.us"
    "11.50.60"     = "dns1.its.co.kern.ca.us"
    "11.50.61"     = "dns1.its.co.kern.ca.us"
    "11.50.65"     = "dns1.its.co.kern.ca.us"
    "11.50.69"     = "dns1.its.co.kern.ca.us"
    "11.50.74"     = "dns1.its.co.kern.ca.us"
    "11.50.75"     = "dns1.its.co.kern.ca.us"
    "11.50.76"     = "dns1.its.co.kern.ca.us"
    "11.50.79"     = "dns1.its.co.kern.ca.us"
    "11.50.80"     = "dns1.its.co.kern.ca.us"
    "11.50.84"     = "dns1.its.co.kern.ca.us"
    "11.50.88"     = "dns1.its.co.kern.ca.us"
    "11.50.93"     = "dns1.its.co.kern.ca.us"
    "11.50.94"     = "dns1.its.co.kern.ca.us"
    "11.50.95"     = "dns1.its.co.kern.ca.us"
    "11.50.96"     = "dns1.its.co.kern.ca.us"
    "11.50.103"    = "dns1.its.co.kern.ca.us"
    "11.50.104"    = "dns1.its.co.kern.ca.us"
    "11.50.111"    = "dns1.its.co.kern.ca.us"
    "11.50.113"    = "dns1.its.co.kern.ca.us"
    "11.50.114"    = "dns1.its.co.kern.ca.us"
    "11.50.115"    = "dns1.its.co.kern.ca.us"
    "11.50.116"    = "dns1.its.co.kern.ca.us"
    "11.50.117"    = "dns1.its.co.kern.ca.us"
    "11.50.120"    = "dns1.its.co.kern.ca.us"
    "11.50.122"    = "dns1.its.co.kern.ca.us"
    "11.50.123"    = "dns1.its.co.kern.ca.us"
    "11.50.124"    = "dns1.its.co.kern.ca.us"
    "11.50.125"    = "dns1.its.co.kern.ca.us"
    "11.50.126"    = "dns1.its.co.kern.ca.us"
    "11.50.128"    = "dns1.its.co.kern.ca.us"
    "11.50.130"    = "dns1.its.co.kern.ca.us"
    "11.50.134"    = "dns1.its.co.kern.ca.us"
    "11.50.135"    = "dns1.its.co.kern.ca.us"
    "11.50.139"    = "dns1.its.co.kern.ca.us"
    "11.50.141"    = "dns1.its.co.kern.ca.us"
    "11.50.145"    = "dns1.its.co.kern.ca.us"
    "11.50.153"    = "dns1.its.co.kern.ca.us"
    "11.50.154"    = "dns1.its.co.kern.ca.us"
    "11.50.155"    = "dns1.its.co.kern.ca.us"
    "11.50.211"    = "dns1.its.co.kern.ca.us"
    "11.50.221"    = "dns1.its.co.kern.ca.us"
    "11.50.228"    = "dns1.its.co.kern.ca.us"
    "11.51.10"     = "dns1.its.co.kern.ca.us"
    "11.75.48"     = "dns1.its.co.kern.ca.us"
    "11.75.49"     = "dns1.its.co.kern.ca.us"
    "11.75.50"     = "dns1.its.co.kern.ca.us"
    "11.75.61"     = "dns1.its.co.kern.ca.us"
    "11.75.75"     = "dns1.its.co.kern.ca.us"
    "11.75.80"     = "dns1.its.co.kern.ca.us"
    "11.75.90"     = "dns1.its.co.kern.ca.us"
    "11.75.93"     = "dns1.its.co.kern.ca.us"
    "11.75.109"    = "dns1.its.co.kern.ca.us"
    "11.75.110"    = "dns1.its.co.kern.ca.us"
    "11.75.111"    = "dns1.its.co.kern.ca.us"
    "11.75.112"    = "dns1.its.co.kern.ca.us"
    "11.75.113"    = "dns1.its.co.kern.ca.us"
    "11.75.118"    = "dns1.its.co.kern.ca.us"
    "11.75.119"    = "dns1.its.co.kern.ca.us"
    "11.75.120"    = "dns1.its.co.kern.ca.us"
    "11.75.121"    = "dns1.its.co.kern.ca.us"
    "11.75.122"    = "dns1.its.co.kern.ca.us"
    "11.75.123"    = "dns1.its.co.kern.ca.us"
    "11.75.126"    = "dns1.its.co.kern.ca.us"
    "11.75.130"    = "dns1.its.co.kern.ca.us"
    "11.75.134"    = "dns1.its.co.kern.ca.us"
    "11.75.135"    = "dns1.its.co.kern.ca.us"
    "11.75.141"    = "dns1.its.co.kern.ca.us"
    "11.75.150"    = "dns1.its.co.kern.ca.us"
    "11.75.154"    = "dns1.its.co.kern.ca.us"
    "11.75.155"    = "dns1.its.co.kern.ca.us"
    "11.75.160"    = "dns1.its.co.kern.ca.us"
    "11.75.171"    = "dns1.its.co.kern.ca.us"
    "11.75.181"    = "dns1.its.co.kern.ca.us"
    "11.75.190"    = "dns1.its.co.kern.ca.us"
    "11.75.210"    = "dns1.its.co.kern.ca.us"
    "11.75.220"    = "dns1.its.co.kern.ca.us"
    "11.75.221"    = "dns1.its.co.kern.ca.us"
    "11.75.222"    = "dns1.its.co.kern.ca.us"
    "11.22.0"      = "Da-dc1.kcda.local" 
    "11.50.62"     = "Da-dc1.kcda.local"   
    "11.50.151"    = "Da-dc1.kcda.local" 
    "11.75.151"    = "Da-dc1.kcda.local"
    "11.34.10"     = "Da-dc10.kcda.local"
    "11.34.12"     = "Da-dc10.kcda.local"
    "11.34.14"     = "Da-dc10.kcda.local"
    "11.34.16"     = "Da-dc10.kcda.local"
    "11.34.100"    = "Da-dc10.kcda.local"
    "11.76.40"     = "Da-dc10.kcda.local"
    "11.76.42"     = "Da-dc10.kcda.local"
    "11.76.44"     = "Da-dc10.kcda.local"
    "11.27.1"      = "etrdc1.kerncounty.com"
    "11.27.24"     = "etrdc1.kerncounty.com"
    "11.27.80"     = "etrdc1.kerncounty.com"
    "11.33.20"     = "etrdc1.kerncounty.com"
    "11.33.30"     = "etrdc1.kerncounty.com"
    "11.33.100"    = "etrdc1.kerncounty.com"
    "11.33.200"    = "etrdc1.kerncounty.com"
    "11.75.27"     = "etrdc1.kerncounty.com"
    "11.75.28"     = "etrdc1.kerncounty.com"
    "11.75.137"    = "etrdc1.kerncounty.com"
    "11.76.20"     = "etrdc1.kerncounty.com"
    "11.76.43"     = "etrdc1.kerncounty.com"
    "192.168.248"  = "psbnvr02.kerncounty.com"
    "11.50.245"    = "krcl-dc10.lab.da.co.kern.ca.us"
    "11.75.245"    = "krcl-dc10.lab.da.co.kern.ca.us"
    "11.15.72"     = "ccdom.ccdomain.cc.co.kern.ca.us"
    "11.23.18"     = "dc04.kernbhrs.local"
    "11.23.19"     = "dc04.kernbhrs.local"
    "11.23.20"     = "dc04.kernbhrs.local"
    "11.23.21"     = "dc04.kernbhrs.local"
    "11.23.24"     = "dc04.kernbhrs.local"
    "11.23.25"     = "dc04.kernbhrs.local"
    "11.23.27"     = "dc04.kernbhrs.local"
    "11.23.31"     = "dc04.kernbhrs.local"
    "11.23.32"     = "dc04.kernbhrs.local"
    "11.23.33"     = "dc04.kernbhrs.local"
    "11.23.36"     = "dc04.kernbhrs.local"
    "11.23.37"     = "dc04.kernbhrs.local"
    "11.23.40"     = "dc04.kernbhrs.local"
    "11.23.41"     = "dc04.kernbhrs.local"
    "11.23.42"     = "dc04.kernbhrs.local"
    "11.23.43"     = "dc04.kernbhrs.local"
    "11.23.49"     = "dc04.kernbhrs.local"
    "11.23.50"     = "dc04.kernbhrs.local"
    "11.23.51"     = "dc04.kernbhrs.local"
    "11.23.60"     = "dc04.kernbhrs.local"
    "11.23.61"     = "dc04.kernbhrs.local"
    "11.23.63"     = "dc04.kernbhrs.local"
    "11.23.65"     = "dc04.kernbhrs.local"
    "11.23.67"     = "dc04.kernbhrs.local"
    "11.23.70"     = "dc04.kernbhrs.local"
    "11.23.71"     = "dc04.kernbhrs.local"
    "11.23.73"     = "dc04.kernbhrs.local"
    "11.23.75"     = "dc04.kernbhrs.local"
    "11.23.81"     = "dc04.kernbhrs.local"
    "11.23.83"     = "dc04.kernbhrs.local"
    "11.23.89"     = "dc04.kernbhrs.local"
    "11.23.91"     = "dc04.kernbhrs.local"
    "11.23.97"     = "dc04.kernbhrs.local"
    "11.23.99"     = "dc04.kernbhrs.local"
    "11.23.101"    = "dc04.kernbhrs.local"
    "11.23.102"    = "dc04.kernbhrs.local"
    "11.23.103"    = "dc04.kernbhrs.local"
    "11.23.104"    = "dc04.kernbhrs.local"
    "11.23.115"    = "dc04.kernbhrs.local"
    "11.23.120"    = "dc04.kernbhrs.local"
    "11.23.121"    = "dc04.kernbhrs.local"
    "11.23.123"    = "dc04.kernbhrs.local"
    "11.23.129"    = "dc04.kernbhrs.local"
    "11.23.131"    = "dc04.kernbhrs.local"
    "11.23.136"    = "dc04.kernbhrs.local"
    "11.23.137"    = "dc04.kernbhrs.local"
    "11.23.139"    = "dc04.kernbhrs.local"
    "11.23.144"    = "dc04.kernbhrs.local"
    "11.23.145"    = "dc04.kernbhrs.local"
    "11.23.147"    = "dc04.kernbhrs.local"
    "11.23.153"    = "dc04.kernbhrs.local"
    "11.23.155"    = "dc04.kernbhrs.local"
    "11.23.160"    = "dc04.kernbhrs.local"
    "11.23.161"    = "dc04.kernbhrs.local"
    "11.23.163"    = "dc04.kernbhrs.local"
    "11.23.168"    = "dc04.kernbhrs.local"
    "11.23.170"    = "dc04.kernbhrs.local"
    "11.23.205"    = "dc04.kernbhrs.local"
    "11.23.227"    = "dc04.kernbhrs.local"
    "11.72.172"    = "dc04.kernbhrs.local"
    "11.75.21"     = "dc04.kernbhrs.local"
    "11.75.34"     = "dc04.kernbhrs.local"
    "11.75.60"     = "dc04.kernbhrs.local"
    "11.75.81"     = "dc04.kernbhrs.local"
    "11.75.101"    = "dc04.kernbhrs.local"
    "11.75.102"    = "dc04.kernbhrs.local"
    "11.75.103"    = "dc04.kernbhrs.local"
    "11.75.104"    = "dc04.kernbhrs.local"
    "11.75.105"    = "dc04.kernbhrs.local"
    "11.75.106"    = "dc04.kernbhrs.local"
    "11.75.240"    = "dc04.kernbhrs.local"
    "11.76.25"     = "dc04.kernbhrs.local"
    "11.76.26"     = "dc04.kernbhrs.local"
    "11.76.171"    = "dc04.kernbhrs.local"
    "11.15.64"     = "asr-dc8.assessor.internal"
    "11.15.0"      = "eims-dc-02.elections.accc.co.kern.ca.us"
    "11.49.11"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.12"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.13"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.32"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.33"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.34"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.35"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.36"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.37"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.38"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.39"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.44"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.45"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.46"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.50"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.51"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.52"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.53"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.54"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.55"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.56"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.57"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.60"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.64"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.80"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.81"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.82"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.88"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.92"      = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.100"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.140"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.141"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.179"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.180"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.184"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.186"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.191"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.192"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.197"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.203"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.204"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.209"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.210"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.215"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.218"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.219"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.221"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.227"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.228"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.233"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.234"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.242"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.243"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.244"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.245"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.246"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.250"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.49.255"     = "dhcp1.dom1.dhs.co.kern.ca.us"
    "11.32.0"       = "phdhcp01.phdom.local"
    "11.32.1"       = "phdhcp01.phdom.local"
    "11.32.2"       = "phdhcp01.phdom.local"
    "11.32.8"       = "phdhcp01.phdom.local"
    "11.32.10"      = "phdhcp01.phdom.local"
    "11.32.12"      = "phdhcp01.phdom.local"
    "11.32.20"      = "phdhcp01.phdom.local"
    "11.32.126"     = "phdhcp01.phdom.local"
    "11.32.127"     = "phdhcp01.phdom.local"
    "11.41.0"       = "phdhcp01.phdom.local"
    "11.50.187"     = "phdhcp01.phdom.local"
    "11.50.197"     = "phdhcp01.phdom.local"
    "11.50.248"     = "phdhcp01.phdom.local"
    "11.76.32"      = "phdhcp01.phdom.local"
    # Add more mappings as needed
}

# Function to determine the correct DHCP server based on IP address
function Get-DhcpServer($ip) {
    Write-Host "Checking IP for matching scope..."
    foreach ($scope in $dhcpTable.Keys) {
        #Write-Host "Checking if $ip starts with $scope"
        if ($ip.StartsWith($scope)) {
            Write-Host "Match found: $scope"
            return $dhcpTable[$scope]
        }
    }
    return $null
}
Function get-console {   
    Write-Host ""
    Write-Host "Enter admin username for server $dhcpServer"                     
    $userName = Read-Host "  (EG; Kerncounty\admin-blowry)"
    
    # Open DHCP Console on selected server with administrator rights
    runas /noprofile /netonly /user:$userName "C:\windows\System32\mmc.exe dhcpmgmt.msc /computerName $dhcpServer"
    Write-Host "Opening DHCP Management console for server $dhcpServer..."
    start-sleep -seconds 3
    Clear-Host
 }

# Start a loop that will run until the user selects the "Exit" option
while (!$exit) {
    # Header
    Write-Host ""
    Write-Host "              *******************************               " -ForegroundColor Yellow -BackgroundColor "DarkRed"
    Write-Host "              *******************************               " -ForegroundColor Yellow -BackgroundColor "DarkRed"
    Write-Host "              ******** DHCP Launcher ********               " -ForegroundColor Yellow -BackgroundColor "DarkRed"
    Write-Host "              *******************************               " -ForegroundColor Yellow -BackgroundColor "DarkRed"
    Write-Host "              *******************************               " -ForegroundColor Yellow -BackgroundColor "DarkRed"
    Write-Host ""
    Write-Host ""


    # Ask user for IP address
    $ipAddress = Read-Host "Enter the IP address"
    
    # Execute Lookup Function
    $dhcpServer = Get-DhcpServer -ip $ipAddress                           

    Write-Host ""

    if ($dhcpserver -eq "dhcp1.dom1.dhs.co.kern.ca.us") {
        Write-Host "This is a DHS domain scope." -ForegroundColor yellow
        Write-Host "Please enter your DHS domain admin credentials." -ForegroundColor Red
        get-console

    } elseif ($dhcpserver -eq "Da-dc1.kcda.local") {
        Write-Host "This is a DA domain scope." -ForegroundColor yellow
        Write-Host "Please enter your DA domain admin credentials." -ForegroundColor Red
        get-console

    } elseif ($dhcpserver -eq "Da-dc10.kcda.local") {
        Write-Host "This is a DA domain scope." -ForegroundColor yellow
        Write-Host "Please enter your DA domain admin credentials." -ForegroundColor Red
        get-console

    } elseif ($dhcpserver -eq "ccdom.ccdomain.cc.co.kern.ca.us") {
        Write-Host "This is a County Council domain scope." -ForegroundColor yellow
        Write-Host "Please enter your CoCo domain admin credentials." -ForegroundColor Red
        get-console

    } elseif ($dhcpserver -eq "krcl-dc10.lab.da.co.kern.ca.us") {
        Write-Host "This is a CrimeLab domain scope." -ForegroundColor yellow
        Write-Host "Please enter your CrimeLab domain admin credentials." -ForegroundColor Red
        get-console

    } elseif ($dhcpserver -eq "dc04.kernbhrs.local") {
        Write-Host "This is a BHRS domain scope." -ForegroundColor yellow
        Write-Host "Please enter your BHRS domain admin credentials." -ForegroundColor Red
        get-console

    } elseif ($dhcpserver -eq "asr-dc8.assessor.internal") {
        Write-Host "This is a Assessors domain scope." -ForegroundColor yellow
        Write-Host "Please enter your Assessors domain admin credentials." -ForegroundColor Red
        get-console
        
    } elseif ($dhcpserver -eq "eims-dc-02.elections.accc.co.kern.ca.us") {
        Write-Host "This is an Elections domain scope." -ForegroundColor yellow
        Write-Host "Please enter your Elections domain admin credentials." -ForegroundColor Red
        get-console
                    
    } elseif ($dhcpserver -eq "phdhcp01.phdom.local") {
        Write-Host "This is a PH domain scope." -ForegroundColor yellow
        Write-host "Please enter your PH domain admin credentials." -ForegroundColor Red
        get-console

    } elseif ($dhcpserver -eq "dns1.its.co.kern.ca.us") {
        Write-Host "This is a Kern County domain scope." -ForegroundColor yellow
        Write-Host "Please use local admin credentials for Its-dns1-win2016 (Securden)." -ForegroundColor Red
        get-console

    } elseif ($dhcpserver -eq "auddc02.accc.co.kern.ca.us") {
        Write-Host "This is a Auditor domain scope." -ForegroundColor yellow
        Write-Host "Please enter your ACCC domain admin credentials." -ForegroundColor Red
        get-console

    } elseif ($dhcpserver -eq "etrdc1.kerncounty.com") {
        Write-Host "This is an ETR domain scope." -ForegroundColor yellow
        Write-Host "Please enter your KernCounty domain admin credentials." -ForegroundColor Red
        get-console
    
    } elseif ($dhcpserver -eq "psbnvr02.kerncounty.com") {
        Write-Host "This is an PSB domain scope." -ForegroundColor yellow
        Write-Host "Please enter your KernCounty domain admin credentials." -ForegroundColor Red
        get-console
    
    } else {
        Write-Host "No matching DHCP server found for IP address $ipAddress" -ForegroundColor Red
        Write-Host ""
        Write-Host "Would you like to try again? (Y/N)"
        $response = Read-Host
        if ($response -ne "Y") {
            $exit = $true
        } Else {
            Clear-Host
        }
    }
}  

