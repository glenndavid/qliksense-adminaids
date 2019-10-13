# QSE-Disable-DotNet-Generate-Publisher-Evidence
# Turn off generatePublisherEvindece flag in .net config as per
# Qlik article https://support.qlik.com/articles/Basic/An-error-occurred-Failed-to-load-connection-error-message-in-Qlik-Sense-Server-Has-No-Internet?articleId=An-error-occurred-Failed-to-load-connection-error-message-in-Qlik-Sense-Server-Has-No-Internet
#
# Glenn David
# 2019-09-01


# Declare the Machine.Config files from .net Framework 4.0

$strMachineConfigFiles = @("C:\Windows\Microsoft.NET\Framework64\v4.0.30319\config\machine.config")

# Declare the Machine.Config files from .net Framework 4.0
#$strMachineConfigFiles = @("%SYSTEMROOT%\Microsoft.NET\Framework\v2.0.50727\CONFIG\machine.config", "%SYSTEMROOT%\Microsoft.NET\Framework64\v2.0.50727\CONFIG\machine.config")

Function Get-AdminStatus 
{ 
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 
} 



Write-Host "This script sets generatePublisherEvidence enabled=false on host machine"


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

#Proceed for each machine.file
foreach ($strMachineConfigFile in $strMachineConfigFiles)
{
	#Expand environment variable
	$strMachineConfigFile = [System.Environment]::ExpandEnvironmentVariables($strMachineConfigFile)
	
	#Check if file exists; if not EXIT
	if ((Test-Path $strMachineConfigFile) -eq $true)
		{
			write-host "-File ($strMachineConfigFile) exists."
		}
		else
		{
			write-host "ERROR: -File ($strMachineConfigFile) not exists." -foregroundcolor "red"
			exit 1
		}
		
	#Create Backup
	write-Host "--Create BackupFile from $strMachineConfigFile "
	Copy-Item $strMachineConfigFile ($strMachineConfigFile + ".BACKUP")
	
	#Load Content
	write-Host "--Read XML file..."
	[xml]$xml = Get-Content $strMachineConfigFile
	
	
  	If (!$xml.DocumentElement.SelectSingleNode("runtime")) 
		{ 
    		$runtime = $xml.CreateElement("runtime")
    		$xml.DocumentElement.AppendChild($runtime) | Out-Null
			write-Host "--Runtime element created"
  		}
		
  	If (!$xml.DocumentElement.SelectSingleNode("runtime/generatePublisherEvidence"))
		{
    		$gpe = $xml.CreateElement("generatePublisherEvidence")
    		$xml.DocumentElement.SelectSingleNode("runtime").AppendChild($gpe)  | Out-Null
			write-Host "--generatePublisherEvidence element created"
  		}
		
  	$xml.DocumentElement.SelectSingleNode("runtime/generatePublisherEvidence").SetAttribute("enabled","false")  | Out-Null
	write-Host "--generatePublisherEvidence attribut configured to false"
	
  	$xml.Save($strMachineConfigFile)
	write-Host "--Machine.Config saved."
	
}



