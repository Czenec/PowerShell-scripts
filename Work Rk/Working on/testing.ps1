#$Credentials = Get-Credential

$identity = "alenybe"
$identitySID = (Get-ADUser -Identity $identity).sid.Value


$SIDAdministrators = New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')
$Administrators = $SIDAdministrators.Translate([System.Security.Principal.NTAccount])

# Define owner
$folderOwner = $Administrators


# Define folder path
$sourcePath = "C:\" #"E:\DATA01\RE120-Organisasjonsseksjonen\IKT-virksomheten\Systembrukere\Christoffer_Langseth-ADM_CHRI\testAccess"
$folderName = "Test-NewUser_PS"
$FolderPath = "$sourcePath\$folderName"


New-Item -Path $sourcePath -Name $folderName -ItemType Directory


$acl = Get-Acl -Path $FolderPath # Get current ACL

$acl.SetAccessRuleProtection($true, $false) # Disable inheritance

# Create FileSystemAccessRule for system and administrators with FullControl
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($accessRule) # Add access rule to ACL
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($accessRule) # Add access rule to ACL

$accessOwner = New-Object System.Security.Principal.Ntaccount("$folderOwner")
$acl.SetOwner($accessOwner)


# Apply modified ACL to folder
Set-Acl -Path $folderPath -AclObject $acl

icacls $FolderPath /grant *$identitySID":(M)"

(Get-Acl -Path $FolderPath).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize