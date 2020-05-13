class prepare_windows {

  include set_windows_autologon

# # Fix WinRM
# # TODO this doesn't work from Puppet
# #exec { 'WinRmMaxMemoryPerShell':
# #  command => "c:\\windows\\system32\\winrm.cmd set winrm/config/winrs \'@{MaxMemoryPerShellMB=\"2048\"}\'"
# #}

# # Set Explorer preferences
# # TODO This doesn't work as the keys don't exist in HKU and the Puppet resource can't manage HKCU
# # this would have to be a script to run at logon for the user

  include configure_windows_networking

  if $facts['os']['windows']['installation_type'] == 'Server' {
    scheduled_task { 'ServerManager':
      ensure => absent
    }
  }

  # if $facts['os']['name'] == 'Windows' and $facts['os']['release']['full'] == 10 {
  #   archive { 'c:\\users\\vagrant\\Documents\\debloat.ps1':
  #     source => 'https://raw.githubusercontent.com/Sycnex/Windows10Debloater/master/Windows10SysPrepDebloater.ps1',
  #   }

    # TODO This needs to be run in the user context
    # exec { 'run-debloat-script':
    #   provider => powershell,
    #   command => "& c:\\users\\vagrant\\Documents\\debloat.ps1 -Debloat",
    #   require => Archive['c:\\users\\vagrant\\Documents\\debloat.ps1']
    # }
  #}

  include vm_guest_tools

  include setup_bginfo
}
