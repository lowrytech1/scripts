<#####         Spawn a New PS Window              #####
######             By Brian Lowry                 #####>

invoke-expression 'cmd /c start powershell.exe -NoExit -Command {
#Set Environment Values
    #cd -path $env:homedrive/scripts/;
    [console]::windowwidth=65;
	[console]::windowheight=50;
	[console]::bufferwidth=[console]::windowwidth;
	#$host.UI.RawUI.BackgroundColor="blue";
    #$host.UI.RawUI.ForegroundColor="yellow";
    $host.UI.RawUI.WindowTitle="Powershell- Enter your command";
    Clear-host;
}'