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
    $FTPLocalFile = $FTPDownloadDirectory + $FTPFileToDownload

    write-host "$(get-date) FTPServer: " $FTPServer
    write-host "$(get-date) FTPUser: " $FTPUsername
    write-host "$(get-date) FTPUserPassword: " $FTPPassword
    write-host "$(get-date) FTPDownloadDirectory: " $FTPDownloadDirectory
    write-host "$(get-date) FTPFileToDownload: "$FTPFileToDownload
    write-host "$(get-date) FTPFileToDownload: "$FTPLocalFile

    # Create a FTPWebRequest
    $FTPRequest = [System.Net.FtpWebRequest]::Create($FTPServer + $FTPFileToDownload)
    $FTPRequest.Credentials = New-Object System.Net.NetworkCredential($FTPUsername, $FTPPassword)
    $FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
    $FTPRequest.UseBinary = $true
    $FTPRequest.KeepAlive = $false
    # Send the ftp request
    $FTPResponse = $FTPRequest.GetResponse()
    # Get a download stream from the server response
    $ResponseStream = $FTPResponse.GetResponseStream()
    # Create the target file on the local system and the download buffer
    $FTPLocalFileFile = New-Object IO.FileStream ($FTPLocalFile, [IO.FileMode]::Create)
    [byte[]]$ReadBuffer = New-Object byte[] 1024 
    # Loop through the download
    do {
        $ReadLength = $ResponseStream.Read($ReadBuffer, 0, 1024)
        $FTPLocalFileFile.Write($ReadBuffer, 0, $ReadLength)
    }
    while ($ReadLength -ne 0)
}

Function FTPUpload() {
    param
    (
        [Parameter(Mandatory = $true)] [string] $FTPServer,
        [Parameter(Mandatory = $true)] [string] $FTPUsername,
        [Parameter(Mandatory = $true)] [string] $FTPPassword,
        [Parameter(Mandatory = $true)] [string] $FTPFileToUploadPath,
        [Parameter(Mandatory = $true)] [string] $FTPFileToUploadName
    )

    $FTPFileToUpload = $FTPFileToUploadPath + $FTPFileToUploadName
    $FTPRemoteFile = $FTPServer + $FTPFileToUploadName
    write-host "$(get-date) FTPServer: " $FTPServer
    write-host "$(get-date) FTPUser: " $FTPUsername
    write-host "$(get-date) FTPUserPassword: " $FTPPassword
    write-host "$(get-date) FTPFileToUpload: " $FTPFileToUpload
    write-host "$(get-date) FTPRemoteFile" $FTPRemoteFile
  
    # Create FTP Rquest Object
    $FTPRequest = [System.Net.FtpWebRequest]::Create("$FTPRemoteFile")
    $FTPRequest = [System.Net.FtpWebRequest]$FTPRequest
    $FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
    $FTPRequest.Credentials = new-object System.Net.NetworkCredential($FTPUsername, $FTPPassword)
    $FTPRequest.UseBinary = $true
    $FTPRequest.UsePassive = $true
    # Read the File for Upload
    $FileContent = gc -en byte $FTPFileToUpload
    $FTPRequest.ContentLength = $FileContent.Length
    # Get Stream Request by bytes
    $Run = $FTPRequest.GetRequestStream()
    $Run.Write($FileContent, 0, $FileContent.Length)
    # Cleanup
    $Run.Close()
    $Run.Dispose()

}


#-----------------------------------------------------------[Test Code]------------------------------------------------------------

$FTPServer = "ftp://homaasfromhome.westus2.cloudapp.azure.com/"
$FTPUsername = "homaasftp"
$FTPPassword = "123Hom@@s!" 
$FTPFileToUpLoadPath = "C:\temp\"
$FTPFileToUploadName = "lucy2015.txt"


# FTPDownload -FTPServer $FTPServer -FTPUsername $FTPUsername -FTPPassword $FTPPassword `
# -FTPDownloadDirectory $FTPDownloadDirectory -FTPFileToDownload $FTPFileToDownload

FTPUpload -FTPServer $FTPServer -FTPUsername $FTPUsername -FTPPassword $FTPPassword `
-FTPFileToUploadPath $FTPFileToUploadPath -FTPFileToUploadName $FTPFileToUploadName