<#
.SYNOPSIS
Creates Azure AD users from a CSV file and assigns Microsoft 365 licenses.

.DESCRIPTION
Automates bulk user creation in Azure AD and assigns default licenses using the AzureAD module.

.INPUTS
CSV file with columns:
- DisplayName
- UserPrincipalName
- UsageLocation

.NOTES
Author: Koya Illek
Requires: AzureAD module
Run as a Global Admin or User Administrator
#>

Import-Module AzureAD
Connect-AzureAD

$users = Import-Csv ".\new_users.csv"

foreach ($user in $users) {
    Write-Host "Creating user: $($user.DisplayName)"

    New-AzureADUser -DisplayName $user.DisplayName `
                    -UserPrincipalName $user.UserPrincipalName `
                    -AccountEnabled $true `
                    -PasswordProfile @{ForceChangePasswordNextLogin = $true; Password = "P@ssw0rd123"} `
                    -MailNickname ($user.UserPrincipalName -split "@")[0] `
                    -UsageLocation $user.UsageLocation

    $userId = (Get-AzureADUser -ObjectId $user.UserPrincipalName).ObjectId
    $licenseSku = "yourtenant:ENTERPRISEPACK"

    Set-AzureADUserLicense -ObjectId $userId -AddLicenses @($licenseSku)
}
