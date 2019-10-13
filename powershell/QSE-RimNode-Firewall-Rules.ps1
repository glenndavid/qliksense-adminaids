# QSE-CentralNode-Firewall-Rules
# Creates inbound and outbound firewall rules for a Rim node in multi-node Qlik Sense site 
#
#
# Glenn David
# 2019-09-01



Function Get-AdminStatus 
{ 
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 
} 

Write-Host "This script creates firewall rules for a QSE rim node"

#Run only with elevated priviledges
If (Get-AdminStatus -eq $true)
{
	write-Host "INFO: running script with Administrator rights"
}
else
{
	write-Host "ERROR: You need aministrator rights to run this script." -foregroundcolor "red"
	exit 1
}

Write-host "Removing existing Rim Node firewall rules."

Remove-NetFirewallRule -DisplayName "QlikSense Inbound"
Remove-NetFirewallRule -DisplayName "QlikSense Outbound"

Write-host "Creating Rim Node firewall rules."

New-NetFirewallRule -DisplayName "QlikSense Inbound" -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('80', '443', '4242', '4243', '4244', '4444','5050','5151','4747','4239','4949','4900','9028','4899')
New-NetFirewallRule -DisplayName "QlikSense Outbound" -Profile @('Domain', 'Private') -Direction Outbound -Action Allow -Protocol TCP -LocalPort @('80', '443','4242', '4243', '4244','4444','5151','5050','4949')

Write-host "Firewall rules created. Please refine rules if not all qlik services are installed on this rim node."