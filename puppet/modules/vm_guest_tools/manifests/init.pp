class vm_guest_tools {

  if $facts['is_virtual'] and $facts['hypervisors']['virtualbox'] {
    package { 'virtualbox-guest-additions-guest.install':
      ensure   => present,
      provider => 'chocolatey',
    }
  }
}
