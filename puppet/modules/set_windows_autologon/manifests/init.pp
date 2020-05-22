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
}
