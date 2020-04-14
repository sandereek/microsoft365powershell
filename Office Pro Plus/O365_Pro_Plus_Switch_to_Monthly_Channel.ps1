


# Check if key CDNBaseUrl
# exists under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Configuration\

# If Yes, then the computer is already configured for Monthly updates

# If No,
# Under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Configuration
# add CDNBaseUrl as REG_SZ with value: http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60

$registryPath = 
$registryName = 
$registryValue =
$registryPropertyType = 


New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Name "CDNBaseUrl" `
-Value "http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60"  -PropertyType "String"  -Force

# Delete the following values:
# Under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Configuration
# Delete UpdateUrl and UpdateToVersion
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Name "UpdateUrl" -Confirm
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Name "UpdateToVersion" -Confirm

# Under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Updates
# Delete UpdateToVersion
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Updates" -Name "UpdateToVersion" -Confirm

# Delete HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Office\16.0\Common\OfficeUpdate
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\Common" -Name "OfficeUpdate" -Confirm