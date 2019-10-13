# QSE-Add-Windows-Defender-Exceptions
# Adds QLik exculstions to Windows Defender
#
#
# Glenn David
# 2019-09-01



Function Get-AdminStatus 
{ 
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 
} 

Write-Host "This script will add Qlik Sense folder, file and process exclusions to Windows Defender"
Write-Host "Assumes default folders are used."



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

#Get the Shared persistence apps path from the user
Do 
{
    $SPCappPath = Read-Host -Prompt 'Input your Shared repository apps filder path'
} Until(Test-Path $SPCappPath)

Write-Host "Exclude Shared Persistence App folder"
Add-MpPreference -ExclusionPath "$($SPCappPath)"

Write-Host "Exclude C:\ProgramData\Qlik"
Add-MpPreference -ExclusionPath "$($env:programdata)\Qlik\"

Write-Host "Exclude all executables under %ProgramFiles%\Qlik\Sense"
$qlikFiles = Get-ChildItem -Path "$($env:programfiles)\Qlik\Sense" -Name -Recurse -Force -Include *.exe

foreach($file in $qlikFiles)
{   Write-Host "  >> adding $($env:programfiles)\Qlik\Sense$($file)"
    Add-MpPreference -ExclusionPath "$($env:programfiles)\Qlik\Sense$($file)"
}


Write-Host "Exclude QVD files"
Add-MpPreference -ExclusionExtension “QVD”


Write-Host "Windows defender exclusions added."