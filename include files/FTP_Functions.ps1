<#
.SYNOPSIS
    Generic Include File for various FTP functions
.DESCRIPTION
    This Scripts defines functions that can be used to work with files on FTP sites
.PARAMETERS 
    None
.INPUTS
    None
.OUTPUTS
    None
.NOTES
  Version:        0.7
  Author:         Sander Eek
  Creation Date:  14 april 2020
  Purpose/Change: Initial script development
  Last Update:    14 april 2020
  
.EXAMPLE
  .\O365_Pro_Plus_Switch_to_Monthly_Channel.ps1
#>


# Upload Single File
$FTPServer = "ftp://example.com/"
$FTPUsername = "username"
$FTPPassword = "password" 
$LocalDirectory = "C:\temp\" 
$FileToUpload = "example.txt"

#-----------------------------------------------------------[Functions]------------------------------------------------------------


#Connect to the FTP Server
$ftp = [System.Net.FtpWebRequest]::create("$FTPServer/$FileToUpload")
$ftp.Credentials =  New-Object System.Net.NetworkCredential($FTPUsername,$FTPPassword)

#Upload file to FTP Server
$ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile

#Verify the file was uploaded
$ftp.GetResponse()

# Delete Single File
$FTPServer = "ftp://example.com/"
$FTPUsername = "username"
$FTPPassword = "password" 
$LocalDirectory = "C:\temp\" 
$FileToDelete = "example.txt"

#Connect to the FTP Server
$ftp = [System.Net.FtpWebRequest]::create("$FTPServer/$FileToDelete")
$ftp.Credentials =  New-Object System.Net.NetworkCredential($FTPUsername,$FTPPassword)

#Delete file on FTP Server
$ftp.Method = [System.Net.WebRequestMethods+Ftp]::DeleteFile

#Verify the file was uploaded
$ftp.GetResponse()

# Upload every file in a directory
#Unique Variables
$FTPServer = "ftp://example.com/"
$FTPUsername = "username"
$FTPPassword = "password" 
$LocalDirectory = "C:\temp\" 

#Loop through every file
foreach($FileToUpload in (dir $LocalDirectory "*")){ 

    #Connect to the FTP Server
    $ftp = [System.Net.FtpWebRequest]::create("$FTPServer/$FileToUpload")
    $ftp.Credentials =  New-Object System.Net.NetworkCredential($FTPUsername,$FTPPassword)

    #Upload file to FTP Server
    $ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile

    #Verify the file was uploaded
    $ftp.GetResponse()
}

# View files on FTP Server

#Unique Variables
$FTPServer = "ftp://homaasftp.westus.cloudapp.azure.com"
$FTPUsername = "test"
$FTPPassword = "test" 

#Connection String
$credentials = new-object System.Net.NetworkCredential($FTPUsername, $FTPPassword)

#function to view the files in the FTP Server
function View-Files-in-FTP-Server ($url,$credentials) {
    $request = [Net.WebRequest]::Create($url)
    $request.Method = [System.Net.WebRequestMethods+FTP]::ListDirectory
    if ($credentials) { $request.Credentials = $credentials }
    $response = $request.GetResponse()
    $reader = New-Object IO.StreamReader $response.GetResponseStream() 
    $reader.ReadToEnd()
    $reader.Close()
    $response.Close()
}

#Use the root directory of the FTP Server
$ListFiles = View-Files-in-FTP-Server -url $FTPServer -credentials $credentials
$files = ($ListFiles -split "`r`n")

Write-Host 'The Files on the FTP Server : '
Write-Host `r
$files 