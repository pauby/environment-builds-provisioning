# this could easily be done with a simple `chocolateysource` but it's here really for the defaults to be used with one
# line in the provisioning file.
class pauby_vagrant_provision::win_chocolatey_source_local_add (
  String $source_local_packages_path = 'c:/resources/packages'
) {

  $path_exists = find_file($source_local_packages_path)

  if ($path_exists) {
    chocolateysource { 'local':
      ensure   => present,
      location => $source_local_packages_path,
      priority => 1,
    }
  }
}
