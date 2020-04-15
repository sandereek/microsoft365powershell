<#
.SYNOPSIS
    Generic Include File for various FTP functions
.DESCRIPTION
    This Scripts defines functions that can be used to work with files on FTP sites
.PARAMETERS 
    $FTPServer = "ftp://homaasfromhome.westus2.cloudapp.azure.com/"
    $FTPUsername = "homaasftp"
    $FTPPassword = "123Hom@@s!" 
    $FTPLocalFilePath = "C:\temp\"
    $FTPLocalFileName = "ff2.txt"
.INPUTS
    File to Upload to FTP Server
.OUTPUTS
    File to Download to FTP Server
.NOTES
  Version:        0.8
  Author:         Sander Eek
  Creation Date:  14 april 2020
  Purpose/Change: Initial script development
  Last Update:    15 april 2020
  
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
    # write-host "$(get-date) FTPUserPassword: " $FTPPassword
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

    write-host "$(get-date) FTPServer: " $FTPServer
    write-host "$(get-date) FTPUser: " $FTPUsername
    # write-host "$(get-date) FTPUserPassword: " $FTPPassword
    write-host "$(get-date) FTPLocalFilePath: " $FTPLocalFilePath
    write-host "$(get-date) FTPLocalFileName: " $FTPLocalFileName
  
    $webclient = New-Object System.Net.WebClient
    $webclient.Credentials = New-Object System.Net.NetworkCredential($FTPUsername,$FTPPassword)
    $uri = New-Object System.Uri($FTPServer + $FTPLocalFileName)
    $webclient.UploadFile($uri,$FTPLocalFilePath + "\" + $FTPLocalFileName)

}