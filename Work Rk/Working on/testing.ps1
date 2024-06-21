#---------------------------------------------------------[Init]--------------------------------------------------------
# Init PowerShell Gui
Add-Type -AssemblyName PresentationCore, PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()

#---------------------------------------------------------[Hovedvindu]--------------------------------------------------------

#Hovedvindu
$mainForm = New-Object system.Windows.Forms.Form
$mainForm.ClientSize = '750,650'
$mainForm.text = "RKServMan"
$mainForm.BackColor = "#ffffff"
$mainForm.TopMost = $false
#$mainForm.ControlBox = $false


#Now you're thinking with tabs, lad.
#Tab-control to major Tom
$mainTab = New-Object System.Windows.Forms.TabControl
$mainTab.Size = "700,550"
$mainTab.Location = '15,50'
$mainTab.Multiline = $True
$mainTab.Name = 'tabPage'
$mainTab.SelectedIndex = 0
#$mainTab.Anchor = 'Top,Left,Bottom,Right'
$mainForm.Controls.Add($mainTab)

#Tabpage 1
$tabPage1 = New-Object System.Windows.Forms.TabPage
$tabPage1.Name = 'tabPage1'
$tabPage1.Padding = '5,5,5,5'
$tabPage1.TabIndex = 1
$tabPage1.Text = 'BrukerSøk'
$tabPage1.UseVisualStyleBackColor = $True
$tabPage1.Enabled = $true
$mainTab.Controls.Add($tabPage1)


#Tabpage 2
$tabPage2 = New-Object System.Windows.Forms.TabPage
$tabPage2.Name = 'tabPage2'
$tabPage2.Padding = '5,5,5,5'
$tabPage2.TabIndex = 2
$tabPage2.Text = 'Etc'
$tabPage2.UseVisualStyleBackColor = $True
$tabPage2.Enabled = $true
$mainTab.Controls.Add($tabPage2)



#Lag en liten knapp som viser om man er i sikker sone eller ikke.
$erSikker = New-Object System.Windows.Forms.CheckBox
$erSikker.location = New-Object System.Drawing.Point(600, 15)
$erSikker.Enabled = 0
$erSikker.Appearance = 1
$mainForm.Controls.Add($erSikker)

#---------------------------------------------------------[Tabpage 1]--------------------------------------------------------

#Tekst over søkefeltet
$searchLabel = New-Object System.Windows.Forms.Label
$searchLabel.Font = 'Microsoft Sans Serif,10'
$searchLabel.TextAlign = 2
$searchLabel.text = "Search for username"
$searchLabel.Height = 20
$searchLabel.Width = 150
$searchLabel.Location = New-Object System.Drawing.Point(25, 125)
$tabPage1.Controls.Add($searchLabel)

#Fritekstfelt for å søke etter brukere
$userTextBox = New-Object System.Windows.Forms.TextBox
$userTextBox.height = 25
$userTextBox.Width = 150
$userTextBox.Location = New-Object System.Drawing.Point(25, 150)
$tabPage1.Controls.Add($userTextBox)

#Knappen for å søke opp bruker på servere
$searchButton = New-Object system.Windows.Forms.Button
$searchButton.BackColor = "#ffffff"
$searchButton.text = "Search"
$searchButton.width = 100
$searchButton.height = 25
$searchButton.location = New-Object System.Drawing.Point(50, 175)
$searchButton.Font = 'Microsoft Sans Serif,10'
$searchButton.ForeColor = "#000"
$tabPage1.Controls.Add($searchButton)

$resultListView = new-object System.Windows.Forms.ListView
$resultListView.View = 'Details'
$resultListView.Width = 400
$resultListView.Height = 400
$resultListView.Location = New-Object System.Drawing.Point(250, 100)
$resultListView.FullRowSelect = $true
$resultListView.MultiSelect = $false
$resultListView.Columns.Add('Username') | Out-Null
$resultListView.Columns.Add('Server') | Out-Null
$resultListView.Columns.Add('Session ID') | Out-Null
$resultListView.Columns.Add('State') | Out-Null
$tabPage1.Controls.Add($resultListView)

