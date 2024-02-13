quser
$userName = Read-Host "what user do you wish to shadow?"


$quserResult = quser

$quserRegex = $quserResult | ForEach-Object -Process { $_ -replace '\s{2,}',',' }
	$quserObject = $quserRegex | ConvertFrom-Csv
	$userSession = $quserObject | Where-Object -FilterScript { $_.USERNAME -eq $userName }
	If ( $userSession )
	{
		$userSessionID = $userSession.ID
        mstsc /shadow:$userSessionID /control
	}