function New-ArubaConfigFile {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, Position =   1)]
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

    # Split VLANs and interface configurations
    $vlanArray = $vlan -split ','
    $interfaceUntaggedVLANArray = $interfaceUntaggedVLAN -split '\|'
    $interfaceTaggedVLANArray = $interfaceTaggedVLAN -split '\|'

    # Initialize an empty hashtable template for interface configurations
    $interfaceConfigTemplate = @{
        'untaggedVlans' = @()
        'taggedVlans' = @()
        'pvid' = ''
    }

    # Initialize an empty hashtable to store the configuration for each interface
    $configurations = @{}

    # Loop through each untagged VLAN configuration
    for ($i = 0; $i -lt $interfaceUntaggedVLANArray.Length; $i++) {
        $interfacesUntagged = $interfaceUntaggedVLANArray[$i] -split ','
        foreach ($interface in $interfacesUntagged) {
            $vlanForInterface = $vlanArray[$i]
            if (-not $configurations.ContainsKey($interface)) {
                $configurations[$interface] = $interfaceConfigTemplate.Clone()
            }
            $configurations[$interface]['untaggedVlans'] += $vlanForInterface
            $configurations[$interface]['pvid'] = $vlanForInterface
        }
    }

    # Loop through each tagged VLAN configuration
    for ($i = 0; $i -lt $interfaceTaggedVLANArray.Length; $i++) {
        $interfacesTagged = $interfaceTaggedVLANArray[$i] -split ','
        foreach ($interface in $interfacesTagged) {
            $vlanForInterface = $vlanArray[$i]
            if (-not $configurations.ContainsKey($interface)) {
                $configurations[$interface] = $interfaceConfigTemplate.Clone()
            }
            $configurations[$interface]['taggedVlans'] += $vlanForInterface
            if ($configurations[$interface]['pvid'] -eq '1') {
                $configurations[$interface]['pvid'] = $vlanForInterface
            }
        }
    }

    # If pvid is not set, use the last tagged VLAN
    foreach ($interfaceConfig in $configurations.Values) {
        if ($interfaceConfig['pvid'] -eq '1' -and $interfaceConfig['taggedVlans'].Count -gt 0) {
            $interfaceConfig['pvid'] = $interfaceConfig['taggedVlans'][-1]
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
            foreach ($index in 0..($configurations[$interface]['untaggedVlans'].Count - 1)) {
                $vlan = $configurations[$interface]['untaggedVlans'][$index]
                $finalConfig += "$vlan"
                if ($index -lt ($configurations[$interface]['untaggedVlans'].Count - 1)) {
                    $finalConfig += ","
                }
            }            
            $finalConfig += " untagged`n"

            $finalConfig += " switchport general allowed vlan add "
            foreach ($index in 0..($configurations[$interface]['taggedVlans'].Count - 1)) {
                $vlan = $configurations[$interface]['taggedVlans'][$index]
                $finalConfig += "$vlan"
                if ($index -lt ($configurations[$interface]['taggedVlans'].Count - 1)) {
                    $finalConfig += ","
                }
            }            
            $finalConfig += " tagged`n"
            $finalConfig += " switchport general pvid $($configurations[$interface]['pvid'])`n!`n"
        }
        elseif ($i -le 8) {
            $finalConfig += "interface $i`n"
            $finalConfig += " loopback-detection enable`n"
            $finalConfig += " switchport general allowed vlan add $defaultVlan untagged`n!`n"
        }
        elseif ($i -ge 9) {
            $finalConfig += "interface $i`n"
            $finalConfig += " loopback-detection enable`n!`n"
        }
    }

    Write-Host $finalConfig
}

# Example usage
New-ArubaConfigFile "3,50,249" "3|4,6,9|1,5,9" "3|4,6,9|1,5,9"