#Tekst over søkefeltet
$serverLabel = New-Object System.Windows.Forms.Label
$serverLabel.Font = 'Microsoft Sans Serif,10'
$serverLabel.TextAlign = 2
$serverLabel.text = "List users per server"
$serverLabel.Height = 20
$serverLabel.Width = 150
$serverLabel.Location = New-Object System.Drawing.Point(25, 325)
$tabPage1.Controls.Add($serverLabel)

#Knappen som henter inn brukere
$populateButton = New-Object system.Windows.Forms.Button
$populateButton.BackColor = "#ffffff"
$populateButton.text = "Get Users"
$populateButton.width = 100
$populateButton.height = 50
$populateButton.location = New-Object System.Drawing.Point(50, 375)
$populateButton.Font = 'Microsoft Sans Serif,10'
$populateButton.ForeColor = "#000"
$tabPage1.Controls.Add($populateButton)

#Nedtrekksmeny som lister opp servere
$serverList = New-Object System.Windows.Forms.ComboBox
$serverList.BackColor = "#ffffff"
$serverList.text = "Select server"
$serverList.width = 150
$serverList.height = 200
$serverList.location = New-Object System.Drawing.Point(25, 350)
$serverList.Font = 'Microsoft Sans Serif,10'
$serverList.ForeColor = "#000"
$tabPage1.Controls.Add($serverList)

#Knappen for å starte shadow session
$shadowButton = New-Object system.Windows.Forms.Button
$shadowButton.BackColor = "#ffffff"
$shadowButton.text = "Shadow User"
$shadowButton.width = 100
$shadowButton.height = 50
$shadowButton.location = New-Object System.Drawing.Point(300, 15)
$shadowButton.Font = 'Microsoft Sans Serif,10'
$shadowButton.ForeColor = "#000"
$tabPage1.Controls.Add($shadowButton)

#Knappen for å logge av bruker
$killButton = New-Object system.Windows.Forms.Button
$killButton.BackColor = "#ffffff"
$killButton.text = "Log off user"
$killButton.width = 100
$killButton.height = 50
$killButton.location = New-Object System.Drawing.Point(450, 15)
$killButton.Font = 'Microsoft Sans Serif,10'
$killButton.ForeColor = "#000"
$tabPage1.Controls.Add($killButton)

#---------------------------------------------------------[Tabpage 2]--------------------------------------------------------

#Legg inn noe her

#Tekst
$tab2Label = New-Object System.Windows.Forms.Label
$tab2Label.Font = 'Microsoft Sans Serif,10'
$tab2Label.TextAlign = 2
$tab2Label.text = "Work in progress"
$tab2Label.Height = 20
$tab2Label.Width = 400
$tab2Label.Location = New-Object System.Drawing.Point(25, 25)
$tabPage2.Controls.Add($tab2Label)


#-----------------------------------------------------------SERVERLISTE!!!!!!!!!---------------------------------------------------

#Sjekk om man når Sikker Sone.
$testSikker = [System.Net.Sockets.TcpClient]::new().ConnectAsync("VO40FAG02", 3389).Wait(100)
#Write-Host $testSikker

#Hent servere fra fil
$dataFile = "C:\Users\chrlang\OneDrive - Ringsaker kommune\Dokumenter\GitHub\PowerShell-scripts\Work Rk\Working on\servere.txt"
$allServers = Get-Content $dataFile

$keyWords =  $allServers | Select-String ' --- Sikker under ---'
$lineNumbers = ($keyWords.LineNumber - 1)
$openServers = Get-Content $dataFile -TotalCount $lineNumbers
#Write-Host $openServers

