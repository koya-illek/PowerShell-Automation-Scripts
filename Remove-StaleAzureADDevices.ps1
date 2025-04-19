<#
.SYNOPSIS
Removes Azure AD-joined devices inactive for over 90 days.

.DESCRIPTION
Scans Azure AD for devices that have not checked in within the past 90 days and removes them.
Helps reduce clutter and improve directory hygiene.

.PARAMETER DaysInactive
(Optional) Number of days since last logon (default: 90).

.NOTES
Author: Koya Illek
Requires: AzureAD module
Always review output before deletion in production
#>

Import-Module AzureAD
Connect-AzureAD

$cutoff = (Get-Date).AddDays(-90)

$staleDevices = Get-AzureADDevice | Where-Object {
    $_.ApproximateLastLogonTimeStamp -lt $cutoff
}

foreach ($device in $staleDevices) {
    Write-Output "Removing: $($device.DisplayName) - Last logon: $($device.ApproximateLastLogonTimeStamp)"
    Remove-AzureADDevice -ObjectId $device.ObjectId
}
