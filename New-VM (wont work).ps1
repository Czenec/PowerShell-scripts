# This script theoretically works, however the VM i get at the end wont boot probably because of some weird cant copy paste .vhdx files.

$VMName = Read-Host "Name the Virtual Machine"
$VMName_vhdx = $VMName
$VMName_vhdx += ".vhdx"
# ---

# Specify the path to the original virtual hard disk file
$PrefabFolderVHDPath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\Prefabs\"
$PrefabVHDFilename = "WIN-Machine.vhdx"
$PrefabVHDPath = $PrefabFolderVHDPath
$PrefabVHDPath += $PrefabVHDFilename
#$PrefabVHDPath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\Prefabs\WIN-Machine.vhdx"

# Specify the path to the new location and name for the copy
$NewFolderVHDPath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"
$NewVHDFilename = "WIN-Machine.vhdx"
$NewVHDPath = $NewFolderVHDPath
$NewVHDPath += $NewVHDFilename
#$NewVHDPath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\WIN-Machine.vhdx"

# Copy the VHD file to the new location
Copy-Item -Path $PrefabVHDPath -Destination $NewVHDPath

# Rename the copied VHD file
Rename-Item -Path $NewVHDPath -NewName $VMName_vhdx

$CurrentVHDPath = $NewFolderVHDPath
$CurrentVHDPath += $VMName_vhdx
Write-Output $CurrentVHDPath
# ---

# --- Define VM properties ---
# Define RAM
$defaultRAM = 4096
$userInputRAM = Read-Host "Assign Startup memory in MB (Default: $defaultRAM MB)"
If(!$userInputRAM) { $userInputRAM = $defaultRAM }
if ([string]::IsNullOrWhiteSpace($userInputRAM)) {
    $userInputRAM = $defaultRAM
}
$totalRAM = $userInputRAM * 1MB
Write-Output $totalRAM

#Define Virtual Processors
$defaultVirtualProcessors = 8
$userInputVirtualProcessors = Read-Host "Assign Virtual Processors (Default: $defaultVirtualProcessors)"
if ([string]::IsNullOrWhiteSpace($userInputVirtualProcessors)) {
    $userInputVirtualProcessors = $defaultVirtualProcessors
}
Write-Output $userInputVirtualProcessors

# Define Virtual Switch
$defaultSwitchName = "External Hyper-V switch"
Write-Host "Available virtual switches:"
Get-VMSwitch | Select-Object -ExpandProperty Name | Out-Host
$userInputSwitchName = Read-Host "Select a Virtual Switch from the list above (Default: $defaultSwitchName)"
if ([string]::IsNullOrWhiteSpace($userInputSwitchName)) {
    $userInputSwitchName = $defaultSwitchName
}
Write-Output $userInputSwitchName

# --- Set VM properties ---
#$VMName = Read-Host "Please name the Virtual Machine"
$RAM = $totalRAM
$VirtualProcessors = $userInputVirtualProcessors
$VHDPath = $CurrentVHDPath
$SwitchName = $userInputSwitchName

# --- Create new VM ---
New-VM -Name $VMName -MemoryStartupBytes $RAM -Path (Split-Path $VHDPath) -SwitchName $SwitchName -NoVHD
Add-VMHardDiskDrive -VMName $VMName -ControllerType SCSI -Path $VHDPath
Set-VMProcessor -VMName $VMName -Count $VirtualProcessors