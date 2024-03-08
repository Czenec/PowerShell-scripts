    # Define folder path and user identity
$name = "Test-NewUser_PS"
$folderPath = "C:\"
$identity = "alenybe@ringsaker.kommune.no"
    # Create new folder
New-Item -Path $folderPath -Name $name -ItemType Directory

    # Get current ACL
$acl = Get-Acl -Path $folderPath
    # Disable inheritance
$acl.SetAccessRuleProtection($true, $false)
    # Create FileSystemAccessRule for the user with Modify access
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($identity, "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    # Add access rule to ACL
$acl.AddAccessRule($accessRule)

# Apply modified ACL to folder
Set-Acl -Path $folderPath -AclObject $acl
