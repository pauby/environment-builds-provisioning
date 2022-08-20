$provider = (Get-WmiObject -Class Win32_ComputerSystem).Model

switch ($provider) {
    "virtualbox" {
        choco upgrade virtualbox-guest-additions-guest.install -y
    }
}