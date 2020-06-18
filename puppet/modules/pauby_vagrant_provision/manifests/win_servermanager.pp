class pauby_vagrant_provision::win_servermanager (
  Enum['enable', 'disable'] $ensure = enable,
) {

  if $ensure == enable {
    fail ('Disabling ServerManager has not been implemented yet!')
  }
  else {
    if $facts['os']['windows']['installation_type'] == 'Server' {
      scheduled_task { 'ServerManager':
        ensure => absent
      }
    }
  }
}
