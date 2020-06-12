class pauby_vagrant_provision::win_console_autologon_disable {

  registry_value { 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon':
    ensure => absent,
  }
}
