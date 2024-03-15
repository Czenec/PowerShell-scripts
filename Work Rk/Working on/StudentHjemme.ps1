#Initialize variables
$accessRule = ''


# Define folder path
$sourcePath = "C:\"
$folderName = "Test-NewUser_PS"
$FolderPath = "$sourcePath\$folderName"

# Define identity
$identity = "alenybe@ringsaker.kommune.no"

$SIDAdministrators = New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')
$Administrators = $SIDAdministrators.Translate([System.Security.Principal.NTAccount])

# Define owner
$folderOwner = $Administrators


# Create new folder
New-Item -Path $sourcePath -Name $folderName -ItemType Directory
# Create new subfolders 
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


$acl = Get-Acl -Path $FolderPath # Get current ACL

$acl.SetAccessRuleProtection($true, $false) # Disable inheritance

# Create FileSystemAccessRule for system and administrators with FullControl
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($accessRule) # Add access rule to ACL
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($accessRule) # Add access rule to ACL

# Create FileSystemAccessRule for the user with Modify access
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($identity, "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($accessRule) # Add access rule to ACL

$accessOwner = New-Object System.Security.Principal.Ntaccount("$folderOwner")
$acl.SetOwner($accessOwner)

<#
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("chrlang@ringsaker.kommune.no", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($accessRule)
#>

# Apply modified ACL to folder
Set-Acl -Path $folderPath -AclObject $acl

(Get-Acl -Path $FolderPath).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

