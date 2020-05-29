<#
.SYNOPSIS
  Moves a SharePoint Online Site
.DESCRIPTION
  Moves a SharePoint Online Site to another location while creating a backup by means of the Invoke-SPOSiteSwap Command
.PARAMETER 
    None
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Sander Eek
  Creation Date:  2020-05-29
  Purpose/Change: Initial script development
  
.EXAMPLE
  .\SwapSPOSite
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

# Load your PowerShell Online Module here

#----------------------------------------------------------[Declarations]----------------------------------------------------------
$SourceSite = "https://contoso.sharepoint.com/sites/intranet"
$DestinationSite = "https://contoso.sharepoint.com"
$ArchiveURL = "https://contoso.sharepoint.com/sites/intranet_backup"
$adminUPN="hcs-ms@contoso.nl"
$orgName="contoso"

#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Logon to SharePoint Online
#
$userCredential = Get-Credential -UserName $adminUPN -Message "Type the password."
Connect-SPOService -Url https://$orgName-admin.sharepoint.com -Credential $userCredential

# Move the Site to a new location and create a backup
#
Invoke-SPOSiteSwap -SourceUrl $SourceSite -TargetUrl $DestinationSite -ArchiveUrl $ArchiveURL # -Force
