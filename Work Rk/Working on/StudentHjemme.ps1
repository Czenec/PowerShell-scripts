<#
Here's some instructions to myself:
To get Get-ADUser to work over Invoke-Command you need to create a PowerShell session first with propper credentials.
You can do this with Register-PSSessionConfiguration and UnRegister-PSSessionConfiguration, and Invoke-Command -Session.
This way you first create a session with propper credentials, then you enter that session and run your commands, and lastly you close the session to not leave evidence.
You need to do this becuse Get-ADUser is a command that itself gets info from a server 3, and when you Invoke-Command from server 1 to server 2, server 2 cant carry
credentials from server 1 to server 3 for security reasons.

give SID folder permissions, good luck: https://superuser.com/questions/1019558/how-to-add-a-sid-to-a-folder-permissions
#>





#$Credentials = Get-Credential ringsaker\adm_chri
<#
$identity = $(Write-Host "What is the username of the owner to this Home directory?`n`n" -ForegroundColor Cyan -NoNewline; Read-Host)
if ([string]::IsNullOrWhiteSpace($identity)) {
    Throw "An input is needed."
}
if ($null -eq (Get-ADuser $identity)) {
    Throw "Could not find $identity"
}
#><#
if ($false -eq (Invoke-Command -ComputerName "rkdrift" -Credential $Credentials {
    Get-ADuser "$identity"
})) {
    Throw "Could not find $identity"
}#>

# Define identity
$identity = "alenybe"
$identitySID = (Get-ADUser -Identity $identity).sid.Value
#$identity += "@ringsaker.kommune.no"


#Initialize variables
$accessRule = ''


# Define folder path
$sourcePath = "C:\"#"E:\DATA01\RE120-Organisasjonsseksjonen\IKT-virksomheten\Systembrukere\Christoffer_Langseth-ADM_CHRI\testAccess"
$folderName = "Test-NewUser_PS"
$FolderPath = "$sourcePath\$folderName"

Invoke-Command -ComputerName "10.10.10.180" -Credential 10.10.10.180\Administrator -ScriptBlock {



    $SIDAdministrators = New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')
    $Administrators = $SIDAdministrators.Translate([System.Security.Principal.NTAccount])

    # Define owner
    $folderOwner = $Administrators


    # Create new folder
    New-Item -Path $Using:sourcePath -Name $Using:folderName -ItemType Directory
    # Create new subfolders 
    New-Item -Path "$Using:folderPath" -Name "Excel" -ItemType "directory"
    New-Item -Path "$Using:folderPath" -Name "Fagserver" -ItemType "directory"
    New-Item -Path "$Using:folderPath" -Name "MALER" -ItemType "directory"
    New-Item -Path "$Using:folderPath" -Name "Mine datakilder" -ItemType "directory"
    New-Item -Path "$Using:folderPath" -Name "Ny bruker" -ItemType "directory"
    New-Item -Path "$Using:folderPath" -Name "Powerpnt" -ItemType "directory"
    New-Item -Path "$Using:folderPath" -Name "Privat" -ItemType "directory"
    New-Item -Path "$Using:folderPath" -Name "Temp" -ItemType "directory"
    New-Item -Path "$Using:folderPath" -Name "Tmp" -ItemType "directory"
    New-Item -Path "$Using:folderPath" -Name "varebest" -ItemType "directory"
    New-Item -Path "$Using:folderPath" -Name "Word" -ItemType "directory"


    $acl = Get-Acl -Path $Using:FolderPath # Get current ACL

    $acl.SetAccessRuleProtection($true, $false) # Disable inheritance
    
    # Create FileSystemAccessRule for system and administrators with FullControl
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($accessRule) # Add access rule to ACL
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($accessRule) # Add access rule to ACL
    
    $accessOwner = New-Object System.Security.Principal.Ntaccount("$folderOwner")
    $acl.SetOwner($accessOwner)
    
    
    # Apply modified ACL to folder
    Set-Acl -Path $Using:folderPath -AclObject $acl
    
    icacls $Using:FolderPath /grant *$Using:identitySID":(M)"
    
    (Get-Acl -Path $Using:FolderPath).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

}