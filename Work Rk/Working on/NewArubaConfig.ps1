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
    
        [Parameter(Mandatory = $false, Position = 3)]
        [System.String]
        $gateway,

        [Parameter(Mandatory = $true, Position = 4)]
        [System.String]
        $hostName,

        <##>

        [Parameter(Mandatory = $false, Position = 5)]
        [System.Object]
        $vlan =  '1',

        [Parameter(Mandatory = $false, Position = 6)]
        [System.String]
        $managementVLAN = '1',

        <##>
        
        [Parameter(Mandatory = $false, Position = 20)]
        [System.String]
        $outPath
    )

    # Hashtable to map switch codes to descriptions
    $switchTable = @{
        'JL810A' = 'Aruba Instant On 1830 8G Switch JL810A'
        'JL811A' = 'Aruba Instant On 1830 8G 4p Class4 PoE 65W Switch JL811A'
        'JL812A' = 'Aruba Instant On 1830 24G 2SFP Switch JL812A'
        'JL813A' = 'Aruba Instant On 1830 24G 12p Class4 PoE 2SFP 195W Switch JL813A'
        'JL814A' = 'Aruba Instant On 1830 48G 4SFP Switch JL814A'
        'JL815A' = 'Aruba Instant On 1830 48G 24p Class4 PoE 4SFP 370W Switch JL815A'

        'JL680A' = 'Aruba Instant On 1930 8G 2SFP Switch JL680A'
        'JL681A' = 'Aruba Instant On 1930 8G Class4 PoE 2SFP 124W Switch JL681A'
        'JL682A' = 'Aruba Instant On 1930 24G 4SFP/SFP+ Switch JL682A'
        'JL683A' = 'Aruba Instant On 1930 24G Class4 PoE 4SFP/SFP+ 195W Switch JL683A'
        'JL683B' = 'Aruba Instant On 1930 24G Class4 PoE 4SFP/SFP+ 195W Switch JL683B'
        'JL684A' = 'Aruba Instant On 1930 24G Class4 PoE 4SFP/SFP+ 370W Switch JL684A'
        'JL684B' = 'Aruba Instant On 1930 24G Class4 PoE 4SFP/SFP+ 370W Switch JL684B'
        'JL685A' = 'Aruba Instant On 1930 48G 4SFP/SFP+ Switch JL685A'
        'JL686A' = 'Aruba Instant On 1930 48G Class4 PoE 4SFP/SFP+ 370W Switch JL686A'
        'JL686B' = 'Aruba Instant On 1930 48G Class4 PoE 4SFP/SFP+ 370W Switch JL686B'

        'JL805A' = 'Aruba Instant On 1960 12XGT 4SFP+ Switch JL805A'
        'JL806A' = 'Aruba Instant On 1960 24G 2XGT 2SFP+ Switch JL806A'
        'JL807A' = 'Aruba Instant On 1960 24G 20p Class4 4p Class6 PoE 2XGT 2SFP+ 370W Switch JL807A'
        'JL808A' = 'Aruba Instant On 1960 48G 2XGT 2SFP+ Switch JL808A'
        'JL809A' = 'Aruba Instant On 1960 48G 40p Class4 8p Class6 PoE 2XGT 2SFP+ 600W Switch JL809A'
        'S0F35A' = 'Aruba Instant On 1960 8p 1G Class 4 4p SR1G/2.5G Class 6 PoE 2p 10GBASE-T 2p SFP+ 480W Switch S0F35A'
        # Add more switch codes and descriptions as needed
    }

    # Retrieve the description based on the provided switch code
    $switchDescription = $switchTable[$switch]

    # Error for if the switch code is invalid
    if ($null -eq $switchDescription) {
        Write-Host "Unknown switch code: $switch"
        return
    }


    foreach ($v in $vlan) {
        $UntagedVLAN += Read-Host "What interfaces shuld be untaged on vlan $v"
    }



    Write-Host "
    $switch
    $switchDescription
    $IP
    $subnet
    $gateway
    $hostname

    $vlan
    $managementVLAN

    $UntagedVLAN
    $TagedVLAN
    "





    # Output other VLAN dynamically using a loop
    foreach ($v in $vlan) {
        # Skip management VLAN if it was already handled
        if ($v -eq $managementVLAN) { 
            $interfaceVLAN =
"interface vlan $managementVLAN
 name $managementVLAN
 ip address $IP $subnet
 no ip address dhcp
!"
        continue
        } else {
        $interfaceVLAN +=
"
interface vlan $v
 name $v
!"
        }}


    # Interface 1 to 10 is for 8 port switches, port 9 and 10 are virtual and used by some additional funktions.
    $interface1_10 =
"interface 1
 loopback-detection enable 
 switchport general allowed vlan add 269 untagged 
 switchport general pvid 269 
!
interface 2
 loopback-detection enable 
 switchport general allowed vlan add 269 untagged 
 switchport general pvid 269 
!
interface 3
 loopback-detection enable 
 switchport general allowed vlan add 269 untagged 
 switchport general pvid 269 
!
interface 4
 loopback-detection enable 
 switchport general allowed vlan add 269 untagged 
 switchport general pvid 269 
!
interface 5
 loopback-detection enable 
 switchport general allowed vlan add 269 untagged 
 switchport general pvid 269 
!
interface 6
 loopback-detection enable 
 switchport general allowed vlan add 269 untagged 
 switchport general pvid 269 
!
interface 7
 loopback-detection enable 
 switchport general allowed vlan add 269 untagged 
 switchport general pvid 269 
!
interface 8
 loopback-detection enable 
 switchport general allowed vlan add 269 tagged 
!
interface 9
 loopback-detection enable 
!
interface 10
 loopback-detection enable 
!"

    $interfaceTRK1_TRK4 =
"interface TRK1
 loopback-detection enable 
!
interface TRK2
 loopback-detection enable 
!
interface TRK3
 loopback-detection enable 
!
interface TRK4
 loopback-detection enable 
!"

    #Write-Host $interfaceManagementVLAN
    #Write-Host $interfaceVLAN
    #Write-Host $interface1_10
    #Write-Host $interfaceTRK1_TRK4

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
vlan $($vlan -join ',' -replace ',$','')
exit
loopback-detection enable 
hostname $hostname
username admin password encrypted 016e56fb9559698dd1e910878839b91085b6126a privilege 15 
management vlan $managementVLAN 
!
$interfaceVLAN
$interface1_10
$interfaceTRK1_TRK4
exit

"


    #$outputConfig | Out-File -FilePath C:\Users\chrlang\Downloads -Force
    $outputConfig | Write-Host

  }

New-ArubaConfigFile -switch JL810A -IP 10.10.10.1 -subnet 255.255.0.0 -hostName REEEEEEEEEEEEEEE -vlan 1, 2,3,44