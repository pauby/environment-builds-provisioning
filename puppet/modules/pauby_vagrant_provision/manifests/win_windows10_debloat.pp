class pauby_vagrant_provision::win_windows10_debloat {

  if $facts['os']['name'] == 'Windows' and $facts['os']['release']['full'] == 10 {
    archive { 'c:\\users\\vagrant\\Documents\\debloat.ps1':
      source => 'https://raw.githubusercontent.com/Sycnex/Windows10Debloater/master/Windows10SysPrepDebloater.ps1',
    }

    #TODO This may be required to run in the user context - YMMV
    exec { 'run-debloat-script':
      provider => powershell,
      command  => "& c:\\users\\vagrant\\Documents\\debloat.ps1 -Debloat",
      require  => Archive['c:\\users\\vagrant\\Documents\\debloat.ps1']
    }
  }
