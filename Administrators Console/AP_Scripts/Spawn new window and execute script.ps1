<##### Spawn a New PS Window and execute commands #####
######             By Brian Lowry                 #####>

invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
#Set Environment Values
    cd -path $env:homedrive/scripts/;
    [console]::windowwidth=65;
	[console]::windowheight=3;
	[console]::bufferwidth=[console]::windowwidth;
	$host.UI.RawUI.BackgroundColor=yellow;
    $host.UI.RawUI.ForegroundColor=blue;
    $host.UI.RawUI.WindowTitle="Process Timer";
    Clear-host;
#Execute Stopwatch
    $stopWatch = [system.diagnostics.stopwatch]::startNew();
    [int]$elapsed = $stopWatch.Elapsed.TotalSeconds;
    While ($True) {
        Clear-host;
        Write-host "current duration is " -NoNewline -f Yellow;
        Write-Host "$stopWatch.Elapsed.TotalSeconds " -f red;
        #Write-Host "Seconds". -f Yellow;
        Start-Sleep -Seconds 1
    }
    #Start-Sleep -Seconds 1;
}'; 