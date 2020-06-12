class pauby_vagrant_provision::win_console_autologon_enable (
  String $username = 'vagrant',
  String $password = 'vagrant'
) {

  registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon':
    ensure => present,
    type   => dword,
    data   => 1,
  }

  registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultUserName':
    ensure => present,
    type   => string,
    data   => $username,
  }

  registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultPassword':
    ensure => present,
    type   => string,
    data   => $password,
  }

  registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogonCount':
    ensure => absent
  }
}
