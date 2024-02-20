function New-ArubaConfigFile {
    <#
        .SYNOPSIS
        Creates an Aruba Config file and saves it.
        .DESCRIPTION
        Creates an Aruba Config file for the Instant On switch you chose.
        .EXAMPLE
                New-ArubaConfigFile -switch 1930 -IP 10.0.0.2 -subnett 255.255.0.0
                this is a placeholder
        .EXAMPLE
                this is a placeholder
                this is a placeholder
    #>
    
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.String]
        $switch,
        
        [Parameter(Mandatory = $true, Position = 1)]
        [System.String]
        $IP,

        [Parameter(Mandatory = $true, Position = 2)]
        [System.String]
        $subnet,

        [Parameter(Mandatory = $true, Position = 3)]
        [System.String]
        $hostName,
    
        [Parameter(Mandatory = $false, Position = 4)]
        [System.String]
        $gateway,


        <##>

        [Parameter(Mandatory = $false, Position = 5)]
        [System.Object]
        $vlan =  '1',

        [Alias("MVlan","MV")]
        [Parameter(Mandatory = $false, Position = 6)]
        [System.String]
        $managementVLAN = '1',

        [Alias("MVlanName","MVN")]
        [Parameter(Mandatory = $false, Position = 7)]
        [System.String]
        $managementVLANName = $managementVLAN,

        [Alias("Untagged","IUV")]
        [Parameter(Mandatory = $false, Position = 8)]
        [System.String]
        $interfaceUntaggedVLAN,

        [Alias("Tagged","ITV")]
        [Parameter(Mandatory = $false, Position = 9)]
        [System.String]
        $interfaceTaggedVLAN,

        <##>
        
        [Parameter(Mandatory = $false, Position = 20)]
        [System.String]
        $outPath = "$env:USERPROFILE\Downloads\ArubaConfig"
    )

    # Hashtable to map switch codes to descriptions
    $switchTable = @{
        'JL810A' = 'Aruba Instant On 1830 8G Switch JL810A'                             # 4 TRK ports       Group 1
        'JL811A' = 'Aruba Instant On 1830 8G 4p Class4 PoE 65W Switch JL811A'           # 4 TRK ports       Group 1
        'JL812A' = 'Aruba Instant On 1830 24G 2SFP Switch JL812A'                       # 8 TRK ports       Group 2
        'JL813A' = 'Aruba Instant On 1830 24G 12p Class4 PoE 2SFP 195W Switch JL813A'   # 8 TRK ports(?)    Group 2
        'JL814A' = 'Aruba Instant On 1830 48G 4SFP Switch JL814A'                       # 16 TRK ports      Group 5
        'JL815A' = 'Aruba Instant On 1830 48G 24p Class4 PoE 4SFP 370W Switch JL815A'   # 16 TRK ports      Group 5

        'JL680A' = 'Aruba Instant On 1930 8G 2SFP Switch JL680A'                        # 4 TRK ports       Group 3
        'JL681A' = 'Aruba Instant On 1930 8G Class4 PoE 2SFP 124W Switch JL681A'        # 4 TRK ports       Group 3
        'JL682A' = 'Aruba Instant On 1930 24G 4SFP/SFP+ Switch JL682A'                  # 8 TRK ports       Group 4
        'JL683A' = 'Aruba Instant On 1930 24G Class4 PoE 4SFP/SFP+ 195W Switch JL683A'  # 8 TRK ports       Group 4
        'JL683B' = 'Aruba Instant On 1930 24G Class4 PoE 4SFP/SFP+ 195W Switch JL683B'  # 8 TRK ports       Group 4
        'JL684A' = 'Aruba Instant On 1930 24G Class4 PoE 4SFP/SFP+ 370W Switch JL684A'  # 8 TRK ports       Group 4
        'JL684B' = 'Aruba Instant On 1930 24G Class4 PoE 4SFP/SFP+ 370W Switch JL684B'  # 8 TRK ports       Group 4
        'JL685A' = 'Aruba Instant On 1930 48G 4SFP/SFP+ Switch JL685A'                  # 16 TRK ports      Group 5
        'JL686A' = 'Aruba Instant On 1930 48G Class4 PoE 4SFP/SFP+ 370W Switch JL686A'  # 16 TRK ports      Group 5
        'JL686B' = 'Aruba Instant On 1930 48G Class4 PoE 4SFP/SFP+ 370W Switch JL686B'  # 16 TRK ports      Group 5
<#
        'JL805A' = 'Aruba Instant On 1960 12XGT 4SFP+ Switch JL805A'
        'JL806A' = 'Aruba Instant On 1960 24G 2XGT 2SFP+ Switch JL806A'
        'JL807A' = 'Aruba Instant On 1960 24G 20p Class4 4p Class6 PoE 2XGT 2SFP+ 370W Switch JL807A'
        'JL808A' = 'Aruba Instant On 1960 48G 2XGT 2SFP+ Switch JL808A'
        'JL809A' = 'Aruba Instant On 1960 48G 40p Class4 8p Class6 PoE 2XGT 2SFP+ 600W Switch JL809A'
        'S0F35A' = 'Aruba Instant On 1960 8p 1G Class 4 4p SR1G/2.5G Class 6 PoE 2p 10GBASE-T 2p SFP+ 480W Switch S0F35A'
#>
    } # Add more switch codes and descriptions as needed

    # Retrieve the description based on the provided switch code
    $switchDescription = $switchTable[$switch]

    # Error for if the switch code is invalid
    if ($null -eq $switchDescription) {
        Write-Host "Unknown switch code: $switch"
        return
    }


    # Tells the script how many interfaces should be printed
        # 8 Interface
        # 0 Fiber
        # 4 TRK
    if ($switch -in 'JL810A', 'JL811A') { # Group 1
        $interfaceAmount = 8
        $fiberAmount = 0
        $TRKAmount = 4
    }
        # 24 Interface
        # 2 Fiber
        # 8 TRK
    if ($switch -in 'JL812A', 'JL813A') { # Group 2
        $interfaceAmount = 24
        $fiberAmount = 2
        $TRKAmount = 8
    }

        # 8 Interface
        # 2 Fiber
        # 4 TRK
    if ($switch -in 'JL680A', 'JL681A') { # Group 3
        $interfaceAmount = 8
        $fiberAmount = 2
        $TRKAmount = 4
    }
        # 24 Interface
        # 4 Fiber
        # 8 TRK
    if ($switch -in 'JL682A', 'JL683A', 'JL683B', 'JL684A', 'JL684B') { # Group 4
        $interfaceAmount = 24
        $fiberAmount = 4
        $TRKAmount = 8
    }

        # 48 Interface
        # 4 Fiber
        # 16 TRK
    if ($switch -in 'JL814A', 'JL815A', 'JL685A', 'JL686A', 'JL686B') { # Group 5
        $interfaceAmount = 48
        $fiberAmount = 4
        $TRKAmount = 16
    }



