class setup_bginfo (
  $config_source_file = 'c:/assets/bginfo.bgi'
) {

  # Install BGInfo
  package { 'bginfo':
    ensure   => present,
    provider => 'chocolatey',
  }

  file { 'C:/programdata/chocolatey/lib/bginfo/tools/bginfo.bgi':
    ensure => file,
    source => $config_source_file,
  }

  registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\bginfo':
    ensure => present,
    type   => string,
    data   => 'c:/programdata/chocolatey/lib/bginfo/tools/bginfo.exe C:/programdata/chocolatey/lib/bginfo/tools/bginfo.bgi /accepteula /silent /timer:0'
  }
}
