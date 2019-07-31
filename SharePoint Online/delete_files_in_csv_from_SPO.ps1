#requires -version 5.1
<#
.SYNOPSIS
    Reads a simple one column CSV file and then deletes the mentioned files on SharePoint
.DESCRIPTION
    This script Reads a simple one column CSV file and then deletes the mentioned files on SharePoint. In the script the SharePoint Site URL is configured and the files base url
.PARAMETER <Parameter_Name>
    None
.INPUTS
    None
.OUTPUTS
    Files listed in the used CSV are deleted on SharePoint
.NOTES
  Version:        1.0
  Author:         Sander Eek
  Creation Date:  31 july 2019
  Purpose/Change: Initial script development
  Last Update:    31 juli 2019
  
.EXAMPLE
  .\delete_files_in_csv_from_SPO.ps1
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Set parameter values
$SiteURL = "https://Contoso.sharepoint.com/sites/MSOperationsManagement/"
$FileRelativeURLPath = "/sites/HCS-MSOperationsManagement/Gedeelde%20%20documenten/Contoso%20International/Homaas%20-%20OneDrive%20Migration/OpCo/ch2/homaaslog/"

#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function Remove-SPOFile() {
    param
    (
       [Parameter(Mandatory = $true)] [string] $FileRelativeURL
    )
    Try {
 
        #Get the file to delete
        $File = $Ctx.Web.GetFileByServerRelativeUrl($FileRelativeURL) 
        $Ctx.Load($File) 
        $Ctx.ExecuteQuery() 
                 
        #Delete the file
        $File.DeleteObject()
        $Ctx.ExecuteQuery()
 
        write-host -f Green "File has been deleted successfully!"
    }
    Catch {
        write-host -f Red "Error deleting file !" $_.Exception.Message
    }
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

#Get Credentials to connect
$Cred = Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
  
#Setup the context
$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = $Credentials

#Pull in the CSV
$filelist = Import-Csv -Path "C:\temp\deletethis.csv"
foreach ($file in $filelist) {
    $FileRelativeURL = $FileRelativeURLPath + $file.file
    Write-host "Processing $FileRelativeURL"
    #Call the function to remove the actual file
    Remove-SPOFile -FileRelativeURL $FileRelativeURL
}