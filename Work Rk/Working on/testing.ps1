Get-CimInstance -ClassName win32_userprofile |Select-Object -ExpandProperty LocalPath

$userName = $(Write-Host "What user do you wish to delete?  " -ForegroundColor Blue -NoNewline; Read-Host)

$outName = Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq $userName } #| Remove-CimInstance
Write-Host $outName