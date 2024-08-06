$Uri = "https://api.restful-api.dev/objects/ff808181910285430191032b4eda01fd"

$data = Invoke-RestMethod -Uri $Uri


#$table = ($data | Format-Table | Out-String)

#Write-Host $table


# Flatten the data and select properties
$flattenedData = $data | ForEach-Object {
    $props = $_.data.PSObject.Properties | ForEach-Object {
        @{Name = $_.Name; Value = $_.Value}
    }
    [PSCustomObject]@{
        ID              = $_.id
        Name            = $_.name
        Color           = ($props | Where-Object { $_.Name -eq 'color' }).Value
        CPU             = ($props | Where-Object { $_.Name -eq 'CPU model' }).Value
        "Capacity (GB)" = ($props | Where-Object { $_.Name -eq 'Capacity' -or $_.Name -eq 'capacity GB' -or $_.Name -eq 'Hard disk size' }).Value -replace " GB", "" -replace " TB", "000"
        ScreenSize      = ($props | Where-Object { $_.Name -eq 'Screen size' }).Value
        Generation      = ($props | Where-Object { $_.Name -eq 'generation'}).Value
        Price           = ($props | Where-Object { $_.Name -eq 'price' }).Value
        Description     = ($props | Where-Object { $_.Name -eq 'Description' }).Value
        CreatedAt       = $_.createdAt
        UpdatedAt       = $_.updatedAt
    }
}

# Specify the properties to include in the output
$properties = @(
    'ID', 'Name', 'Color', 'CPU', 'Capacity (GB)', 'ScreenSize',
    'Generation', 'Price', 'Description', 'CreatedAt', 'UpdatedAt'
)

# Format the output as a table with specified properties
$flattenedData | Format-Table -Property $properties -AutoSize | Out-String | Write-Output

Write-Host "`n------------------------------------------------------------`n"
Write-Host "begin new object`n"

<#
$NewObjectName          = Read-Host
$NewObjectColor         = Read-Host
$NewObjectCPU           = Read-Host
$NewObjectCapacity      = Read-Host
$NewObjectScreenSize    = Read-Host
$NewObjectGeneration    = Read-Host
$NewObjectPrice         = Read-Host
$NewObjectDescription   = Read-Host
#>

# ADD CHECKS FOR IF THEYRE EMPTY

$Psobj = New-Object -Type psobject

$dataObj = New-Object -Type psobject
$dataObj | Add-Member -MemberType NoteProperty -Name color -Value "black"
$dataObj | Add-Member -MemberType NoteProperty -Name "capacity GB" -Value "245"
$dataObj | Add-Member -MemberType NoteProperty -Name generation -Value "1st"
$dataObj | Add-Member -MemberType NoteProperty -Name price -Value "299,99"

$Psobj | Add-Member -MemberType NoteProperty -Name name -Value "Nothing(1)" -Force
$Psobj | Add-Member -MemberType NoteProperty -Name data -Value $dataObj -Force

#<#
$sentdata = Invoke-RestMethod -Uri $Uri -Method Put -Body ($Psobj|ConvertTo-Json) -ContentType "application/json"

$flattenedsentData = $sentdata | ForEach-Object {
    $props = $_.data.PSObject.Properties | ForEach-Object {
        @{Name = $_.Name; Value = $_.Value}
    }
    Write-Host "Processing item ID: $($_.id)"
    Write-Host "CreatedAt: $($_.createdAt)"
    Write-Host "UpdatedAt: $($_.updatedAt)"
    [PSCustomObject]@{
        ID              = $_.id
        Name            = $_.name
        Color           = ($props | Where-Object { $_.Name -eq 'color' }).Value
        CPU             = ($props | Where-Object { $_.Name -eq 'CPU model' }).Value
        "Capacity (GB)" = ($props | Where-Object { $_.Name -eq 'Capacity' -or $_.Name -eq 'capacity GB' -or $_.Name -eq 'Hard disk size' }).Value -replace " GB", "" -replace " TB", "000"
        ScreenSize      = ($props | Where-Object { $_.Name -eq 'Screen size' }).Value
        Generation      = ($props | Where-Object { $_.Name -eq 'generation'}).Value
        Price           = ($props | Where-Object { $_.Name -eq 'price' }).Value
        Description     = ($props | Where-Object { $_.Name -eq 'Description' }).Value
        UpdatedAt       = $_.updatedAt
        CreatedAt       = $_.createdAt
    }
}

# Specify the properties to include in the output
$sentproperties = @(
    'ID', 'Name', 'Color', 'CPU', 'Capacity (GB)', 'ScreenSize',
    'Generation', 'Price', 'Description', 'CreatedAt', 'UpdatedAt'
)

# Format the output as a table with specified properties
$flattenedsentData | Format-Table -Property $sentproperties -AutoSize | Out-String | Write-Output
#>
#$sentdata | Write-Output