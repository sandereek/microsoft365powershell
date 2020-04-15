<#
.SYNOPSIS
    Generic Include File for various FTP functions
.DESCRIPTION
    This Scripts defines functions that can be used to work with files on FTP sites
.PARAMETERS 
    $FTPServer = "ftp://homaasfromhome.westus2.cloudapp.azure.com/"
    $FTPUsername = "homaasftp"
    $FTPPassword = "S3cr3t!" 
    $FTPLocalFilePath = "C:\temp\"
    $FTPLocalFileName = "file.zip"
.INPUTS
    File to Upload to FTP Server
.OUTPUTS
    File to Download to FTP Server
.NOTES
  Version:        0.8
  Author:         Sander Eek
  Creation Date:  14 april 2020
  Purpose/Change: Initial script development
  Last Update:    14 april 2020
  
.EXAMPLE
  .\FTP_Functions.ps1
  To Download: FTPDownload -FTPServer $FTPServer -FTPUsername $FTPUsername -FTPPassword $FTPPassword -FTPLocalFilePath $FTPLocalFilePath -FTPLocalFileName $FTPLocalFileName
  To Upload: FTPUpload -FTPServer $FTPServer -FTPUsername $FTPUsername -FTPPassword $FTPPassword -FTPLocalFilePath $FTPLocalFilePath -FTPLocalFileName $FTPLocalFileName

#>

#-----------------------------------------------------------[Functions]------------------------------------------------------------
Function FTPDownload() {
    param
    (
        [Parameter(Mandatory = $true)] [string] $FTPServer,
        [Parameter(Mandatory = $true)] [string] $FTPUsername,
        [Parameter(Mandatory = $true)] [string] $FTPPassword,
        [Parameter(Mandatory = $true)] [string] $FTPLocalFilePath,
        [Parameter(Mandatory = $true)] [string] $FTPLocalFileName
    )
<<<<<<< HEAD
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
=======
    write-host "$(get-date) FTPServer: " $FTPServer
    write-host "$(get-date) FTPUser: " $FTPUsername
    write-host "$(get-date) FTPUserPassword: " $FTPPassword
    write-host "$(get-date) FTPLocalFilePath: " $FTPLocalFilePath
    write-host "$(get-date) FTPLocalFileName: "$FTPLocalFileName
    write-host "$(get-date) FTPLocalFileName: "$FTPLocalFile

    $webclient = New-Object System.Net.WebClient
    $webclient.Credentials = New-Object System.Net.NetworkCredential($FTPUsername,$FTPPassword)
    $uri = New-Object System.Uri($FTPServer + $FTPLocalFileName)
    $webclient.DownloadFile($uri,$FTPLocalFilePath + $FTPLocalFileName)
>>>>>>> 81b87f39dd58a54f2e6775f68632de0a45391048
}

Function FTPUpload() {
    param
    (
        [Parameter(Mandatory = $true)] [string] $FTPServer,
        [Parameter(Mandatory = $true)] [string] $FTPUsername,
        [Parameter(Mandatory = $true)] [string] $FTPPassword,
<<<<<<< HEAD
        [Parameter(Mandatory = $true)] [string] $FTPFileToUploadPath,
        [Parameter(Mandatory = $true)] [string] $FTPFileToUploadName
    )

    $FTPFileToUpload = $FTPFileToUploadPath + $FTPFileToUploadName
    $FTPRemoteFile = $FTPServer + $FTPFileToUploadName
=======
        [Parameter(Mandatory = $true)] [string] $FTPLocalFilePath,
        [Parameter(Mandatory = $true)] [string] $FTPLocalFileName
    )

    $FTPFileToUpload = $FTPLocalFilePath + $FTPLocalFileName
    $FTPRemoteFile = $FTPServer + $FTPLocalFileName
>>>>>>> 81b87f39dd58a54f2e6775f68632de0a45391048
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
<<<<<<< HEAD

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
=======

}
>>>>>>> 81b87f39dd58a54f2e6775f68632de0a45391048
