[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string]
    $String,

    [string]
    $OutputPath
)

$secureString = ConvertTo-SecureString -String $String
Set-Content -Path $OutputPath -Value ([System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($secureString)))
