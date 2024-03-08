    # Define folder path and user identity
$folderName = "Test-NewUser_PS"
$sourcePath = "C:\"
$FolderPath = "$sourcePath\$folderName"
$identity = "alenybe@ringsaker.kommune.no"
    # Create new folder
New-Item -Path $sourcePath -Name $folderName -ItemType Directory

    # Get current ACL
$acl = Get-Acl -Path $FolderPath
    # Disable inheritance
$acl.SetAccessRuleProtection($true, $false)
    # Create FileSystemAccessRule for the user with Modify access
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($identity, "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    # Add access rule to ACL
$acl.AddAccessRule($accessRule)

    # Apply modified ACL to folder
Set-Acl -Path $folderPath -AclObject $acl -WhatIf



New-Item -Path "$folderPath" -Name "Excel" -ItemType "directory"
New-Item -Path "$folderPath" -Name "Fagserver" -ItemType "directory"
New-Item -Path "$folderPath" -Name "MALER" -ItemType "directory"
New-Item -Path "$folderPath" -Name "Mine datakilder" -ItemType "directory"
New-Item -Path "$folderPath" -Name "Ny bruker" -ItemType "directory"
New-Item -Path "$folderPath" -Name "Powerpnt" -ItemType "directory"
New-Item -Path "$folderPath" -Name "Privat" -ItemType "directory"
New-Item -Path "$folderPath" -Name "Temp" -ItemType "directory"
New-Item -Path "$folderPath" -Name "Tmp" -ItemType "directory"
New-Item -Path "$folderPath" -Name "varebest" -ItemType "directory"
New-Item -Path "$folderPath" -Name "Word" -ItemType "directory"
