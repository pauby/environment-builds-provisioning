[CmdletBinding()]
Param (
    [switch]
    $UseLocalSource,

    [string]
    $Version,

    [switch]
    $Force
)

# only install Chocolatey if it's not installed
# Note that in the newer versions of Chocolatey the install script will stop
# if it detects files / folders in the default Chocolatey install location.
# So Chocolatey won't be installed again but all of the configuration below
# will run.
if (-not (Get-Command -Name 'choco' -ErrorAction  SilentlyContinue) -or $Force.IsPresent) {

    # PowerShell will not set this by default (until maybe .NET 4.6.x). This
    # will typically produce a message for PowerShell v2 (just an info
    # message though)
    try {
        # Set TLS 1.2 (3072) as that is the minimum required by Chocolatey.org.
        # Use integers because the enumeration value for TLS 1.2 won't exist
        # in .NET 4.0, even though they are addressable if .NET 4.5+ is
        # installed (.NET 4.5 is an in-place upgrade).
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    }
    catch {
        Write-Output 'Unable to set PowerShell to use TLS 1.2. This is required for contacting Chocolatey Community Repository as of 03 FEB 2020. https://chocolatey.org/blog/remove-support-for-old-tls-versions. If you see underlying connection closed or trust errors, you may need to do one or more of the following: (1) upgrade to .NET Framework 4.5+ and PowerShell v3+, (2) Call [System.Net.ServicePointManager]::SecurityProtocol = 3072; in PowerShell prior to attempting installation, (3) specify internal Chocolatey package location (set $env:chocolateyDownloadUrl prior to install or host the package internally), (4) use the Download + PowerShell method of install. See https://chocolatey.org/docs/installation for all install options.'
    }

    # From https://chocolatey.org/install
    $installScript = Join-Path -Path $env:TEMP -ChildPath "$(([GUID]::NewGuid()).Guid.ToString()).ps1"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing -OutFile $installScript
    & $installScript

    #Update-SessionEnvironment
    choco feature enable --name='autouninstaller'
    # - not recommended for production systems:
    choco feature enable --name='allowGlobalConfirmation'
    # - not recommended for production systems:
    choco feature enable --name='logEnvironmentValues'
    choco feature enable --name='useRememberedArgumentsForUpgrades'
    choco feature disable --name='exitOnRebootDetected'
    # Set Configuration
    choco config set cacheLocation $env:ALLUSERSPROFILE\chocolatey\choco-cache
    choco config set commandExecutionTimeoutSeconds 14400
    choco feature disable -n=showDownloadProgress
    choco feature disable -n=LogValidationResultsOnWarnings

    if ($UseLocalSource.IsPresent) {
        Write-Host "Using local '$($env:SystemDrive)\packages' folder as priority 1 install location."
        # Sources - Add internal repositories
        choco source add --name="'local'" --source="'$($env:SystemDrive)\resources\packages'" --priority="'1'" --bypass-proxy --allow-self-service

        # Sources - change priority of community repository
        #Write-Output "Using Chocolatey Community Repository as priority 20 install location."
        #choco source remove --name="'chocolatey'"
        #choco source add --name='chocolatey' --source='https://chocolatey.org/api/v2/' --priority='20' --bypass-proxy
    }

    # if we supply a version then install that using Chocolatey
    if ($Version) {
        choco upgrade chocolatey --version $Version --allow-downgrade --prerelease -y --no-progress --limit-output
    }
}
else {
    Write-Host 'Chocolatey already installed. Nothing to do.'
    choco --version
}