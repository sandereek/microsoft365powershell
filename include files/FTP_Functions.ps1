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

#-----------------------------------------------------------[Functions]------------------------------------------------------------
Function FTPDownload() {
    param
    (
        [Parameter(Mandatory = $true)] [string] $FTPServer,
        [Parameter(Mandatory = $true)] [string] $FTPUsername,
        [Parameter(Mandatory = $true)] [string] $FTPPassword,
        [Parameter(Mandatory = $true)] [string] $FTPDownloadDirectory,
        [Parameter(Mandatory = $true)] [string] $FTPFileToDownload
    )

    write-host "$(get-date) FTPServer: " $FTPServer
    write-host "$(get-date) FTPUser: " $FTPUsername
    write-host "$(get-date) FTPUserPassword: " $FTPPassword
    write-host "$(get-date) FTPDownloadDirectory: " $FTPDownloadDirectory
    write-host "$(get-date) FTPFileToDownload: "$FTPFileToDownload

    # Config
    $Username = "FTPUSER"
    $Password = "P@assw0rd"
    $LocalFile = "C:\Temp\file.zip"
    $RemoteFile = "ftp://thomasmaurer.ch/downloads/files/file.zip"
 
    # Create a FTPWebRequest
    $FTPRequest = [System.Net.FtpWebRequest]::Create($RemoteFile)
    $FTPRequest.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)
    $FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
    $FTPRequest.UseBinary = $true
    $FTPRequest.KeepAlive = $false
    # Send the ftp request
    $FTPResponse = $FTPRequest.GetResponse()
    # Get a download stream from the server response
    $ResponseStream = $FTPResponse.GetResponseStream()
    # Create the target file on the local system and the download buffer
    $LocalFileFile = New-Object IO.FileStream ($LocalFile, [IO.FileMode]::Create)
    [byte[]]$ReadBuffer = New-Object byte[] 1024
    # Loop through the download
    do {
        $ReadLength = $ResponseStream.Read($ReadBuffer, 0, 1024)
        $LocalFileFile.Write($ReadBuffer, 0, $ReadLength)
    }
    while ($ReadLength -ne 0)
}

$FTPServer = "ftp://homaasfromhome.westus2.cloudapp.azure.com"
$FTPUsername = "homaasftp"
$FTPPassword = "123Hom@@s!" 
$FTPDownloadDirectory = "C:\temp\" 
$FTPFileToDownload = "ff.txt"

FTPDownload -FTPServer $FTPServer -FTPUsername $FTPUsername -FTPPassword $FTPPassword -FTPDownloadDirectory $FTPDownloadDirectory -FTPFileToDownload $FTPFileToDownload