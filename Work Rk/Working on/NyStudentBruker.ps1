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


# Get user executing this script and check it they are Domain Admins
$runningUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name # Get DOMAIN\user
$runningUser = $runningUser.Split('\')[-1] # Remove DOMAIN\

[bool]$isDomainAdmin = (Get-ADUser $runningUser -Properties memberof).memberof -contains (Get-ADGroup "Domain Admins")
If ($isDomainAdmin) {Write-Host "Kjører som Domain Admins"}
else {Throw "Kan ikke kjøre uten å være i Domain Admins"}

$testSikker = [System.Net.Sockets.TcpClient]::new().ConnectAsync("VO40FAG02", 3389).Wait(100)
If (-not $testSikker) {Throw "Kan ikke kjøre utenfor sikker sone"}


$userPath = "OU=Studenter,OU=Manuelt opprettet,OU=ringsaker.kommune,DC=ringsaker,DC=kommune,DC=no"

$givenName = <#Read-Host "`nFornavn`n"#> "testuserChr"
$surname = <#Read-Host "`nEtternavn`n"#> "testuserLan"
$name = "$GivenName $Surname"
$username = <#Read-Host "`nBrukernavn`n"#> "testuserchrlan"

$mobilePhone = Read-Host "`nTelefonnummer`n"
$description = Read-Host "`nBruker beskrivelse`neks: RE424-Psykisk helse og rustjenester - Sykepleierstudent`n"
$department = Read-Host "`nOffice felt`neks: RE424-Psykisk helse og rustjenester`n"

$passwordLength = "8"
$randomPassword = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count $PasswordLength | ForEach-Object {[char]$_})

$accountExpiration = Get-UIdate


$splat = @{
    Name = $name
    DisplayName = $name
    GivenName = $givenName
    Surname = $surname
    SamAccountName = $username

    MobilePhone = $mobilePhone
    Description = $description
    Office = $department
    Department = $department

    Path = $userPath
    AccountExpirationDate = $accountExpiration
    AccountPassword = (ConvertTo-SecureString $randomPassword -AsPlainText -Force)
    ChangePasswordAtLogon = $false
    ScriptPath = "HSVO40.BAT"
    Enabled = $true
}

$reEnhet = Read-Host "`nHvilken RE enhet?`neks: re424`n"



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
$distGroup = Get-ADGroup @distGroupParams -ErrorAction Stop

# Check the number of groups found
if ($distGroup.Count -eq 0) {
    throw "Fant ingen dist-grupper som matcher: $reEnhet"
}
elseif ($distGroup.Count -gt 1) {
    # List all groups found for problem-solving purposes
    Write-Host "Grupper funnet:" -ForegroundColor Blue
    Write-Host $($distGroup.Name -join "`r`n")
    throw "Fant flere dist-grupper som matcher: $reEnhet"
}
# If exactly one group is found, continue with the script
Write-Host "Dist-gruppe funnet:" -ForegroundColor Blue
Write-Host $($distGroup.Name)



# Set paramaters for Get-ADGroup
$tilgangGroupParams = @{
    SearchBase = 'OU=Tilgangsgrupper,OU=eAdm,OU=ringsaker.kommune,DC=ringsaker,DC=kommune,DC=no'
    SearchScope = 1
    Filter = "name -like '$($reEnhet)*'"
}

# Attempt to retrieve the group
$tilgangGroup = Get-ADGroup $tilgangGroupParams -ErrorAction Stop

# Check the number of groups found
if ($tilgangGroup.Count -eq 0) {
    throw "Fant ingen tilgangs-grupper som matcher: $reEnhet"
}
elseif ($tilgangGroup.Count -gt 1) {
    # List all groups found for problem-solving purposes
    Write-Host "Grupper funnet:" -ForegroundColor Blue
    Write-Host $($tilgangGroup.Name -join "`r`n")
    throw "Fant flere tilgangs-grupper som matcher: $reEnhet"
}
# If exactly one group is found, continue with the script
Write-Host "Tilgangs-gruppe funnet:" -ForegroundColor Blue
Write-Host $($tilgangGroup.Name)


