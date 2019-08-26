#requires -version 3
<#
.SYNOPSIS
    Starts an additional instance of the Teams Client, using an additional local Windows account which has Teams installed in its profile 
.DESCRIPTION
    To create the local Windows Acccount that can be used with this script, do the following:
    01) [Win] + [I]
    02) Accounts
    03) Ohter Users
    04) Add someone else to this PC
    05) I don't have this person's sign-in information
    06) Add a user without a Microsoft Account
    07) [CTRL] + [ALT] + [DEL]
    08) Switch User
    09) Login with the newly created local user (if you get an error message that the password is incorrect or the user does not exist, add "localhost\" before the username)
    10) Install the Teams Client. Login to Teams with any working Teams credential
    11) Logout this session and go back to your normal session. You can now run this script with the credentials of the earlier created account which will start an addional
        instance of the Teams Client 
.PARAMETER <Parameter_Name>
    None
.INPUTS
    None
.OUTPUTS
    Files listed in the used CSV are deleted on SharePoint
.NOTES
  Version:        1.0
  Author:         Sander Eek
  Creation Date:  27 august 2019
  Purpose/Change: Initial script development
  Last Update:    27 august 2019
  
.EXAMPLE
  .\run_extra_teams_instance.ps1
#>

#----------------------------------------------------------[Declarations]----------------------------------------------------------
$username = "your_account_here"
$securepassword = ConvertTo-SecureString "your_password_here" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $username, $securePassword

#-----------------------------------------------------------[Execution]------------------------------------------------------------

#run as admin 
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Start-Process "C:\Users\$($credential.UserName)\AppData\Local\Microsoft\Teams\Update.exe" '--processStart "Teams.exe"' -Credential $credential