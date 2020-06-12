class pauby_vagrant_provision::win_bginfo_provision (
  # we can't check the environment variable CHOCOLATEY_INSTALL as widnows_env doesn't exose it. We can't use a custom
  # fact as it will be available on the first run. So let's define it and allow it to be overridden.
  $chocolatey_install_path = 'c:/programdata/chocolatey',

  # this is the path to the bginfo.bgi we have created
  $config_source_file = 'c:/assets/bginfo.bgi',

  # If this is true a batch file is created on the desktop which simply runs bginfo - useful if you resize a VM window
  # and bginfo goes wonky.
  $create_desktop_script = true,
) {

  include chocolatey

  # Install BGInfo
  package { 'bginfo':
    ensure   => present,
    provider => 'chocolatey',
  }

  $bginfo_destination = "${chocolatey_install_path}/lib/bginfo/tools/bginfo.bgi"
  file { $bginfo_destination:
    ensure  => file,
    source  => $config_source_file,
    require => Package['bginfo'],
  }

  $bginfo_command = "${chocolatey_install_path}/lib/bginfo/tools/bginfo.exe ${chocolatey_install_path}/lib/bginfo/tools/bginfo.bgi /accepteula /silent /timer:0"
  registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\bginfo':
    ensure  => present,
    type    => string,
    data    => $bginfo_command,
    require => File[$bginfo_destination],
  }

  # TODO Need to use the AllUser profile path from environment variables
  if $create_desktop_script == true {
    $public_profile = $facts['windows_env']['PUBLIC']
    $public_desktop = "${public_profile}/Desktop"

    file { $public_desktop:
      ensure => directory,
    }

    $script_file = "${public_desktop}/RefreshBgInfo.bat"
    file { $script_file:
      ensure  => file,
      content => $bginfo_command,
    }
  }
}
