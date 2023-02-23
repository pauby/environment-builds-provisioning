$keys = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer', 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'

try {
    $keys | ForEach-Object {
        if (-not (Test-Path -Path $_)) {
            New-Item -Path $_ | Out-Null
        }
        Set-ItemProperty -Path $_ -Name 'HideClock' -Value 1
    }
}
catch {
    # lets not write an error as it will stop the Vagrant provisioning
    Write-Warning 'There was a problem writing one of the registry keys.'
    $error[0]
}

# when this runs the explorer process may not be available, or Vagrant doesn't have access to it. Ignore errors.
Get-Process -Name 'explorer' -ErrorAction SilentlyContinue | Stop-Process