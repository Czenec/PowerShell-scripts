function Get-UIdate {

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object Windows.Forms.Form -Property @{
        StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
        Size          = New-Object Drawing.Size 243, 230
        Text          = 'Select a Date'
        Topmost       = $true
    }

    $calendar = New-Object Windows.Forms.MonthCalendar -Property @{
        ShowTodayCircle   = $false
        MaxSelectionCount = 1
    }
    $form.Controls.Add($calendar)

    $okButton = New-Object Windows.Forms.Button -Property @{
        Location     = New-Object Drawing.Point 38, 165
        Size         = New-Object Drawing.Size 75, 23
        Text         = 'OK'
        DialogResult = [Windows.Forms.DialogResult]::OK
    }
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object Windows.Forms.Button -Property @{
        Location     = New-Object Drawing.Point 113, 165
        Size         = New-Object Drawing.Size 75, 23
        Text         = 'Cancel'
        DialogResult = [Windows.Forms.DialogResult]::Cancel
    }
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $result = $form.ShowDialog()

    if ($result -eq [Windows.Forms.DialogResult]::OK) {
        $date = $calendar.SelectionStart
        #Write-Host "Date selected: $($date.ToShortDateString())"
        return $($date.ToShortDateString())
    }

}




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






$userPath = "OU=Studenter,OU=Manuelt opprettet,OU=ringsaker.kommune,DC=ringsaker,DC=kommune,DC=no"

$GivenName = <#Read-Host "`nFornavn`n"#> "testuserChr"
$Surname = <#Read-Host "`nEtternavn`n"#> "testuserLan"
$Name = "$GivenName $Surname"
$username = <#Read-Host "`nBrukernavn`n"#> "testuserchrlan"

$mobilePhone = Read-Host "`nTelefonnummer`n"
$description = Read-Host "`nBruker beskrivelse`neks: RE424-Psykisk helse og rustjenester - Sykepleierstudent`n"
$department = Read-Host "`nOffice felt`neks: RE424-Psykisk helse og rustjenester`n"

$PasswordLength = "8"
$RandomPassword = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count $PasswordLength | ForEach-Object {[char]$_})

$accountExpiration = Get-UIdate


$splat = @{
    Name = $name
    DisplayName = $name
    GivenName = $GivenName
    Surname = $Surname
    SamAccountName = $username

    MobilePhone = $mobilePhone
    Description = $description
    Office = $department
    Department = $department

    Path = $userPath
    AccountExpirationDate = $accountExpiration
    AccountPassword = (Read-Host -AsSecureString $RandomPassword)
    ChangePasswordAtLogon = $false
    Enabled = $true
}

$reEnhet = Read-Host "`nHvilken RE enhet?`neks: re424`n"
$user = New-ADUser @splat -Confirm

<#$userParams = @{
    Identity = "CN=$name,OU=Studenter,OU=Manuelt opprettet,OU=ringsaker.kommune,DC=ringsaker,DC=kommune,DC=no"
}
$user = Get-ADUser @userParams #>


# Check if the input matches the expected format (starts with "re" followed by digits)
if ($reEnhet -notmatch '^re\d+$') {
    # If not, prepend "re" to the input
    $reEnhet = "re$reEnhet"
}
# Set paramaters for Get-ADGroup
$distGroupParams = @{
    SearchBase = 'OU=Distribusjonsgrupper,OU=eAdm,OU=ringsaker.kommune,DC=ringsaker,DC=kommune,DC=no'
    SearchScope = 1
    Filter = "name -like '$($reEnhet)*'"
}
# Attempt to retrieve the group
try {
    $distGroup = Get-ADGroup @distGroupParams -ErrorAction Stop

    # Check the number of groups found
    if ($distGroup.Count -eq 0) {
        throw "No groups were found matching the criteria: $reEnhet"
    }
    elseif ($distGroup.Count -gt 1) {
        # List all groups found for problem-solving purposes
        Write-Host "Groups found:" -ForegroundColor Blue
        Write-Host $($distGroup.Name -join "`r`n")
        throw "More than one group was found matching the criteria: $reEnhet"
    }
    # If exactly one group is found, continue with the script
    Write-Host "Group found:" -ForegroundColor Blue
    Write-Host $($distGroup.Name)
}
catch {
    # Handle errors
    Write-Error "Error: $_"
    # Stop the script execution
    exit 1
}
Add-ADGroupMember -Identity $distGroup -Members $user

