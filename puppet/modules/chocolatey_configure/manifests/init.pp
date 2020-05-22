class chocolatey_configure {

  include chocolatey

  chocolateyfeature { 'autouninstaller':
    ensure => enabled,
  }

  chocolateyfeature { 'allowGlobalConfirmation':
    ensure => enabled,
  }

  chocolateyfeature { 'logEnvironmentValues':
    ensure => enabled,
  }

  chocolateyfeature { 'LogValidationResultsOnWarnings':
    ensure => disabled,
  }

  # Recommend https://forge.puppet.com/puppetlabs/chocolatey#disable-use-package-exit-codes
  chocolateyfeature { 'usepackageexitcodes':
    ensure => disabled,
  }

  $windows_programdata = $facts['windows_env']['ALLUSERSPROFILE']
  $chocolatey_cache_path = "${windows_programdata}/choco-cache"

  chocolateyconfig { 'cachelocation':
    value  => $chocolatey_cache_path,
  }

  chocolateyconfig { 'commandExecutionTimeoutSeconds':
    value  => '14400',
  }

  $windows_systemdrive = $facts['windows_env']['SYSTEMDRIVE']
  $chocolatey_local_source_path = "${windows_systemdrive}/resources/packages"
  chocolateysource { 'local':
    ensure   => present,
    location => $chocolatey_local_source_path,
    priority => 1,
  }
}
