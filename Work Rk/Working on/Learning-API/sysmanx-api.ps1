function Get-numberLists {
    param (
        [Alias("nlu")]
        [Parameter(Mandatory = $true, Position = 0)]
        [System.String]
        $functionNumberListUri
    )

    $apiResponse = Invoke-RestMethod -Uri $functionNumberListUri -Method Get

    Write-Host $apiResponse
}

$sendUri = "http://10.10.15.100:5000/api/v10/messages/send"
$numberListUri = "http://10.10.15.100:5000/api/v10/numberlists"


# Get the full path of the currently executing script
$scriptFullPath = $MyInvocation.MyCommand.Path
# Get the directory of the currently executing script
$scriptDirectory = Split-Path -Parent $scriptFullPath

# Read the authentication file
$authFile = Get-Content -Path "$scriptDirectory\sysmanx-auth.txt"

# Extract the username and password
$usernameIndex = ($authFile | Select-String -Pattern '-- username --').LineNumber
$passwordIndex = ($authFile | Select-String -Pattern '-- password --').LineNumber

# The username and password are the lines immediately following their respective markers
$username = $authFile[$usernameIndex]
$password = $authFile[$passwordIndex]

# Encode the username and password in Base64
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($username):$($password)"))

# Set the headers including the Authorization header
$headers = @{
    Authorization = "Basic $base64AuthInfo"
}



Write-Host "What do you wish to do?

1. send message
2. Get numberlists
3. Make new numberlist
4. Show numberlist entries
5. Make new numberlist entry
6. Remove numberlist entry
7. Edit numberlist
8. Delete numberlist

11. List local contacts
12. New local contact

" -ForegroundColor Blue
$whatDo = Read-Host

#---------- send message ----------
if ($whatDo -eq 1) {
    do {
        Write-Host "`nWhat phone number?`n" -ForegroundColor Blue
        $messageNumber = Read-Host
        if ($messageNumber -match '^(0047\d{8}|\d{8})$') {
            Write-Host "Valid phone number entered: $messageNumber" -ForegroundColor Green
            $validNumber = $true
        }
        elseif ($messageNumber -match 'doorbellQue') {
            Write-Host "Valid numberlist entered: $messageNumber" -ForegroundColor Green
            $validNumber = $true
        }
        else {
            Write-Host "Invalid phone number. Please enter a valid phone number." -ForegroundColor Red
            $validNumber = $false
        }
    } while (-not $validNumber)

    Write-Host "`nwhat should the message say?`n" -ForegroundColor Blue
    $messageContents = Read-Host

    #<#
    $Psobj = New-Object -Type psobject
    
    $Psobj | Add-Member -MemberType NoteProperty -Name receiver -Value "$($messageNumber)" -Force
    $Psobj | Add-Member -MemberType NoteProperty -Name message -Value "$($messageContents)" -Force
<#    $Psobj | Add-Member -MemberType NoteProperty -Name isFlash -Value "false" -Force
    $Psobj | Add-Member -MemberType NoteProperty -Name isDial -Value "false" -Force
    $Psobj | Add-Member -MemberType NoteProperty -Name isMasked -Value "false" -Force
    $Psobj | Add-Member -MemberType NoteProperty -Name requestDeliveryReport -Value "false" -Force
    $Psobj | Add-Member -MemberType NoteProperty -Name requireActiveChannelToSend -Value "false" -Force
#>    
    $final_data = $Psobj | ConvertTo-Json

    $apiResponse = Invoke-RestMethod -Uri $sendUri -Method Post -Body $final_data -ContentType "application/json"
    
    Write-Host $final_data
    
    Write-Host $apiResponse
}

#---------- Get numberlists ----------
if ($whatDo -eq 2) {
    Get-numberLists -functionNumberListUri $numberListUri
}

