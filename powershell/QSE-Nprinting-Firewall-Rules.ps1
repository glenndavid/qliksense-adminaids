# QSE-NPrinting-Firewall-Rules
# Creates inbound and outbound firewall rules for a Rim node in multi-node Qlik Sense site 
#
#
# Glenn David
# 2019-09-01



Function Get-AdminStatus 
{ 
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 
} 

Write-Host "This script creates firewall rules for NPrinting"

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

Write-host "Removing existing NPrinting firewall rules."

Remove-NetFirewallRule -DisplayName "NPrinting Inbound"
Remove-NetFirewallRule -DisplayName "NPrinting Outbound"

Write-host "Creating NPrinting firewall rules."

New-NetFirewallRule -DisplayName "NPrinting Inbound" -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('4993','4994','4997','5672')
New-NetFirewallRule -DisplayName "NPrinting Outbound" -Profile @('Domain', 'Private') -Direction Outbound -Action Allow -Protocol TCP -LocalPort @('4242','4243','4747','4997','5672')

Write-host "Firewall rules created. Please refine rules if not all nprinting services are installed on this rim node."