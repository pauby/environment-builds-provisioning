class pauby_vagrant_provision::powershell_execution_policy (
  Enum['allsigned', 'bypass', 'default', 'remotesigned', 'restricted', 'undefined', 'unrestricted'] $policy =   'default',
  Enum['powershell', 'pwsh']                                                                        $provider = 'powershell',
  Enum['currentuser', 'localmachine']                                                               $scope =    'localmachine',
) {

  # TODO the opwsh provider hasn't been tested
  # It doesn't make much sense to have the scope as the 'CurrentUser' when provisioning unless this is being run in a user context
  exec { "set-executionpolicy-${policy}":
    provider => $provider,
    command  => "Set-ExecutionPolicy -ExecutionPolicy ${policy} -Scope ${scope} -Force",
    unless   => "if ((Get-ExecutionPolicy -Scope ${scope}) -ne '${policy}') { exit 1 } else { exit 0 }",
  }
}
