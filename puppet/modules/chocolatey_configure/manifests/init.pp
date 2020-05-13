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

  chocolateyconfig { 'cachelocation':
    value  => "c:\\programdata\\choco-cache",
  }

  chocolateyconfig { 'commandExecutionTimeoutSeconds':
    value  => '14400',
  }

  chocolateysource { 'local':
    ensure   => present,
    location => 'c:\\resources\\packages',
    priority => 1
  }

  chocolateysource { 'chocolatey':
    ensure => disabled,
  }
}
