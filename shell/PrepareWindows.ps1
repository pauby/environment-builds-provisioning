[CmdletBinding()]
Param (
    [switch]
    $CleanupWindows10
)

# set TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072

# Adapted from http://stackoverflow.com/a/29571064/18475
# Get the OS
$osData = Get-CimInstance -ClassName Win32_OperatingSystem

# check if we have Internet Explorer installed
if ([bool](Get-Command -Name 'iexplore.exe'  -ErrorAction SilentlyContinue)) {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    if (Test-Path $AdminKey) {
        New-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force | Out-Null
        Write-Output "IE Enhanced Security Configuration (ESC) has been disabled for Admin."
    }

    if (Test-Path $UserKey) {
        New-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force | Out-Null
        Write-Output "IE Enhanced Security Configuration (ESC) has been disabled for User."
    }

    # http://techrena.net/disable-ie-set-up-first-run-welcome-screen/
    $key = "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main"
    if (Test-Path $key) {
        New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 1 -PropertyType "DWord" -Force | Out-Null
        Write-Output "IE first run welcome screen has been disabled."
    }
}

Write-Output 'Stopping Windows Update service and setting to Manual startup type.'
Stop-Service wuauserv -Passthru | Set-Service -StartupType Manual

Write-Output 'Disable Windows Automatic Updates'
# see https://support.microsoft.com/en-gb/help/328010/how-to-configure-automatic-updates-by-using-group-policy-or-registry-s
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'NoAutoUpdate' -Value 1 -Force | Out-Null

# Ensure there is a profile file so we can get tab completion
New-Item -ItemType Directory $(Split-Path $profile -Parent) -Force | Out-Null
Set-Content -Path $profile -Encoding UTF8 -Value "" -Force

winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}' | Out-Null

# Server Core does not have Explorer.exe
if ([bool](Get-Command -Name 'explorer.exe' -ErrorAction SilentlyContinue)) {
    # Set Explorer Preferences
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
    $advancedKey = "$key\Advanced"
    Set-ItemProperty -Path $advancedKey -Name 'Hidden' -Value 1
    Set-ItemProperty -Path $advancedKey -Name 'HideFileExt' -Value 0
    Set-ItemProperty -Path $advancedKey -Name 'ShowSuperHidden' -Value 1

    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $parts = $identity.Name -split "\\"
    $user = @{Domain = $parts[0]; Name = $parts[1]}

    try {
        try {
            $explorer = Get-Process -Name 'explorer' -ErrorAction Stop -IncludeUserName
        }
        catch {
            $global:error.RemoveAt(0)
        }

        if ($null -ne $explorer) {
            $explorer | Where-Object { $_.UserName -eq "$($user.Domain)\$($user.Name)"} |
                Stop-Process -Force -ErrorAction Stop | Out-Null
        }

        Start-Sleep -Seconds 1

        if (!(Get-Process -Name 'explorer' -ErrorAction SilentlyContinue)) {
            $global:error.RemoveAt(0)
            Start-Process -FilePath explorer
        }
    }
    catch {$global:error.RemoveAt(0)}
}

# Enable Network Discovery and File and Print Sharing
# Taken from here: http://win10server2016.com/enable-network-discovery-in-windows-10-creator-edition-without-using-the-netsh-command-in-powershell

Write-Host "Enabling Network Discovery."
try {
    $null = Get-NetFirewallRule -DisplayGroup 'Network Discovery' -ErrorAction Stop | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true -PassThru -ErrorAction Stop
}
catch {
    Write-Warning "Could not enable Network Discovery."
}

Write-Host "Enabling File and Printer Sharing."
try {
    $null = Get-NetFirewallRule -DisplayGroup 'File and Printer Sharing' -ErrorAction Stop | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true -PassThru -ErrorAction Stop
}
catch {
    Write-Warning "Could not enable File and Printer Sharing."
}

Write-Host 'Setting interfaces to private network type.'
try {
    Get-NetAdapter | ForEach-Object {
        Write-Host "Setting '$($_.Name)' interface to a 'Private' network."
        Get-NetConnectionProfile -InterfaceIndex $_.ifIndex -ErrorAction Stop | Set-NetConnectionProfile -NetworkCategory Private -ErrorAction Stop
    }
}
catch {
    Write-Warning "Unable to set interface."
}

