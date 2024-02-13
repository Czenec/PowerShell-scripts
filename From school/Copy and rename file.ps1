# This script takes a .vhdx file from a Prefabs folder, then copies and renames it to a diffrent folder.

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