$secureServersStart = $allServers | Select-String ' --- Sikker under ---' | Select-Object -Last 1 -Expand LineNumber
$secureServers = $allServers | Select-Object -Skip $secureServersStart
#Write-Host $secureServers


#Legg til alle merkantile servere

foreach ($openServer in $openServers) {
    [void]$serverList.Items.Add("$($openserver)")
}

<#
[void]$serverList.Items.Add("RKTS01")
[void]$serverList.Items.Add("RKTS02")
[void]$serverList.Items.Add("RKTS03")
[void]$serverList.Items.Add("RKTS04")
[void]$serverList.Items.Add("RKTS05")
[void]$serverList.Items.Add("RKTS06")
[void]$serverList.Items.Add("RKTS08")
[void]$serverList.Items.Add("RKTS011")
[void]$serverList.Items.Add("RKTS20")
[void]$serverList.Items.Add("RKTS021")
[void]$serverList.Items.Add("RKTS031")
[void]$serverList.Items.Add("RE520M")
[void]$serverList.Items.Add("RKTSPPT")
[void]$serverList.Items.Add("RKTSNAVM")
[void]$serverList.Items.Add("OPPVEKST1")
[void]$serverList.Items.Add("BARNEHAGE1")
[void]$serverList.Items.Add("RKTSVO20")
[void]$serverList.Items.Add("RKTSVO30")
[void]$serverList.Items.Add("RKTSBV")
#>


#Sjekk resultatet fra testSikker ovenfor og legg til fagserverene om man når sikker sone
if ($testSikker) {
    foreach ($secureServer in $secureServers) {
        [void]$serverList.Items.Add("$($secureServer)")
    }
    
    #Write-Host "Sikker Sone"
    $erSikker.text = "Sikker Sone"
    <#
    [void]$serverList.Items.Add("VO30FAG01")
    [void]$serverList.Items.Add("VO40FAG01")
    [void]$serverList.Items.Add("VO40FAG02")
    [void]$serverList.Items.Add("VO50FAG02")
    [void]$serverList.Items.Add("RE520F")
    [void]$serverList.Items.Add("RKTSNAVF")
    #>
}
else {
    $erSikker.text = "Usikker Sone"
    #Write-Host "Usikker Sone"
}

#-----------------------------------------------------------[Functions]------------------------------------------------------------

#----------------------------Funksjoner - Tab 1--------------------

#Funksjonen for å søke etter bruker på serverene
function SearchUser {

    if ($userTextBox.TextLength -eq 0) {
        [System.Windows.MessageBox]::Show("Skriv inn brukernavn, smarting!")
    }
    else {
        $resultListView.Items.Clear()
        $user = $userTextBox.Text



#<#
            # List to store job objects
            $jobs = @()

            # Start a job for each server in the list
            foreach ($server in $serverList.Items) {
                $jobs += Start-Job -ScriptBlock {
                    param($server, $user)
                    quser $user /server:$server 2>&1
                } -ArgumentList $server, $user
            }
            # Wait for all jobs to complete
            $jobs | ForEach-Object {
                $job = $_
                $job | Wait-Job
            }
            # Collect results from all jobs
            $results = $jobs | ForEach-Object {
                Receive-Job -Job $_
            }
            # Clean up
            $jobs | ForEach-Object {
                Remove-Job -Job $_
            }
            # Process results
            $results | ForEach-Object {
                Write-Output $_
                $quserRegex = (($_) -replace '\s{20,39}', ',,') -replace '\s{2,}', ',' | ConvertFrom-Csv    
                $quserObject = $quserRegex | Select-Object username, ID, STATE

                if ($quserObject.ID) {
                    $result = New-Object System.Windows.Forms.ListViewItem($quserObject.USERNAME)
                    $result.Subitems.Add($server)
                    $result.Subitems.Add($quserObject.ID)
                    $result.Subitems.Add($quserObject.STATE)
                    $resultListView.Items.Add($result)
                    Write-Host $quserResult
                }
            }
            Write-Host $quserResult
#>

Start-Sleep -seconds 5
$resultListView.Items.Clear



        foreach ($server in $serverList.Items) {
            $quserResult = quser $user /server:$server 2>&1
            $quserRegex = (($quserResult) -replace '\s{20,39}', ',,') -replace '\s{2,}', ',' | ConvertFrom-Csv    
            $quserObject = $quserRegex | Select-Object username, ID, STATE

            if ($quserObject.ID) {
                $result = New-Object System.Windows.Forms.ListViewItem($quserObject.USERNAME)
                $result.Subitems.Add($server)
                $result.Subitems.Add($quserObject.ID)
                $result.Subitems.Add($quserObject.STATE)
                $resultListView.Items.Add($result)
                Write-Host $quserResult
            }
        }
    }
}

