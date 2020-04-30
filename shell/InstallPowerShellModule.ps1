[CmdletBinding()]
Param (
    [hashtable[]]
    $Module
)

# Bootstrap the package provider

if (-not (Get-Command -Name 'Get-PackageProvider' -ErrorAction SilentlyContinue)) {
    $null = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Write-Verbose 'Bootstrapping NuGet package provider.'
    Get-PackageProvider -Name NuGet -ForceBootstrap -Force | Out-Null
}

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

$Module | ForEach-Object {
    Install-Module @_
}

