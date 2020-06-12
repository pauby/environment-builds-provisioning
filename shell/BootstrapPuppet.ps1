[CmdletBinding()]
param (
    [String]
    $PuppetInstallerPath = 'c:\assets\puppet-agent.msi',

    # Running the installer from a synced folder doesn't work (at least in Hyper V).
    # To get around this we copy the installer to a temp folder and execute from there.
    # This switch stiops this behvaiour and runs the installer wherever it lives.
    [Switch]
    $DoNotCopyBeforeInstall
)

# configure WinRM
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'

# Install Puppet if it's not already installed
if (-not (Get-Command -Name 'puppet' -ErrorAction SilentlyContinue)) {
Write-Host "Installing Puppet ..."

if (Test-Path -Path $PuppetInstallerPath) {
    if ($DoNotCopyBeforeInstall.IsPresent) {
        $installerPath = $PuppetInstallerPath
    }
    else {
        # copy the installer BEFORE running it
        Write-Verbose 'Copying installer to temporary location before executing ...'
        $installerPath = Join-Path -Path $env:TEMP -ChildPath ("{0}.msi" -f ([GUID]::NewGuid()).Guid)
        $null = Copy-Item -Path $PuppetInstallerPath -Destination $tempInstallerPath -Force
    }

    Start-Process -FilePath $installerPath -ArgumentList "/qn", "/norestart", "/l*v pp.log" -Wait
}
else {
    Write-Error "Puppet agent not found at '$puppetPath'. Throwing."
}