# Set paramaters for Get-ADGroup
$tilgangGroupParams = @{
    SearchBase = 'OU=Tilgangsgrupper,OU=eAdm,OU=ringsaker.kommune,DC=ringsaker,DC=kommune,DC=no'
    SearchScope = 1
    Filter = "name -like '$($reEnhet)*'"
}
# Attempt to retrieve the group
try {
    $tilgangGroup = Get-ADGroup $tilgangGroupParams -ErrorAction Stop

    # Check the number of groups found
    if ($tilgangGroup.Count -eq 0) {
        throw "No groups were found matching the criteria: $reEnhet"
    }
    elseif ($tilgangGroup.Count -gt 1) {
        # List all groups found for problem-solving purposes
        Write-Host "Groups found:" -ForegroundColor Blue
        Write-Host $($tilgangGroup.Name -join "`r`n")
        throw "More than one group was found matching the criteria: $reEnhet"
    }
    # If exactly one group is found, continue with the script
    Write-Host "Group found:" -ForegroundColor Blue
    Write-Host $($tilgangGroup.Name)
}
catch {
    # Handle errors
    Write-Error "Error: $_"
    # Stop the script execution
    exit 1
}
Add-ADGroupMember -Identity $tilgangGroup -Members $user


<# Define identity
$identity = "alenybe"
$identitySID = (Get-ADUser -Identity $identity).sid.Value
#$identity += "@ringsaker.kommune.no"
#
$identityParams = @{
    Identity = "CN=$name,OU=Studenter,OU=Manuelt opprettet,OU=ringsaker.kommune,DC=ringsaker,DC=kommune,DC=no"
}
$identitySID = (Get-ADUser @identityParams).sid.Value#>
$identitySID = ($user).sid.Value


<# Define folder path
$sourcePath = "C:\" #'\\rkf1\ADM_CHRI$\testAccess'
$folderName = "$($GivenName)_$($Surname)-$($username)"
$FolderPath = "$sourcePath\$folderName" #>

$scriptBlock = {
    param($drivePath)

    $basePath = "$($drivePath)\DATA01"

    $FolderParams = @{
        Path = "$($basePath)"
        #Depth = 1
        Filter = "$($Using:reEnhet)*"
    }
    # Attempt to retrieve the folder
    try {
        $sourcePath = Get-ChildItem @FolderParams -Directory
    
        # Check the number of folders found
        if ($sourcePath.Count -eq 0) {
            throw "No folders were found matching the criteria: $Using:reEnhet"
        }
        elseif ($sourcePath.Count -gt 1) {
            # List all folders found for problem-solving purposes
            Write-Host "Groups found:" -ForegroundColor Blue
            Write-Host $($sourcePath.Name -join "`r`n")
            throw "More than one folder was found matching the criteria: $Using:reEnhet"
        }
        # If exactly one folder is found, continue with the script
        Write-Host "Folder found:" -ForegroundColor Blue
        Write-Host $($sourcePath.Name)
        $sourcePath = "$($basePath)\$($sourcePath)"
        Write-Host $sourcePath
    }
    catch {
        # Handle errors
        Write-Error "Error: $_"
        # Stop the script execution
        exit 1
    }

    #$sourcePath = "C:\" #'\\rkf1\ADM_CHRI$\testAccess'
    $folderName = "$($Using:GivenName)_$($Using:Surname)-$($Using:username)"
    $FolderPath = "$sourcePath\$folderName"



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


    # $acl = Get-Acl -Path $FolderPath # Get current ACL

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
    
    # Give user modify access using bash because PS doesn't support using SID
    icacls $FolderPath /grant *$Using:identitySID":(M)"
    
    (Get-Acl -Path $FolderPath).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize
}

# Run Invoke-Command for rkf1hs with E:\DATA01
Invoke-Command -ComputerName rkf1hs -ScriptBlock $scriptBlock -ArgumentList "E:"

# Run Invoke-Command for rkhsdata with D:\DATA01
Invoke-Command -ComputerName rkhsdata -ScriptBlock $scriptBlock -ArgumentList "D:"



Write-Host "Dette scriptet gjør ikke E-post og Profil!
Husk å åpne web.ringsaker.kommune.no/ecp og opprette E-post til brukeren.
Husk å åpne VO40FAG01 eller VO40FAG02 og opprette bruker i Profil." -ForegroundColor Green