<#
    Write-Host "
    switch:                 $switch
    switch Description:     $switchDescription
    Interface Amount:       $interfaceAmount
    IP address:             $IP
    subnet:                 $subnet
    gateway:                $gateway
    hostname:               $hostname


    VLAN:                   $vlan
    Management VLAN:        $managementVLAN
    Untagged VLAN ports:    $interfaceUntaggedVLAN
    Tagged VLAN ports:      $interfaceTaggedVLAN
    "#>


    $interfaceVLAN =
"interface vlan $managementVLAN
 name $managementVLANName
 ip address $IP $subnet
 no ip address dhcp
!"

    # Output other VLAN dynamically using a loop
    foreach ($v in $vlan) {
        # Skip management VLAN if it was already handled
        if ($v -eq $managementVLAN) { 
<#            $interfaceVLAN +=
"interface vlan $managementVLAN
 name $managementVLAN
 ip address $IP $subnet
 no ip address dhcp
!"#>
        continue
        } else {
        $interfaceVLAN +=
"
interface vlan $v
 name $v
!"
        }
    }


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
    $interfacesConfig = ""
    $keys = $configurations.Keys | Sort-Object {[int]$_}

    for ($i = 1; $i -le ($interfaceAmount + $fiberAmount); $i++) {
        if ($keys -contains "$i") {
            $interface = $keys | Where-Object {$_ -eq "$i"}
            $interfacesConfig += "interface $interface`n"
            $interfacesConfig += " loopback-detection enable`n"

            $interfacesConfig += " switchport general allowed vlan add "
            foreach ($index in 0..($configurations[$interface]['untaggedVlans'].Count - 1)) {
                $vlan = $configurations[$interface]['untaggedVlans'][$index]
                $interfacesConfig += "$vlan"
                if ($index -lt ($configurations[$interface]['untaggedVlans'].Count - 1)) {
                    $interfacesConfig += ","
                }
            }            
            $interfacesConfig += " untagged`n"

            $interfacesConfig += " switchport general allowed vlan add "
            foreach ($index in 0..($configurations[$interface]['taggedVlans'].Count - 1)) {
                $vlan = $configurations[$interface]['taggedVlans'][$index]
                $interfacesConfig += "$vlan"
                if ($index -lt ($configurations[$interface]['taggedVlans'].Count - 1)) {
                    $interfacesConfig += ","
                }
            }            
            $interfacesConfig += " tagged`n"
            $interfacesConfig += " switchport general pvid $($configurations[$interface]['pvid'])`n!`n"
        }
        elseif ($i -le ($interfaceAmount + $fiberAmount)) {
            $interfacesConfig += "interface $i`n"
            $interfacesConfig += " loopback-detection enable`n!`n"
        }
        elseif ($i -le $interfaceAmount) {
            $interfacesConfig += "interface $i`n"
            $interfacesConfig += " loopback-detection enable`n"
            $interfacesConfig += " switchport general allowed vlan add $defaultVlan untagged`n!`n"
        }
    }
    
    for ($i = 1; $i -le $TRKAmount; $i++) {
        $interfacesConfig += "interface TRK$i`n"
        $interfacesConfig += " loopback-detection enable`n!"
        if ($i -lt $TRKAmount) {
            $interfacesConfig += "`n"
        }
    }


    if (0 -cne $gateway) {
        $gatewayConfig = "ip default-gateway $gateway `n"
    }


    $outputConfig = 
