# Connect to Active Directory
Import-Module ActiveDirectory

# Define the target OU path
$targetOU = "OU=Russland,OU=Baum AI,OU=Brukere,DC=baum-ai,DC=corp"  # Replace with your actual OU path

# Define the names of the OUs to be created
$ouNames = "Ledelse", "Økonomi", "Logistikk", "Utvikling", "Salg", "HR"  # Replace with the desired OU names

# Create OUs
$ouNames | ForEach-Object {
    $ouPath = "OU=$_,$targetOU"
    try {
        New-ADOrganizationalUnit -Name $_ -Path $targetOU -ErrorAction Stop
        Write-Host "Created OU: $ouPath"
    }
    catch {
        Write-Host "Failed to create OU: $ouPath"
        Write-Host "Error: $_"
    }
}