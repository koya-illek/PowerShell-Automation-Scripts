<#
.SYNOPSIS
Updates an Azure Virtual Desktop (AVD) host pool with custom session limits and idle timeout settings.

.DESCRIPTION
This script modifies an existing AVD host pool to enforce:
- A maximum number of concurrent sessions per user
- RDP properties for idle session timeout, audio redirection, and printer access control

.PARAMETER ResourceGroupName
The resource group where the host pool is located.

.PARAMETER HostPoolName
The name of the host pool to be updated.

.PARAMETER MaxSessionLimit
Maximum number of sessions allowed per user (default: 2).

.PARAMETER IdleTimeoutSeconds
Time in seconds before idle session is disconnected (default: 1800 = 30 min).

.NOTES
Author: Koya Illek  
Requires: Az.DesktopVirtualization module  
Run with Contributor rights on the host pool resource  
#>

param (
    [string]$ResourceGroupName = "YourResourceGroup",
    [string]$HostPoolName = "YourHostPool",
    [int]$MaxSessionLimit = 2,
    [int]$IdleTimeoutSeconds = 1800
)

Connect-AzAccount

# Build RDP property string
$rdpSettings = @(
    "audiocapturemode:i:1"         # Enable microphone redirection
    "redirectprinters:i:0"         # Disable local printer redirection
    "idleTimeout:i:$IdleTimeoutSeconds" # Auto-disconnect after idle timeout
) -join ";"

# Apply settings
Update-AzWvdHostPool -ResourceGroupName $ResourceGroupName `
    -Name $HostPoolName `
    -MaxSessionLimit $MaxSessionLimit `
    -CustomRdpProperty $rdpSettings

Write-Host "AVD host pool '$HostPoolName' updated successfully in resource group '$ResourceGroupName'."