Write-Host "`nOppretter bruker og tildeler grupper" -ForegroundColor Blue
$user = New-ADUser @splat -Confirm
Add-ADGroupMember -Identity $distGroup -Members $user
Add-ADGroupMember -Identity $tilgangGroup -Members $user



$identitySID = ($user).sid.Value

$scriptBlock = {
    param($drivePath)

    $basePath = "$($drivePath)\DATA01"

    $FolderParams = @{
        Path = "$($basePath)"
        #Depth = 1
        Filter = "$($Using:reEnhet)*"
    }
    # Attempt to retrieve the folder
    $sourcePath = Get-ChildItem @FolderParams -Directory

    # Check the number of folders found
    if ($sourcePath.Count -eq 0) {
        throw "Fant ingen mapper som matcher $Using:reEnhet på $($drivePath)"
    }
    elseif ($sourcePath.Count -gt 1) {
        # List all folders found for problem-solving purposes
        Write-Host "Mapper funnet:" -ForegroundColor Blue
        Write-Host $($sourcePath.Name -join "`r`n")
        throw "Fant flere mapper som matcher $Using:reEnhet på $($drivePath)"
    }
    # If exactly one folder is found, continue with the script
    Write-Host "Mappe funnet på $($drivePath):" -ForegroundColor Blue
    Write-Host $($sourcePath.Name)
    $sourcePath = "$($basePath)\$($sourcePath)"
    Write-Host $sourcePath


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
    $subFolders = @("Excel", "Fagserver", "MALER", "Mine datakilder", "Powerpoint", "Privat", "Temp", "Tmp", "varebest", "Word")
    foreach ($subFolder in $subFolders) {
        New-Item -Path "$folderPath" -Name $subFolder -ItemType Directory
    }


    # Create a new ACL
    $acl = New-Object System.Security.AccessControl.DirectorySecurity

    # Disable inheritance
    $acl.SetAccessRuleProtection($true, $false)

    # Create FileSystemAccessRule for system and administrators with FullControl
    $accessRules = @(
        New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"),
        New-Object System.Security.AccessControl.FileSystemAccessRule($Administrators, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    )
    foreach ($accessRule in $accessRules) {
        $acl.AddAccessRule($accessRule)
    }
    
    $accessOwner = New-Object System.Security.Principal.Ntaccount("$folderOwner")
    $acl.SetOwner($accessOwner)
    
    
    # Apply modified ACL to folder
    Set-Acl -Path $folderPath -AclObject $acl
    
    # Give user modify access using bash because PS doesn't support using SID
    icacls $FolderPath /grant *$Using:identitySID":(M)"

    # Make folder a share
    New-SmbShare -Name "$($Using:username)$" -Path "$FolderPath" -FullAccess "Everyone"
    
    (Get-Acl -Path $FolderPath).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize
}

# Run Invoke-Command for rkf1hs with E:\DATA01
try {Invoke-Command -ComputerName rkf1hs -ScriptBlock $scriptBlock -ArgumentList "E:"}
catch {
    Write-Error "Error oppsto på rkf1hs: $_"
    $addDomain = Read-Host "Vil du fortsette med rkhsdata?
Valg:
        (Y) Ja (standard)
        (N) Nei

"
}
if (($addDomain -eq "N") -or ($addDomain -eq "Nei") -or ($addDomain -eq "No")) {Exit 1}

# Run Invoke-Command for rkhsdata with D:\DATA01
try {Invoke-Command -ComputerName rkhsdata -ScriptBlock $scriptBlock -ArgumentList "D:"}
catch {Write-Error "Error oppsto på rkhsdata: $_"}



Write-Host "Dette scriptet gjør ikke E-post og Profil!
Husk å åpne web.ringsaker.kommune.no/ecp og opprette E-post til brukeren.
Husk å åpne VO40FAG01 eller VO40FAG02 og opprette bruker i Profil." -ForegroundColor Green