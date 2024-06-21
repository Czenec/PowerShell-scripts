

$serverList = New-Object System.Collections.ArrayList


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
    $serverList.Add("$($openserver)")
}



#Sjekk resultatet fra testSikker ovenfor og legg til fagserverene om man når sikker sone
if ($testSikker) {
    foreach ($secureServer in $secureServers) {
        $serverList.Add("$($secureServer)")
    }
}




$user = "adm_chri"


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
foreach ($ahhh in $results) {
    Write-Output $_
    $quserRegex = (($ahhh) -replace '\s{20,39}', ',,') -replace '\s{2,}', ',' | ConvertFrom-Csv    
    $quserObject = $quserRegex | Select-Object username, ID, STATE

    if ($quserObject.ID) {
        Write-Host $quserResult
    }
}
Write-Host $quserResult
#>







foreach ($server in $serverList.Items) {
$quserResult = quser $user /server:$server 2>&1
$quserRegex = (($quserResult) -replace '\s{20,39}', ',,') -replace '\s{2,}', ',' | ConvertFrom-Csv    
$quserObject = $quserRegex | Select-Object username, ID, STATE

if ($quserObject.ID) {
    Write-Host $quserResult
}
}
