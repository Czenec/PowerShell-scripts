$default = "default value" # a normal number is writen without parentheses
$userInput = Read-Host "Enter a value or text (Default: default value)"
If(!$userInput) { $userInput = $default }
if ([string]::IsNullOrWhiteSpace($userInput)) {
    $userInput = $default
}
$Output = $userInput # * 1MB
Write-Output $Output