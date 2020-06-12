class pauby_vagrant_provision::win_chocolatey_configuration_standard (
  Enum['enabled', 'disabled'] $feature_autouninstaller = enabled,
  Enum['enabled', 'disabled'] $feature_allow_global_confirmation = enabled,
  Enum['enabled', 'disabled'] $feature_log_environment_values = enabled,
  Enum['enabled', 'disabled'] $feature_log_validation_results_on_warnings = disabled,
  Enum['enabled', 'disabled'] $feature_use_package_exit_codes = disabled,
  String                      $config_cache_location = 'c:/programdata/choco-cache',
  String                      $config_command_execution_timeout_seconds = '14400',
) {

  include chocolatey

  chocolateyfeature { 'autouninstaller':
    ensure => $feature_autouninstaller,
  }

  chocolateyfeature { 'allowGlobalConfirmation':
    ensure => $feature_allow_global_confirmation,
  }

  chocolateyfeature { 'logEnvironmentValues':
    ensure => $feature_log_environment_values,
  }

  chocolateyfeature { 'LogValidationResultsOnWarnings':
    ensure => $feature_log_validation_results_on_warnings,
  }

  # Recommend https://forge.puppet.com/puppetlabs/chocolatey#disable-use-package-exit-codes
  chocolateyfeature { 'usepackageexitcodes':
    ensure => $feature_use_package_exit_codes,
  }

  chocolateyconfig { 'cachelocation':
    value  => $config_cache_location,
  }

  chocolateyconfig { 'commandExecutionTimeoutSeconds':
    value  => $config_command_execution_timeout_seconds,
  }
}