"config-file-header
$hostname
vInstantOn_1930_2.9.0.0 (53) / RHPE2.9_932_296_002
SKU Description `"$switchDescription`"
@
!
unit-type-control-start 
unit-type unit 1 network gi uplink none 
unit-type-control-end 
!
vlan database
vlan $($vlan -join ',')
exit
loopback-detection enable 
hostname $hostname
username admin password encrypted 016e56fb9559698dd1e910878839b91085b6126a privilege 15 
management vlan $managementVLAN 
!
$interfaceVLAN
$interfacesConfig
exit
$gatewayConfig"


    $outputConfig | Write-Host
    $outputConfig | Out-File -FilePath $outPath

}

#<#
$default = "default value" # a normal number is writen without parentheses
$switchQuestion = $(Write-Host "`nWhat switch do you want a config for?  " -ForegroundColor Blue -NoNewline; Read-Host)
if ([string]::IsNullOrWhiteSpace($switchQuestion)) {
    $switchQuestion = $default
}
Write-Host "
--------------------------------------------------------------------------------------
"
$default = "192.168.0.1" # a normal number is writen without parentheses
$iPQuestion = $(Write-Host "`nWhat should it's IP be?`nExample: 10.10.10.1  " -ForegroundColor Blue -NoNewline; Read-Host)
if ([string]::IsNullOrWhiteSpace($iPQuestion)) {
    $iPQuestion = $default
}
Write-Host "
--------------------------------------------------------------------------------------
"
$default = "255.255.0.0" # a normal number is writen without parentheses
$subnetQuestion = $(Write-Host "`nWhat should it's subnet mask?  " -ForegroundColor Blue -NoNewline; Read-Host)
if ([string]::IsNullOrWhiteSpace($subnetQuestion)) {
    $subnetQuestion = $default
}
Write-Host "
--------------------------------------------------------------------------------------
"
$default = "default value" # a normal number is writen without parentheses
$nameQuestion = $(Write-Host "`nWhat should it's name be?  " -ForegroundColor Blue -NoNewline; Read-Host)
if ([string]::IsNullOrWhiteSpace($nameQuestion)) {
    $nameQuestion = $default
}
Write-Host "
--------------------------------------------------------------------------------------
"
$default = "default value" # a normal number is writen without parentheses
$gatewayQuestion = $(Write-Host "`nWhat should it's gateway be?  " -ForegroundColor Blue -NoNewline; Read-Host)
if ([string]::IsNullOrWhiteSpace($gatewayQuestion)) {
    $gatewayQuestion = $default
}
Write-Host "
--------------------------------------------------------------------------------------
"

