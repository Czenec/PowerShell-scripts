# Get the full path of the currently executing script
$scriptFullPath = $MyInvocation.MyCommand.Path
# Get the directory of the currently executing script
$scriptDirectory = Split-Path -Parent $scriptFullPath

$authFile = Get-Content -Path "$scriptDirectory\sysmanx-auth.txt"

# Extract the username and password
$usernameIndex = ($authFile | Select-String -Pattern '-- username --').LineNumber
$passwordIndex = ($authFile | Select-String -Pattern '-- password --').LineNumber

# The username and password are the lines immediately following their respective markers
$username = $authFile[$usernameIndex]
$password = $authFile[$passwordIndex]

Write-Host "$username
$password"