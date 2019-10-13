# QSE-Start-Qlik-Services
# Starts Qlik sense services
#
#
# Glenn David
# 2019-09-01



Function Get-AdminStatus 
{ 
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 
} 

Write-Host "This script will Start qlik sense services running on this machine"



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

Get-Service "QlikSenseRepositoryDatabase" -ErrorAction SilentlyContinue -ErrorVariable processError
If(!$processError)
{

    Write-Host "Starting QlikSenseRepositoryDatabaseQlikSenseRepositoryDatabase"
    Start-Service -Name "QlikSenseRepositoryDatabase" 

}


Get-Service "QlikSenseRepositoryService" -ErrorAction SilentlyContinue -ErrorVariable processError
If(!$processError)
{

    Write-Host "Starting QlikSenseRepositoryService"
    Start-Service -Name "QlikSenseRepositoryService" 

}

Get-Service "QlikSenseServiceDispatcher" -ErrorAction SilentlyContinue -ErrorVariable processError
If(!$processError)
{

    Write-Host "Starting QlikSenseServiceDispatcher"
    Start-Service -Name "QlikSenseServiceDispatcher" 

}


Get-Service "QlikLoggingService" -ErrorAction SilentlyContinue -ErrorVariable processError
If(!$processError)
{

    Write-Host "Starting QlikLoggingService"
    Start-Service -Name "QlikLoggingService" 

}

Get-Service "QlikSenseProxyService" -ErrorAction SilentlyContinue -ErrorVariable processError
If(!$processError)
{

    Write-Host "Starting QlikSenseProxyService"
    Start-Service -Name "QlikSenseProxyService" 

}

Get-Service "QlikSenseEngineService" -ErrorAction SilentlyContinue -ErrorVariable processError
If(!$processError)
{

    Write-Host "Starting QlikSenseEngineService"
    Start-Service -Name "QlikSenseEngineService" 

}


Get-Service "QlikSenseSchedulerService" -ErrorAction SilentlyContinue -ErrorVariable processError
If(!$processError)
{

    Write-Host "Starting QlikSenseSchedulerService"
    Start-Service -Name "QlikSenseSchedulerService" 

}

Get-Service "QlikSensePrintingService" -ErrorAction SilentlyContinue -ErrorVariable processError
If(!$processError)
{

    Write-Host "Starting QlikSensePrintingService"
    Start-Service -Name "QlikSensePrintingService" 

}








Write-Host "Services have been started"