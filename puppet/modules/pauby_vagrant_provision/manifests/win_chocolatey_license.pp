class pauby_vagrant_provision::win_chocolatey_license (
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String]          $source = undef,
  Optional[String]          $chocolatey_install = undef,
) {

  if $chocolatey_install == undef {
    # use default installation path
    $programdata = $facts['windows_env']['PROGRAMDATA']
    $license_folder = "${programdata}\\chocolatey\\license"
  }
  else {
    # TODO this does not take into account trailing slashes that may be passed in
    $license_folder = "${chocolatey_install}\\chocolatey\\license"
  }

  $license_file = "${license_folder}\\chocolatey.license.xml"

  if $ensure == 'present' {
    if $source == undef {
      fail ("pauby_vagrant_provision::win_chocolatey_license[${name}]: \$source not provided!")
    }

    file { $license_folder:
      ensure => directory,
    }

    # copy the license file over
    file { $license_file:
      source  => $source,
      require => File[$license_folder],
    }
  }
  else {
    # absent
    file { $license_folder:
      ensure => absent,
      force => true,
    }
  }
}
