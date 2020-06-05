<#
.SYNOPSIS
    Generic Include File for various functions
.DESCRIPTION
    This Scripts defines functions that are likely to be used in multiple PowerShell Scripts
.PARAMETERS 
    Not applicable
.INPUTS
    Not applicable
.OUTPUTS
    Not applicable
.NOTES
  Version:        0.8
  Author:         Sander Eek
  Creation Date:  05 june 2020
  Purpose/Change: Initial script development
  Last Update:    05 june 2020
  
.EXAMPLE
  . .\generic_functions.ps1
#>

#-----------------------------------------------------------[Functions]------------------------------------------------------------
Function DisplayPicture {
    <#
    .SYNOPSIS
        Displays a Picture

    .DESCRIPTION
        Displays a Picture using Windows Forms without Buttons

    .PARAMETER ImageFilePath
        The name of the file to display (test with .JPG)

    .EXAMPLE
        DisplayPicture -ImageFilePath c:\temp\image.jpg
    #>
    Param(  
        [parameter(Mandatory = $true)] [string] $ImageFilePath  
    )

    [void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")

    $ImageFilePath = (get-item $ImageFilePath)

    $Picture = [System.Drawing.Image]::Fromfile($ImageFilePath);

    [System.Windows.Forms.Application]::EnableVisualStyles();
    $form = new-object Windows.Forms.Form
    $form.Text = "HCS Company Microsoft Services"
    $form.Width = $Picture.Size.Width;
    $form.Height = $Picture.Size.Height;
    $pictureBox = new-object Windows.Forms.PictureBox
    $pictureBox.Width = $Picture.Size.Width;
    $pictureBox.Height = $Picture.Size.Height;
    $pictureBox.Image = $Picture;
    $form.controls.add($pictureBox)
    $form.Add_Shown( { $form.Activate() } )
    $form.ShowDialog()
    #$form.Show();
}