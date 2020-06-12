# Disables Windows Updates

class pauby_vagrant_provision::win_updates_disable {

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