$default = 1 # a normal number is writen without parentheses
$vlanQuestion = $(Write-Host "`nWhat VLAN should be configured on it?`nExample: 3,50,249  " -ForegroundColor Blue -NoNewline; Read-Host)
if ([string]::IsNullOrWhiteSpace($vlanQuestion)) {
    $vlanQuestion = $default
}
Write-Host "
--------------------------------------------------------------------------------------
"
$default = 1 # a normal number is writen without parentheses
$managementVLANQuestion = $(Write-Host "`nWhat VLAN should act as management VLAN?  " -ForegroundColor Blue -NoNewline; Read-Host)
if ([string]::IsNullOrWhiteSpace($managementVLANQuestion)) {
    $managementVLANQuestion = $default
}
Write-Host "
--------------------------------------------------------------------------------------
"
$default = "" # a normal number is writen without parentheses
$untaggedQuestion = $(Write-Host "`nWhat interfaces shuold be untagged with VLAN?`nExample: 3|4,6,9|1,5,9  " -ForegroundColor Blue -NoNewline; Read-Host)
if ([string]::IsNullOrWhiteSpace($untaggedQuestion)) {
    $untaggedQuestion = $default
}
Write-Host "
--------------------------------------------------------------------------------------
"
$default = "" # a normal number is writen without parentheses
$taggedQuestion = $(Write-Host "`nWhat interfaces shuold be tagged with VLAN?`nExample: 3|4,6,9|1,5,9  " -ForegroundColor Blue -NoNewline; Read-Host)
if ([string]::IsNullOrWhiteSpace($taggedQuestion)) {
    $taggedQuestion = $default
}
Write-Host "
--------------------------------------------------------------------------------------
"

$default = "$env:USERPROFILE\Downloads\ArubaConfig" # a normal number is writen without parentheses
$outpathQuestion = $(Write-Host "`nWhere should the output file be saved?`nDefault: C:\users\USERNAME\downloads\ArubaConfig  " -ForegroundColor Blue -NoNewline; Read-Host)
if ([string]::IsNullOrWhiteSpace($outpathQuestion)) {
    $outpathQuestion = $default
}


<#
$switchQuestion = $(Write-Host "`nWhat switch do you want a config for?  " -ForegroundColor Blue -NoNewline; Read-Host)
$IPQuestion = $(Write-Host "`nWhat should it's IP be?`nExample: 10.10.10.1  " -ForegroundColor Blue -NoNewline; Read-Host)
$subnetQuestion = $(Write-Host "`nWhat should it's subnet mask?  " -ForegroundColor Blue -NoNewline; Read-Host)
$nameQuestion = $(Write-Host "`nWhat should it's name be?  " -ForegroundColor Blue -NoNewline; Read-Host)
$gatewayQuestion = $(Write-Host "`nWhat should it's gateway be?  " -ForegroundColor Blue -NoNewline; Read-Host)

$vlanQuestion = $(Write-Host "`nWhat VLAN should be configured on it?`nExample: 3,50,249  " -ForegroundColor Blue -NoNewline; Read-Host)
$managementVLANQuestion = $(Write-Host "`nWhat VLAN should act as management VLAN?  " -ForegroundColor Blue -NoNewline; Read-Host)
$untaggedQuestion = $(Write-Host "`nWhat interfaces shuold be untagged with VLAN?`nExample: 3|4,6,9|1,5,9  " -ForegroundColor Blue -NoNewline; Read-Host)
$taggedQuestion = $(Write-Host "`nWhat interfaces shuold be tagged with VLAN?`nExample: 3|4,6,9|1,5,9  " -ForegroundColor Blue -NoNewline; Read-Host)

$outpathQuestion = $(Write-Host "`nWhere should the output file be saved?`nDefault: C:\users\USERNAME\downloads\ArubaConfig  " -ForegroundColor Blue -NoNewline; Read-Host)
#>


Write-Host "
$switchQuestion
$IPQuestion
$subnetQuestion
$nameQuestion
$gatewayQuestion

$vlanQuestion
$managementVLANQuestion
$untaggedQuestion
$taggedQuestion

$outpathQuestion
"


New-ArubaConfigFile -switch $switchQuestion -IP $IPQuestion -subnet $subnetQuestion -hostName $nameQuestion -gateway $gatewayQuestion -vlan $vlanQuestion -managementVLAN $managementVLANQuestion -Untagged $untaggedQuestion -Tagged $taggedQuestion -outPath $outpathQuestion

#New-ArubaConfigFile -switch JL682A -IP 10.10.10.1 -subnet 255.255.0.0 -hostName REEEEEEEEEEEEEEE -vlan 3, 50,249 -Tagged "3|4,6,9|1,5,9" -Untagged "3|4,6,9|1,5,9" -gateway 684.4864.846.684 -managementVLAN 50