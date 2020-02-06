if ((-not (Get-Command -Name 'Get-PackageProvider' -ErrorAction SilentlyContinue)) -or
    ($null -eq (Get-PackageProvider | Where Name -eq 'nuget'))) {
    $null = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Write-Host 'Bootstrapping NuGet package provider.'
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
}

if ((Get-PsRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Write-Host "Trusting PowerShell Gallery."
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

# Need the latest version of PowerShellGet Because the module ships with Windows
# 10 / 2016 and not from the PS Gallery we can't simply update it so we must
# install it.
'powershellget' | ForEach-Object {
    Remove-Module -Name $_ -Force -ErrorAction SilentlyContinue
    Install-Module -Name $_ -SkipPublisherCheck -AllowClobber -Force -Scope AllUsers
}