#---------- New numberlist ----------
if ($whatDo -eq 3) {
    Write-Host "`nNumberlist name`n" -ForegroundColor Blue
    $numberListName = Read-Host


    $Psobj = New-Object -Type psobject
    
    $Psobj | Add-Member -MemberType NoteProperty -Name name -Value "$($numberListName)" -Force
<#    $Psobj | Add-Member -MemberType NoteProperty -Name calendarActive -Value "false" -Force
    $Psobj | Add-Member -MemberType NoteProperty -Name stepEnabled -Value "false" -Force
    $Psobj | Add-Member -MemberType NoteProperty -Name stepInterval -Value "0" -Force
    $Psobj | Add-Member -MemberType NoteProperty -Name stepConfirmToAll -Value "false" -Force
#>    
    $final_data = $Psobj | ConvertTo-Json

    $apiResponse = Invoke-RestMethod -Uri $numberListUri -Method Post -Body $final_data -ContentType "application/json" -Headers $headers
    
    Write-Host $final_data
    
    Write-Host $apiResponse
}

#---------- Show numberlist entries ----------
if ($whatDo -eq 4) {
    do {
        Write-Host "What numberlist do you wish to view by ID?`nType 'show' to see all numberlists" -ForegroundColor Blue
        $numberListID = Read-Host
    
        if ($numberListID -match '^\d+$') {
            $validInput = $true
        } elseif ($numberListID -eq "show") {
            Write-Host "Displaying all numberlists..."
            $validInput = $false

            Get-numberLists -functionNumberListUri $numberListUri
        } else {
            Write-Host "Invalid input. Please enter a number or type 'show'." -ForegroundColor Red
            $validInput = $false
        }
    } while (-not $validInput)

    Write-Host "You chose to view the numberlist with ID: $numberListID"
    $numberListEntriesIDUri = "$($numberListUri)/$($numberListID)"

    Write-Host $numberListEntriesIDUri


    $apiResponse = Invoke-RestMethod -Uri $numberListEntriesIDUri -Method Get

    Write-Host $apiResponse
}

#---------- Add to numberlist ----------
if ($whatDo -eq 5) {
    do {
        Write-Host "What numberlist do you wish to edit by ID?`nType 'show' to see all numberlists" -ForegroundColor Blue
        $numberListID = Read-Host
    
        if ($numberListID -match '^\d+$') {
            $validInput = $true
        } elseif ($numberListID -eq "show") {
            Write-Host "Displaying all numberlists..."
            $validInput = $false

            Get-numberLists -functionNumberListUri $numberListUri
        } else {
            Write-Host "Invalid input. Please enter a number or type 'show'." -ForegroundColor Red
            $validInput = $false
        }
    } while (-not $validInput)
    
    Write-Host "You chose to edit the numberlist with ID: $numberListID"
    $numberListIDUri = "$($numberListUri)/$($numberListID)/receivers"

    Write-Host $numberListIDUri


    Write-Host "Name of new numberlist entry" -ForegroundColor Blue
    $newEntryName = Read-Host

    Write-Host "Phonenumber of new numberlist entry" -ForegroundColor Blue
    $newEntryNumber = Read-Host


    $Psobj = New-Object -Type psobject

    $primaryObj = New-Object -Type psobject
    $primaryObj | Add-Member -MemberType NoteProperty -Name number -Value "$($newEntryNumber)" -Force
    $primaryObj | Add-Member -MemberType NoteProperty -Name isFlash -Value "false" -Force
    $primaryObj | Add-Member -MemberType NoteProperty -Name isDial -Value "false" -Force
    
    $Psobj | Add-Member -MemberType NoteProperty -Name name -Value "$($newEntryName)" -Force
    $Psobj | Add-Member -MemberType NoteProperty -Name active -Value "true" -Force
    $Psobj | Add-Member -MemberType NoteProperty -Name sortOrder -Value "0" -Force
    $Psobj | Add-Member -MemberType NoteProperty -Name primary -Value $primaryObj -Force
    
    $final_data = $Psobj | ConvertTo-Json

#    $apiResponse = Invoke-RestMethod -Uri $numberListUri -Method Post -Body $final_data -ContentType "application/json"
    
    Write-Host $final_data
    
    Write-Host $apiResponse
}


#---------- New local contact ----------
<#if ($whatDo -eq 12) {
    Write-Host "What is the name of the new contact?" -ForegroundColor Blue
    $newContactName = Read-Host

    Write-Host "What is the phone number of the new contact?" -ForegroundColor Blue
    $newContactNumber = Read-Host
}#>