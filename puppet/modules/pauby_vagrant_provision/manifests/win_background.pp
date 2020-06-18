class pauby_vagrant_provision::win_background (
  Enum['present', 'absent']             $ensure = 'present',
  Enum['lockscreen', 'desktop', 'both'] $enable = 'desktop',
  Optional[String]                      $image  = undef,
) {

  if $ensure == 'present' {
    if $image == undef {
      fail ("pauby_vagrant_provision::win_background[${name}]: \$image must be specified")
    }

    registry_key { 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP':
      ensure => present
    }

    if $enable == 'lockscreen' or $enable == 'both' {
      # lock screen - https://docs.microsoft.com/en-us/windows/client-management/mdm/personalization-csp
      registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP\LockScreenImageStatus':
        ensure => present,
        type   => dword,
        data   => 1
      }

      registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP\LockScreenImagePath':
        ensure => present,
        type   => string,
        data   => $image,
      }
    }

    if $enable == 'desktop' or $enable == 'both' {
      # desktop background - https://docs.microsoft.com/en-us/windows/client-management/mdm/personalization-csp
      registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP\DesktopImageStatus':
        ensure => present,
        type   => dword,
        data   => 1
      }

      registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP\DesktopImagePath':
        ensure => present,
        type   => string,
        data   => $image,
      }
    }
  }
  else {
    # we need to disable

    if $enable == 'both' {
      # shortcut to removing both - just removing the whole key
      registry_key { 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP':
        ensure => absent,
      }
    }
    elsif $enable == 'lockscreen' {
      registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP\LockScreenImageStatus':
        ensure => absent,
      }

      registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP\LockScreenImagePath':
        ensure => absent,
      }
    }
    elsif $enable == 'desktop' {
      registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP\DesktopImageStatus':
        ensure => absent,
      }

      registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP\DesktopImagePath':
        ensure => absent,
      }
    }
  } # else
}
