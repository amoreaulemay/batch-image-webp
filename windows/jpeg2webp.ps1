param ($f)

$init_location = Get-Location

# pragma FUNCTIONS
function CheckChocoModule {
    param (
        [Parameter(Mandatory=$true)][string]$module
    )
    
    return choco list -lo | Where-object { $_.ToLower().StartsWith($module.ToLower()) }
}
Function Get-Folder($initialDirectory="")

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

# pragma MAIN PROGRAM
# Copyright (c) 2021 Alexandre Moreau-Lemay
# Author : Alexandre Moreau-Lemay
# License : AGPL-3.0 License

Clear-Host
Write-Host "Batch WebP Converter v1.1.4-beta - Windows (PowerShell)"
Write-Host "Copyright (c) Alexandre Moreau-Lemay 2021."
Write-Host "Released under the AGPLv3 License.`n`n`n"

# pragma DEPENDENCIES
# pragma 1. Making sure chocolatey is installed.
Write-Host "1. Making sure Chocolatey is installed."
Start-Sleep -s 1
if(-not(Get-Command -Name choco.exe -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Installing now."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
Write-Host "[" -NoNewline; Write-Host "DONE" -ForegroundColor Green -NoNewline; Write-Host "]"

# pragma 2. Making sure imagemagick is installed.
Write-Host "2. Making sure ImageMagick is installed."

if($null -eq (CheckChocoModule -module "imagemagick")){
    Write-Host "ImageMagick is not installed. Installing now."
    choco install imagemagick
}
Write-Host "[" -NoNewline; Write-Host "DONE" -ForegroundColor Green -NoNewline; Write-Host "]"

# pragma FILE MANIPULATION
# pragma 3. Getting the images path
if($f -eq "" -Or $null -eq $f){
    $f=Get-Folder
    if($f -eq "" -Or $null -eq $f){
        Write-Host "Error: The path is not valid!`n`n" -ForegroundColor Red
        exit
    }
}

if(-not(Test-Path -Path $f)) {
    Write-Host "Error: The path '$f' is not valid!`n`n" -ForegroundColor Red
    exit
}

# pragma 4. Getting the album infos
Do {
    $album_name = Read-Host -Prompt "Enter the name of the album"
} Until ($album_name)
Do {
    $album_desc = Read-Host -Prompt "Enter a description for the album"
} Until ($album_desc)
Do {
    $album_year = Read-Host -Prompt "Enter the year of the album"
} Until ($album_year)
Do {
    $album_city = Read-Host -Prompt "Enter the city of the album"
} Until ($album_city)
Do {
    $album_coun = Read-Host -Prompt "Enter the country of the album"
} Until ($album_coun)

# pragma 5. Creating the temporary directory
Set-Location -Path $f
$temp_folder = New-Guid
New-Item -Name $temp_folder -ItemType "directory" | Out-Null
New-Item -Name "jpeg" -ItemType "directory" | Out-Null
New-Item -Name "webp" -ItemType "directory" | Out-Null
New-Item -Name "originals" -ItemType "directory" | Out-Null

# pragma 6. Moving jpgs to the temporary directory
Get-Item *.jpg | Move-Item -Destination $temp_folder | Out-Null
Get-Item *.jpeg | Move-Item -Destination $temp_folder | Out-Null

# pragma 7. Changing directory to the temporary one
Set-Location -Path $temp_folder

# pragma 8. Renaming, resizing and converting the files

$convert = "C:\ProgramData\chocolatey\bin\convert.exe"

Write-Host "Converting, this might take a few minutes..."

foreach ($file in Get-ChildItem) {
    # $base_name = ($file | Select-Object BaseName).BaseName
    $extension = ($file | Select-Object Extension).Extension
    
    $guid_name = [System.guid]::NewGuid().toString()
    $new_file = $guid_name + $extension

    Move-Item -Path $file -Destination $new_file | Out-Null
    & $convert ($new_file,'-resize','2000x2000','-interlace','Plane','-gaussian-blur','0.05','-quality','80','-density','72',"$guid_name-2000$extension")
    & $convert ($new_file,'-resize','1500x1500','-interlace','Plane','-gaussian-blur','0.05','-quality','80','-density','72',"$guid_name-1500$extension")
    & $convert ($new_file,'-resize','1000x1000','-interlace','Plane','-gaussian-blur','0.05','-quality','80','-density','72',"$guid_name-1000$extension")
    & $convert ($new_file,'-resize','500x500','-interlace','Plane','-gaussian-blur','0.05','-quality','80','-density','72',"$guid_name-500$extension")
    & $convert ($new_file,'-resize','2000x2000','-interlace','Plane','-gaussian-blur','0.05','-quality','80','-density','72','-define','webp:lossless=true',"$guid_name-2000.webp")
    & $convert ($new_file,'-resize','1500x1500','-interlace','Plane','-gaussian-blur','0.05','-quality','80','-density','72','-define','webp:lossless=true',"$guid_name-1500.webp")
    & $convert ($new_file,'-resize','1000x1000','-interlace','Plane','-gaussian-blur','0.05','-quality','80','-density','72','-define','webp:lossless=true',"$guid_name-1000.webp")
    & $convert ($new_file,'-resize','500x500','-interlace','Plane','-gaussian-blur','0.05','-quality','80','-density','72','-define','webp:lossless=true',"$guid_name-500.webp")
    Move-Item -Path $new_file -Destination ../originals/
}

# pragma 9. Moving the files to their final destinations
Get-Item *.jpg | Move-Item -Destination ../jpeg/ | Out-Null
Get-Item *.jpeg | Move-Item -Destination ../jpeg/ | Out-Null
Get-Item *.webp | Move-Item -Destination ../webp/ | Out-Null

# pragma 10. Deleting the temp directory
Set-Location -Path ../
Remove-Item $temp_folder -Recurse

# pragma 11. Script Ending
Clear-Host
Write-Host "Script Executed!" -ForegroundColor Green

## RETURNING TO ORIGINAL LOCATION
Set-Location -Path $init_location
