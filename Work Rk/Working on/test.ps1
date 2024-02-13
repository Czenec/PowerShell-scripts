function New-ArubaConfigFile {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position =   1)]
        [System.String]
        $vlan,

        [Parameter(Mandatory = $false, Position =   2)]
        [System.String]
        $interfaceUntaggedVLAN,

        [Parameter(Mandatory = $false, Position =   3)]
        [System.String]
        $interfaceTaggedVLAN
    )

    $defaultVlan = '1'

    $vlanArray = $vlan -split ','
    $interfaceUntaggedVLANArray = $interfaceUntaggedVLAN -split '\|'

    # Initialize an empty hashtable to store the configuration for each interface
    $configurations = @{}

    for ($i = 0; $i -lt $interfaceUntaggedVLANArray.Length; $i++) {
        $interfacesUntagged = $interfaceUntaggedVLANArray[$i] -split ','
        foreach ($interface in $interfacesUntagged) {
            $vlanForInterface = $vlanArray[$i]
            if (-not $configurations.ContainsKey($interface)) {
                $configurations[$interface] = @{
                    'untaggedVlans' = @()
                    'pvid'           = ''
                }
            }
            $configurations[$interface]['untaggedVlans'] += $vlanForInterface
            $configurations[$interface]['pvid'] = $vlanForInterface
        }
    }

    # Generate the final configuration string
    $finalConfig = ""
    $keys = $configurations.Keys | Sort-Object {[int]$_}

    for ($i = 1; $i -le 10; $i++) {
        if ($keys -contains "$i") {
            $interface = $keys | Where-Object {$_ -eq "$i"}
            $finalConfig += "interface $interface`n"
            $finalConfig += " loopback-detection enable`n"
            $finalConfig += " switchport general allowed vlan add "
            foreach ($vlan in $configurations[$interface]['untaggedVlans']) {
                $finalConfig += "$vlan,"
            }
            $finalConfig += " untagged`n"
            $finalConfig += " switchport general pvid $($configurations[$interface]['pvid'])`n!`n"
        }
        elseif ($i -le 8) {
            $finalConfig += "interface $i`n"
            $finalConfig += " loopback-detection enable`n"
            $finalConfig += " switchport general allowed vlan add $defaultVlan untagged`n"
            $finalConfig += " switchport general pvid $defaultVlan`n!`n"
        }
        elseif ($i -ge 9) {
            $finalConfig += "interface $i`n"
            $finalConfig += " loopback-detection enable`n"
        }
    }

    Write-Host $finalConfig
}

# Example usage
New-ArubaConfigFile "3,50,249" "3|4,6,9|1,5,9" "3|4,6,9|1,5,9"
