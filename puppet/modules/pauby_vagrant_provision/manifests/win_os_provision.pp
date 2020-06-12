class pauby_vagrant_provision::win_os_provision {

  # Disable IE Security
  ie_esc { 'IE ESC Configuration':
    ensure => absent
  }

  include pauby_vagrant_provision::win_updates_disable

  include pauby_vagrant_provision::win_networking_configure

  include pauby_vagrant_provision::win_servermanager_disable

  include pauby_vagrant_provision::vm_tools_provision

  include pauby_vagrant_provision::win_bginfo_provision
}
