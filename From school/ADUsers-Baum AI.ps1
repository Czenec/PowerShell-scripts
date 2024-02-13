# ---Felles---InitialPath

$AccountPassword = "Qwerty123"

$InitialPath = "OU=Norge,OU=Baum AI,OU=Brukere,DC=baum-ai,DC=corp"

# ---HR---

$Path = "OU=HR,$InitialPath"

# - Brukere -

$GivenName = "Cain"
$Surname = "Roth"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Randy"
$Surname = "Carpenter"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Colin"
$Surname = "Norton"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



# ---Ledelse---

$Path = "OU=Ledelse,$InitialPath"

# - Brukere -


$GivenName = "Jessica"
$Surname = "Hancock"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Honor"
$Surname = "Manning"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Anoushka"
$Surname = "Anthony"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Fay"
$Surname = "Dyer"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



# ---Logistikk---

$Path = "OU=Logistikk,$InitialPath"

# - Brukere -


$GivenName = "Aron"
$Surname = "Pace"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Nora"
$Surname = "Odling"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Zeeshan"
$Surname = "Maldonado"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



# ---Okonomi---

$Path = "OU=Okonomi,$InitialPath"

# - Brukere -


$GivenName = "Malik"
$Surname = "Frederick"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Prince"
$Surname = "Flynn"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Izabella"
$Surname = "Moran"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



# ---Salg---

$Path = "OU=Salg,$InitialPath"

# - Brukere -


$GivenName = "Ronan"
$Surname = "Gentry"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Cleo"
$Surname = "Leblanc"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Siobhan"
$Surname = "Lopez"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



# ---Utvikling---

$Path = "OU=Utvikling,$InitialPath"

# - Brukere -


$GivenName = "Leia"
$Surname = "Arnold"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Kane"
$Surname = "Bell"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname



$GivenName = "Cara"
$Surname = "Gallegos"
$Name = "$GivenName $Surname"

New-ADUser -AccountPassword (convertto-securestring $AccountPassword -AsPlainText -force)`
-DisplayName $Name -Enabled 1 -GivenName $GivenName -Name $Name -ChangePasswordAtLogon 1 -Path $Path -UserPrincipalName $Name -Surname $Surname