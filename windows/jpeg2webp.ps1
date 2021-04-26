param ($f)

$init_location = Get-Location
$VERSION = "v1.1.6"

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
Function Get-File($initialDirectory=[Environment]::GetFolderPath('Desktop'))
{
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = $initialDirectory }
    $null = $FileBrowser.ShowDialog()
    return $FileBrowser.FileName
}

# pragma MAIN PROGRAM
# Copyright (c) 2021 Alexandre Moreau-Lemay
# Author : Alexandre Moreau-Lemay
# License : AGPL-3.0 License

Clear-Host
Write-Host "Batch WebP Converter $VERSION - Windows (PowerShell)"
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
    $album_year_temp = Read-Host -Prompt "Enter the year of the album"
    if($album_year_temp -match '^[0-9]+$') {
        $album_year = $album_year_temp
    }
    else {
        Write-Host "Please provide a numerical value!" -ForegroundColor Red
    }
} Until ($album_year)
Do {
    $album_city = Read-Host -Prompt "Enter the city of the album"
} Until ($album_city)
Do {
    $album_coun = Read-Host -Prompt "Enter the country of the album"
} Until ($album_coun)

# pragma 5. Changing directory
Set-Location -Path $f

# pragma 6. Album Cover Selection
Do {
    $auto_cover = Read-Host -Prompt "Do you wish to set an Album cover? If no, it will be auto generated. [y/n]"
    switch ($auto_cover.ToLower()) {
        "y" { 
            Do {
                $manual_cover = Get-File -initialDirectory $f
                if($manual_cover -eq "" -Or $null -eq $manual_cover){
                    Write-Host "Error: The path is not valid!`n`n" -ForegroundColor Red
                }
                else {
                    if(Test-Path -Path $manual_cover) {
                        $album_cover = Split-Path $manual_cover -Leaf
                        $manual_cover_valid = $true
                    }
                    else {
                        Write-Host "Error: The path is not valid!`n`n" -ForegroundColor Red
                    }
                }
            } Until ($manual_cover_valid)
        }
        "n" {
            $album_cover = (Get-Item * -Include *.jpg,*.jpeg | Get-Random).Name
        }
        Default {
            Write-Host "`nSorry, the answer is not valid. Please try again!`n" -ForegroundColor Red
        }
    }
} Until ($album_cover)

# pragma 7. Creating temp folder
$temp_folder = New-Guid
New-Item -Name $temp_folder -ItemType "directory" | Out-Null
New-Item -Name "jpeg" -ItemType "directory" | Out-Null
New-Item -Name "webp" -ItemType "directory" | Out-Null
New-Item -Name "originals" -ItemType "directory" | Out-Null

# pragma 8. Creating the album.json and populating the start
New-Item -Name "album.json" -ItemType "file" | Out-Null
(
    "{",
    "    `"name`":`"$album_name`",",
    "    `"description`":`"$album_desc`",",
    "    `"year`":$album_year,",
    "    `"city`":`"$album_city`",",
    "    `"country`":`"$album_coun`",",
    "    `"pictures`":["
) | Out-File -FilePath "album.json" -Append

# pragma 9. Moving jpgs to the temporary directory
Get-Item * -Include *.jpg,*.jpeg | Move-Item -Destination $temp_folder | Out-Null

# pragma 10. Changing directory to the temporary one
Set-Location -Path $temp_folder

# pragma 11. Renaming, resizing and converting the files

$convert = "C:\ProgramData\chocolatey\bin\convert.exe"

$number_of_file = (Get-Item * | Measure-Object).Count
$resulting_amount_of_file = $number_of_file * 8
$j = 0
$i = 1

Clear-Host

foreach ($file in Get-ChildItem) {
    Write-Progress -Activity "Converting, this might take a few minutes..." -PercentComplete ([math]::Round((($j / $resulting_amount_of_file) * 100)))
    $extension = ($file | Select-Object Extension).Extension
    
    $guid_name = [System.guid]::NewGuid().toString()
    if((Split-Path $file -Leaf) -eq $album_cover){
        $cover = $guid_name
    }
    $new_file = $guid_name + $extension

    if($i -lt $number_of_file){
        "        `"$guid_name`"," | Out-File -FilePath ../album.json -Append
    }
    else {
        "        `"$guid_name`"" | Out-File -FilePath ../album.json -Append
    }

    Move-Item -Path $file -Destination $new_file | Out-Null
    # JPEGs Resizing
    & $convert ($new_file,'-resize','2000x2000','-interlace','Plane','-gaussian-blur','0.05','-quality','80','-density','72',"$guid_name-2000$extension"); $j++
    & $convert ("$guid_name-2000$extension",'-resize','1500x1500','-interlace','Plane',"$guid_name-1500$extension"); $j++
    & $convert ("$guid_name-1500$extension",'-resize','1000x1000','-interlace','Plane',"$guid_name-1000$extension"); $j++
    & $convert ("$guid_name-1000$extension",'-resize','500x500','-interlace','Plane',"$guid_name-500$extension"); $j++

    # WebP Conversion
    & $convert ("$guid_name-2000$extension",'-define','webp:emulate-jpeg-size=true',"$guid_name-2000.webp"); $j++
    & $convert ("$guid_name-1500$extension",'-define','webp:emulate-jpeg-size=true',"$guid_name-1500.webp"); $j++
    & $convert ("$guid_name-1000$extension",'-define','webp:emulate-jpeg-size=true',"$guid_name-1000.webp"); $j++
    & $convert ("$guid_name-500$extension",'-define','webp:emulate-jpeg-size=true',"$guid_name-500.webp"); $j++
    Move-Item -Path $new_file -Destination ../originals/
    $i = $i + 1
}

# pragma 12. Finish the json file
(
    "    ],",
    "    `"cover`":`"$cover`",",
    "    `"sizes`":[",
    "        500,",
    "        1000,",
    "        1500,",
    "        2000",
    "    ]",
    "}"
) | Out-File -FilePath ../album.json -Append

# pragma 13. Moving the files to their final destinations
Get-Item * -Include *.jpg,*.jpeg | Move-Item -Destination ../jpeg/ | Out-Null
Get-Item *.webp | Move-Item -Destination ../webp/ | Out-Null

# pragma 14. Deleting the temp directory
Set-Location -Path ../
Remove-Item $temp_folder -Recurse

# pragma 15. Script Ending
Clear-Host
Write-Host "Script Executed!" -ForegroundColor Green

## RETURNING TO ORIGINAL LOCATION
Set-Location -Path $init_location
