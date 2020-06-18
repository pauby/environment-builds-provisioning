class pauby_vagrant_provision::win_console_autologon (
  Enum['enable', 'disable'] $ensure   = enable,{
  String                    $username = 'vagrant',
  String                    $password = 'vagrant'
) {

  if $ensure == enable {
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
  else {
    registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon':
      ensure => absent,
    }
  }
}
