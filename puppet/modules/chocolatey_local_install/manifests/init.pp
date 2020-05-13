class chocolatey_local_install (
  $chocolatey_folder = '/resources/assets/chocolatey'
) {

  # make sure we have the
  # $windows_temp = $facts['windows_env']['APPDATA']
  # $extract_path = "${windows_temp}/chocolatey.latest-install"
  $windows_systemdrive = $facts['windows_env']['SYSTEMDRIVE']
  # $source_zip = "${windows_systemdrive}${chocolatey_zip}"

  # we're not extracting the nupkg
  # file { $extract_path:
  #   ensure => directory,
  #   recurse => true,
  #   purge => true,
  #   force => true,
  # }

  # archive { $source_zip:
  #   ensure => present,
  #   extract => true,
  #   extract_path => $extract_path,
  #   cleanup => false,
  #   require => File[$extract_path],
  # }

  $tools_folder = "${windows_systemdrive}${chocolatey_folder}/tools"
  $chocolatey_install_script = "${tools_folder}/chocolateyInstall.ps1"
  exec { 'install-chocolatey':
    provider => 'powershell',
    command  => "& ${chocolatey_install_script}",
    onlyif   => 'Get-Command -Command "choco.exe" -ErrorAction SilentlyContinue'
  }

  # Ensuring chocolatey commands are on the path
  $windows_allusersprofile = $facts['windows_env']['ALLUSERSPROFILE']
  $default_chocolatey_install_location = "${windows_allusersprofile}\\Chocolatey"
  windows_env { 'ChocolateyInstall':
    ensure    => present,
    value     => $default_chocolatey_install_location,
  }

  $default_chocolatey_bin_path = "${default_chocolatey_install_location}\\bin"
  windows_env { 'Path':
    ensure    => present,
    value     => $default_chocolatey_bin_path,
  }

}
# Keeping this here in case we need it

# Write-Output 'Ensuring chocolatey.nupkg is in the lib folder'
# $chocoPkgDir = Join-Path $chocoPath 'lib\chocolatey'
# $nupkg = Join-Path $chocoPkgDir 'chocolatey.nupkg'
# if (![System.IO.Directory]::Exists($chocoPkgDir)) { [System.IO.Directory]::CreateDirectory($chocoPkgDir); }
# Copy-Item "$file" "$nupkg" -Force -ErrorAction SilentlyContinue