# Only for Server OS with ServerManager
if ([bool](Get-Command -Name 'servermanager.exe' -ErrorAction SilentlyContinue) -and $osData.ProductType -eq 3) {
    Write-Host 'Disabling Server Manager for starting at login.'
    Get-ScheduledTask -TaskName 'ServerManager' | Disable-ScheduledTask | Out-Null
}

if ($CleanUpWindows10.IsPresent -and $osData.Name -like "*Windows 10*") {
    # https://github.com/Sycnex/Windows10Debloater

    $debloatPath = Join-Path -Path $env:TEMP -ChildPath 'Windows10SysPrepDebloater.ps1'
    # grab the script from GitHub but if it doesn't work dont fail the vagrant up
    Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/Sycnex/Windows10Debloater/master/Windows10SysPrepDebloater.ps1' -OutFile $debloatPath -ErrorAction SilentlyContinue
    # The script generates a lot of output!
    & $debloatPath -Debloat | Out-Null

    # Write-Output "Disabling non-essential Windows services."
    # 'ajrouter', 'alg', 'appmgmt', 'appxsvc', 'bthavctpsvc', 'bits', 'btagservice', 'bthserv',
    #     'bluetoothuserservice_*', 'peerdistsvc', 'captureservice_*', 'certpropsvc', 'nfsclnt',
    #     'diagtrack', 'IpxlatCfgSvc', 'iphlpsvc', 'SharedAccess', 'irmon', 'vmicvss', 'vmictimesync',
    #     'vmicrdv', 'vmicvmsession', 'vmicheartbeat', 'vmicshutdown', 'vmicguestinterface', 'vmickvpexchange',
    #     'HvHost', 'lfsvc', 'MapsBroker', 'dmwappushsvc', 'PhoneSvc', 'SEMgrSvc', 'WpcMonSvc', 'CscService',
    #     'NcdAutoSetup', 'Netlogon', 'NaturalAuthentication', 'SmsRouter', 'MSiSCSI', 'AppVClient', 'SNMPTRAP',
    #     'SCPolicySvc', 'ScDeviceEnum', 'SCardSvr', 'SensorService', 'SensrSvc', 'SensorDataService', 'RetailDemo',
    #     'icssvc', 'WMPNetworkSvc', 'wisvc', 'wcncsvc', 'FrameServer', 'WFDSConSvc', 'WebClient', 'TabletInputService',
    #     'XboxNetApiSvc', 'XblGameSave', 'XblAuthManager', 'xbgm', 'WwanSvc' | ForEach-Object {
    #     Stop-Service -Name $_ -PassThru -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue
    # }

    # Write-Output "Stopping OneDrive."
    # Get-Process -Name OneDrive* | Stop-Process -ErrorAction SilentlyContinue 

    # if (Get-Command -Command 'Get-AppxPackage') {
    #     '*3dbuilder*', '*alarms*', '*appconnector*', '*appinstaller*', '*communicationsapps*', '*calculator*', '*camera*',
    #         '*feedback*', '*officehub*', '*getstarted*', '*skypeapp*', '*zunemusic*', '*zune*', '*maps*', '*messaging*',
    #         '*solitaire*', '*wallet*', '*connectivitystore*', '*bingfinance*', '*bing*', '*zunevideo*', '*bingnews*', 
    #         '*onenote*', '*oneconnect*', '*mspaint*', '*people*', '*commsphone*', '*windowsphone*', '*phone*', '*photos*',
    #         '*bingsports*', '*sticky*', '*sway*', '*3d*', '*soundrecorder*', '*bingweather*', '*holographic*',
    #         '*windowsstore*', '*xbox*' | ForEach-Object {
    #         Get-AppxPackage -Name $_ -AllUsers -ErrorAction SilentlyContinue | Remove-AppxPackage -Package $_ -ErrorAction SilentlyContinue
    #     }
    # }
}