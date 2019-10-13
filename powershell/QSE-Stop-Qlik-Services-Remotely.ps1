# QSE-Stop-Qlik-Services
# Stops Qlik sense services
#
#
# Glenn David
# 2019-09-01



Function Get-AdminStatus 
{ 
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 
} 

Write-Host "This script will stop qlik sense services running on this machine"



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

$Server = Read-Host -Prompt 'Input your server  name'

Invoke-Command -ComputerName $Server
{
    Get-Service "QlikSensePrintingService" -ErrorAction SilentlyContinue -ErrorVariable processError  
    If(!$processError)
    {

        Write-Host "Stopping QlikSensePrintingService"
        Stop-Service -Name "QlikSensePrintingService" -Force

    }

    Get-Service "QlikSenseSchedulerService" -ErrorAction SilentlyContinue -ErrorVariable processError
    If(!$processError)
    {

        Write-Host "Stopping QlikSenseSchedulerService"
        Stop-Service -Name "QlikSenseSchedulerService" -Force

    }

    Get-Service "QlikSenseEngineService" -ErrorAction SilentlyContinue -ErrorVariable processError
    If(!$processError)
    {

        Write-Host "Stopping QlikSenseEngineService"
        Stop-Service -Name "QlikSenseEngineService" -Force

    }

    Get-Service "QlikSenseProxyService" -ErrorAction SilentlyContinue -ErrorVariable processError
    If(!$processError)
    {

        Write-Host "Stopping QlikSenseProxyService"
        Stop-Service -Name "QlikSenseProxyService" -Force

    }

    Get-Service "QlikSenseServiceDispatcher" -ErrorAction SilentlyContinue -ErrorVariable processError
    If(!$processError)
    {

        Write-Host "Stopping QlikSenseServiceDispatcher"
        Stop-Service -Name "QlikSenseServiceDispatcher" -Force

    }

    Get-Service "QlikLoggingService" -ErrorAction SilentlyContinue -ErrorVariable processError
    If(!$processError)
    {

        Write-Host "Stopping QlikLoggingService"
        Stop-Service -Name "QlikLoggingService" -Force

    }

    Get-Service "QlikSenseRepositoryService" -ErrorAction SilentlyContinue -ErrorVariable processError
    If(!$processError)
    {

        Write-Host "Stopping QlikSenseRepositoryService"
        Stop-Service -Name "QlikSenseRepositoryService" -Force

    }

    Get-Service "QlikSenseRepositoryDatabase" -ErrorAction SilentlyContinue -ErrorVariable processError
    If(!$processError)
    {

        Write-Host "Stopping QlikSenseRepositoryDatabaseQlikSenseRepositoryDatabase"
        Stop-Service -Name "QlikSenseRepositoryDatabase" -Force

    }

}

Write-Host "Services have been stopped"