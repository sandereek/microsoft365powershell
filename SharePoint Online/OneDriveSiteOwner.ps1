<#
.SYNOPSIS
    Adds or Removes a user as secondary site owner from all OneDrives in an Office 365 Tenant
.DESCRIPTION
    In the scipt you can configure an Office 365 tenant, a user you want to add or remove and an exception to in-bulk add or remove OneDrive users
.PARAMETER <Parameter_Name>
    None
.INPUTS
    None
.OUTPUTS
    None
.NOTES
  Version:        0.9
  Author:         Sander Eek
  Creation Date:  11 march 2020
  Purpose/Change: Initial script development
  Last Update:    11 march 2020
  
.EXAMPLE
  .\OneDriveSiteOwner.ps1
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Load SharePoint CSOM Assemblies
$CSOMAssemblyDll1 = "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
$CSOMAssemblyDll2 = "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

If (Test-Path $CSOMAssemblyDll1 -PathType Leaf) {
    Add-Type -Path $CSOMAssemblyDll1
}
Else {
    Write-Host "File $CSOMAssemblyDll1 not found. Please install SharePoint CSOM Assemblies" -ForegroundColor Red
    If ($Debug) { Pause }
}

If (Test-Path $CSOMAssemblyDll2 -PathType Leaf) {
    Add-Type -Path $CSOMAssemblyDll2
}
Else {
    Write-Host "File $CSOMAssemblyDll2 not found. Please install SharePoint CSOM Assemblies" -ForegroundColor Red
    If ($Debug) { Pause }
}



#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Set parameter values
$Debug = $false
$TenantAdmin = "sander.eek@hcs-company.com"
$TenantAdminPassword = "S3c3t!"
$SPOAdminURL = "https://hcscompany-admin.sharepoint.com"
$MyOwnUrl = "sander_eek_hcs-company_com" # Upn where @ and . are replaced by _

#-----------------------------------------------------------[Functions]------------------------------------------------------------

#-----------------------------------------------------------[Execution]------------------------------------------------------------
$LogPath = $env:TEMP
$logdate = get-date -Uformat %Y-%m-%d
$logtime = get-date -format HH-mm-ss
$TranscriptLog = $LogPath + "\" + $LogDate + "_" + $LogTime + "_" + $MyInvocation.MyCommand.Name + ".log"
$SessionId = Get-Random -Minimum 1000000 -Maximum 9999999

Start-Transcript $TranscriptLog
write-host "`n`n`n$(get-date) Script Version:             " $ScriptVersion
write-host "$(get-date) Script Date:                " $ScriptDate
write-host "$(get-date) Session-ID:                 " $SessionId
write-host "$(get-date) Log Path:                   " $TranscriptLog 
If (!($Debug)) { $ComputerInfo = Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, CSUserName, CSDNSHostName, OsLocale }
write-host "$(get-date) Windows Product Name:       " $ComputerInfo.WindowsProductName
write-host "$(get-date) Windows Version:            " $ComputerInfo.WindowsVersion
write-host "$(get-date) Running under User:         " $ComputerInfo.CSUserName
write-host "$(get-date) Running on host:            " $ComputerInfo.CSDNSHostName
write-host "$(get-date) Operating System Locale:    " $ComputerInfo.OsLocale
write-host "`n"


# Prereq: SharePoint Online PowerShell
if (!(Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell)) {
    write-host "$(get-date) #CRITICAL: SharePoint Online PowerShell Module not installed!" -ForegroundColor Red
    If ($Debug) { Pause }
    Stop-Transcript
    exit 9 
}
Else {
    Import-Module Microsoft.Online.SharePoint.PowerShell
}

# Lets sign in to SharePoint
$PassWord = ConvertTo-SecureString -String $TenantAdminPassword -AsPlainText -Force
$SPOCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $TenantAdmin, $PassWord
Try {
    Write-Host "$(get-date) Connecting with SharePoint Online..."
    Connect-SPOService -Url $SPOAdminURL -Credential $SPOCredential
    write-host "$(get-date) Connected to SharePoint Online"
}
Catch {
    write-host "$(get-date) #FATAL Unable to connect with SharePoint Online. Check if SPO PS is installed and check credentials"
    write-host $_
    If ($Debug) { Pause }
    Stop-Transcript
    Exit 9
}

$OneDriveUrls = Get-SPOSite -IncludePersonalSite $true -Limit all -Filter "Url -like '-my.sharepoint.com/personal/'" | Select-Object -ExpandProperty Url

foreach ($OneDriveURL in $OneDriveUrls) {
    If (!($OneDriveURL -match $MyOwnUrl)) {
        Write-Host "Fixing SiteCollectionAdmin for " $OneDriveURL
        Set-SPOUser -Site $OneDriveUrl -LoginName $TenantAdmin -IsSiteCollectionAdmin $false 
    }
    Else {
        write-host $MyOwnUrl " is me: " $OneDriveURL " not removing myself " -BackgroundColor Green -ForegroundColor White
    }
}

Stop-Transcript
write-host "Transcript file stored in " $TranscriptLog