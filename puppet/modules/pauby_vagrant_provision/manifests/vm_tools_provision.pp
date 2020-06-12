class pauby_vagrant_provision::vm_tools_provision {

  include chocolatey

  # TODO Need to add Linux code in here
  if $facts['is_virtual'] and $facts['hypervisors']['virtualbox'] {
    package { 'virtualbox-guest-additions-guest.install':
      ensure   => present,
      provider => 'chocolatey',
    }
  }
}