#Funksjon for å hente inn alle brukersesjoner fra en valgt server
function GetUsers {

    if ($null -eq $serverList.SelectedItem) {
        [System.Windows.MessageBox]::Show("Men, skulle ikke du velge en server da?")
    }
    else {
        $resultListView.Items.Clear()
        #$getUserCommand = quser
        $valgtServer = $serverList.SelectedItem
        #har tatt vekk -Credential fra Invoke-Command
        $quserResult = Invoke-Command -ComputerName $valgtServer -ScriptBlock { quser }
        $quserRegex = (($quserResult) -replace '\s{20,39}', ',,') -replace '\s{2,}', ',' | ConvertFrom-Csv
        $quserObject = $quserRegex | Select-Object username, ID, STATE
        #Legg inn i ListView
        foreach ($item in $quserObject) {
            $result = New-Object System.Windows.Forms.ListViewItem($item.USERNAME)
            $result.Subitems.Add($valgtServer)
            $result.Subitems.Add($item.ID)
            $result.Subitems.Add($item.STATE)
            $resultListView.Items.Add($result)
        }
    }
}

#Funksjonen for å shadowe brukere
function ShadowUser {

    $valgtBruker = $resultListView.SelectedItems.SubItems[0].text
    $valgtServer = $resultListView.SelectedItems.SubItems[1].text
    $valgtID = $resultListView.SelectedItems.SubItems[2].text


    if ($null -eq $valgtBruker) {
        [System.Windows.MessageBox]::Show("Select a User, Loser!")
    }
    else {
        $shadowConfirmation = [System.Windows.MessageBox]::Show("Are you sure you want to shadow this user: " + $valgtBruker + " ID: " + $valgtID, "Remote Desktop", 4, 48)
        if ($shadowConfirmation -eq "Yes") {
            mstsc /v:$valgtServer /shadow:$valgtID /control
        }
    }
}

#Funksjonen for å avslutte sesjoner
function KillSession {
    $valgtServer = $serverList.SelectedItem
    $valgtBruker = $resultListView.SelectedItems.SubItems[0].text
    $valgtID = $resultListView.SelectedItems.SubItems[2].text

    if ($null -eq $valgtBruker) {
        [System.Windows.MessageBox]::Show("Select a User, Loser!")
    }
    elseif ($valgtServer -eq "localhost") { logoff $valgtID }

    else {
        $killConfirmation = [System.Windows.MessageBox]::Show("Are you sure you want to log off this user: " + $valgtBruker + " ID: " + $valgtID , "Log off user", 4, 48)
        if ($killConfirmation -eq "Yes") {
            logoff $valgtID /server:$valgtServer
        }
    }

}

#-------schnippen schnappen, klikk på knappen----------------

#Fane 1 knapper
$searchButton.Add_Click({ SearchUser })
$populateButton.Add_Click({ GetUsers })
$shadowButton.Add_Click({ ShadowUser })
$killButton.Add_Click({ KillSession })


#---------------------------------------------------------[Main]--------------------------------------------------------

[void]$mainForm.ShowDialog()