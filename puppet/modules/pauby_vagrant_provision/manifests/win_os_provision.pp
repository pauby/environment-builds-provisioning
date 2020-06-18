class pauby_vagrant_provision::win_os_provision {

  # Disable IE Security
  ie_esc { 'IE ESC Configuration':
    ensure => absent
  }

  class { 'pauby_vagrant_provision::win_updates':
    ensure => 'disable',
  }

  class { 'pauby_vagrant_provision::win_networking_profile':
    profile_type             => 'private',
    network_discovery        => false,
    file_and_printer_sharing => false,
  }

  class { 'pauby_vagrant_provision::win_servermanager':
    ensure => 'disable',
  }

  include pauby_vagrant_provision::vm_tools_provision
}
