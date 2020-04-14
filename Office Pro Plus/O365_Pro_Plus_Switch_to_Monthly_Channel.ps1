<#
.SYNOPSIS
    Configures the Registry for Monthly Office 365 Pro Plus Updates
.DESCRIPTION
    This Scripts configures the registry to configure Office 365 Pro Plus to use Monthly updates
.PARAMETERS 
    None
.INPUTS
    None
.OUTPUTS
    None
.NOTES
  Version:        1.0
  Author:         Sander Eek
  Creation Date:  14 april 2020
  Purpose/Change: Initial script development (converted from CMD file)
  Last Update:    14 april 2020
  
.EXAMPLE
  .\O365_Pro_Plus_Switch_to_Monthly_Channel.ps1
# >

$ErrorActionPreference = "SilentlyContinue"

# Check if key CDNBaseUrl. Under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Configuration
# add CDNBaseUrl as REG_SZ with value: http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Name "CDNBaseUrl" `
-Value "http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60"  -PropertyType "String"  -Force

# Under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Configuration
# Delete UpdateUrl and UpdateToVersion
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Name "UpdateUrl" -Confirm
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Name "UpdateToVersion" -Confirm

# Under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Updates
# Delete UpdateToVersion
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Updates" -Name "UpdateToVersion" -Confirm

# Under HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Office\16.0\Common
# Delete OfficeUpdate
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\Common" -Name "OfficeUpdate" -Confirm

$ErrorActionPreference = "Continue"