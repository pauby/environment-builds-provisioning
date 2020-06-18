# Disables Windows Updates

class pauby_vagrant_provision::win_updates (
  Enum['enable', 'disable'] $ensure = 'disable',
) {

  if $ensure == 'enable' {
    # TODO I believe the settings for enabling are correct - needs to be checked
    # Stop and disable Windows Updates
    service { 'wuauserv':
      ensure => running,
      enable => true,
    }

    registry_key { 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU':
      ensure => absent,
      notify => Service['wuauserv'],
    }
  }
  else {
    # Stop and disable Windows Updates
    service { 'wuauserv':
      ensure => stopped,
      enable => 'manual',
    }

    registry_key { 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU':
      ensure => present
    }

    registry_value { 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoUpdate':
      ensure => present,
      type   => dword,
      data   => 1
    }
  }
}
