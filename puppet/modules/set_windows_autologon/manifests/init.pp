class set_windows_autologon {

  #
  # ConfigureAutoLogin
  #
  #     * string => REG_SZ
  #     * array  => REG_MULTI_SZ
  #     * expand => REG_EXPAND_SZ
  #     * dword  => REG_DWORD
  #     * qword  => REG_QWORD
  #     * binary => REG_BINARY

  registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon':
    ensure => present,
    type   => dword,
    data   => 1,
  }

  registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultUserName':
    ensure => present,
    type   => string,
    data   => 'vagrant',
  }

  registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultPassword':
    ensure => present,
    type   => string,
    data   => 'vagrant',
  }

  registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogonCount':
    ensure => absent
  }

  #
  # Prepare Windows
  #

  ie_esc { 'IE ESC Configuration':
    ensure => absent
  }

  # Stop and disable Windows Updates
  service { 'wuauserv':
    ensure => stopped,
    enable => manual
  }

  registry_key { 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU':
    ensure => present
  }

  registry_value { 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoUpdate':
    ensure => present,
    type   => dword,
    data   => 1
  }

  # create Windows PowerShell profile
  file { 'c:\users\vagrant\Documents\WindowsPowerShell':
    ensure => directory
  }

  file { 'c:\users\vagrant\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1':
    ensure  => file,
    require => File['c:\users\vagrant\Documents\WindowsPowerShell'],
  }
}
