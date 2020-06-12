class pauby_vagrant_provision::win_networking_configure (
  Enum['public', 'private'] $profile_type = 'private',
  Boolean                   $network_discovery = false,
  Boolean                   $file_and_printer_sharing = false,
) {

  # Configuring firewall
  windows_firewall_group { 'Network Discovery':
    enabled => $network_discovery,
  }

  windows_firewall_group { 'File and Printer Sharing':
    enabled => $file_and_printer_sharing,
  }

  # Set network interface to private network type
  exec { 'set-network-interface-public':
    provider => powershell,
    command  => "Get-NetAdapter | ForEach-Object { Get-NetConnectionProfile -ErrorAction Stop | Where-Object { \$_.NetworkCategory -ne '${profile_type}' } | Set-NetConnectionProfile -NetworkCategory ${profile_type} -ErrorAction Stop }",
    unless   => "exit (Get-NetAdapter | ForEach-Object { Get-NetConnectionProfile | Where-Object { \$_.NetworkCategory -ne '${profile_type}' } }).count"
  }
}
