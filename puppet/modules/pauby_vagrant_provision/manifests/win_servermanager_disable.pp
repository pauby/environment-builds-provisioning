class pauby_vagrant_provision::win_servermanager_disable {

  if $facts['os']['windows']['installation_type'] == 'Server' {
    scheduled_task { 'ServerManager':
      ensure => absent
    }
  }
}
