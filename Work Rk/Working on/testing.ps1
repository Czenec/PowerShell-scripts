
<#
Here's some instructions to myself:
To get Get-ADUser to work over Invoke-Command you need to create a PowerShell session first with propper credentials.
You can do this with Register-PSSessionConfiguration and UnRegister-PSSessionConfiguration, and Invoke-Command -Session.
This way you first create a session with propper credentials, then you enter that session and run your commands, and lastly you close the session to not leave evidence.
You need to do this becuse Get-ADUser is a command that itself gets info from a server 3, and when you Invoke-Command from server 1 to server 2, server 2 cant carry
credentials from server 1 to server 3 for security reasons.

give SID folder permissions, good luck: https://superuser.com/questions/1019558/how-to-add-a-sid-to-a-folder-permissions
#>

#$Credentials = Get-Credential

$reEnhet = Read-Host "ReEnhet"

$scriptBlock = {
    param($drivePath)

    $basePath = "$($drivePath)\DATA01"

    $FolderParams = @{
        Path = "$($basePath)"
        #Depth = 1
        Filter = "$($Using:reEnhet)*"
    }
    # Attempt to retrieve the group
    try {
        $sourcePath = Get-ChildItem @FolderParams -Directory
    
        # Check the number of groups found
        if ($sourcePath.Count -eq 0) {
            throw "No folders were found matching the criteria: $Using:reEnhet"
        }
        elseif ($sourcePath.Count -gt 1) {
            # List all groups found for problem-solving purposes
            Write-Host "Groups found:" -ForegroundColor Blue
            Write-Host $($sourcePath.Name -join "`r`n")
            throw "More than one folder was found matching the criteria: $Using:reEnhet"
        }
        # If exactly one group is found, continue with the script
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


}

# Run Invoke-Command for rkf1hs with E:\DATA01
Invoke-Command -ComputerName rkf1hs -ScriptBlock $scriptBlock -ArgumentList "E:" -Credential $Credentials

# Run Invoke-Command for rkhsdata with D:\DATA01
#Invoke-Command -ComputerName rkhsdata -ScriptBlock $scriptBlock -ArgumentList "D:"
