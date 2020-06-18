class pauby_vagrant_provision::powershell_profile_provision (
  Enum['present', 'absent'] $ensure     = present,
  Enum['windows', 'core']   $ps_edition = 'windows'
) {

  $user_profile = $facts['windows_env']['USERPROFILE']

  if $ps_edition == 'windows' {
    $path = "${user_profile}/Documents/WindowsPowerShell"
  }
  else {
    $path = "${user_profile}/Documents/PowerShell"
  }

  # path to the PowerShell profile
  $profile_path = "${path}/Microsoft.PowerShell_profile.ps1"

  if $ensure == 'present' {
    # create empty Windows PowerShell profile
    # TODO Need to get the correct paths here from environment variables
    file { $path:
        ensure => directory
    }

    # TODO Need to get the correct paths here from environment variables
    file { $profile_path:
      ensure  => file,
      require => File[$path],
    }
  }
  else {
    file { $profile_path:
      ensure  => absent,
    }
  }
}
