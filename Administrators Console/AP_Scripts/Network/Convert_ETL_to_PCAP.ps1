# Define paths
$etlFilePath = read-host "Enter the path to the .etl file you want to convert to .pcap"
$pcapFilePath = read-host "Enter the path where you want to save the .pcap file"

# Path to the etl2pcapng.exe tool
$etl2pcapngPath = "C:\Program Files\etl2pcapng\etl2pcapng.exe"

# Run the conversion
Start-Process -FilePath $etl2pcapngPath -ArgumentList "$etlFilePath $pcapFilePath" -NoNewWindow -Wait

Write-Host "Conversion completed. The .pcap file is located at $pcapFilePath"
