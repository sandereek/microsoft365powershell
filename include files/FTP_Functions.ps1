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
}

Function FTPUpload() {
    param
    (
        [Parameter(Mandatory = $true)] [string] $FTPServer,
        [Parameter(Mandatory = $true)] [string] $FTPUsername,
        [Parameter(Mandatory = $true)] [string] $FTPPassword,
        [Parameter(Mandatory = $true)] [string] $FTPLocalFilePath,
        [Parameter(Mandatory = $true)] [string] $FTPLocalFileName
    )

    $FTPFileToUpload = $FTPLocalFilePath + $FTPLocalFileName
    $FTPRemoteFile = $FTPServer + $FTPLocalFileName
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
