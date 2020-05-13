class configure_windows_networking {

  # Configuring firewall
  windows_firewall_group { 'Network Discovery':
    enabled => true
  }

  windows_firewall_group { 'File and Printer Sharing':
    enabled => true
  }

  # Set network interface to private network type
  exec { 'set-network-interface-private':
    provider => powershell,
    command  => "Get-NetAdapter | ForEach-Object { Get-NetConnectionProfile -ErrorAction Stop | Where-Object { \$_.NetworkCategory -ne 'Private' } | Set-NetConnectionProfile -NetworkCategory Private -ErrorAction Stop }",
    unless   => "exit (Get-NetAdapter | ForEach-Object { Get-NetConnectionProfile | Where-Object { \$_.NetworkCategory -ne 'Private' } }).count"
  }
}
