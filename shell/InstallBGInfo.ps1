choco upgrade bginfo -y

$src = 'c:\assets\bginfo.bgi'
$dest = 'C:\programdata\chocolatey\lib\bginfo\tools\bginfo.bgi'

Copy-Item -Path $src -Destination $dest
Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name bginfo -Value "c:\programdata\chocolatey\lib\bginfo\tools\bginfo.exe $dest /accepteula /silent /timer:0"