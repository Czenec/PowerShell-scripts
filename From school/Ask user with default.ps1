$default = "default value" # a normal number is writen without parentheses
$userInput = $(Write-Host "Enter a value or text (Default: default value)  " -ForegroundColor Blue -NoNewline; Read-Host)
if ([string]::IsNullOrWhiteSpace($userInput)) {
    $userInput = $default
}
$Output = $userInput # * 1MB
Write-Output $Output