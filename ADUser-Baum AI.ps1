do {
    $firstName = Read-Host "Enter the user's first name"
    if ($firstName -notmatch "^[a-zA-Z]+$") {
        Write-Host "Error: Invalid first name. Please enter a valid name."
    }
    else {
        break
    }
} until ($false)

do {
    $lastName = Read-Host "Enter the user's last name"
    if ($lastName -notmatch "^[a-zA-Z]+$") {
        Write-Host "Error: Invalid last name. Please enter a valid name."
    }
    else {
        break
    }
} until ($false)

do {
    $UserInputCountry = Read-Host "Enter the Country for the user"
    $OUPath = "OU=$UserInputCountry,OU=Baum AI,OU=Brukere,DC=baum-ai,DC=corp"
    try {
        $test = Get-ADOrganizationalUnit -Identity $OUPath -ErrorAction Stop
        break
    }
    catch {
        Write-Host "Error: $($_.Exception.Message). Please enter a valid Country."
    }
} until ($false)

do {
    $UserInputDepartment = Read-Host "Enter the Department for the user"
    $OUPath = "OU=$UserInputDepartment,OU=$UserInputCountry,OU=Baum AI,OU=Brukere,DC=baum-ai,DC=corp"
    try {
        $test = Get-ADOrganizationalUnit -Identity $OUPath -ErrorAction Stop
        break
    }
    catch {
        Write-Host "Error: $($_.Exception.Message). Please enter a valid Department."
    }
} until ($false)


$GivenName = $firstName
$Surname = $lastName
$Name = "$GivenName $Surname"

$AccountPassword = "Qwerty123"

New-ADUser -WhatIf -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $OUPath -UserPrincipalName $Name -Surname $Surname