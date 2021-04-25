# Web Images - Album Creator
Batch converts images to webp and resize them for responsive web.

The script renames all images with random UUID, resize the images (with longest border) to 500, 1000, 1500 and 2000, then convert them to webp. Then it moves the original in a folder, the minified jpegs in another folder, and the webp in another folder. Finally it creates a file "album.json" with all the album's info for rapid web deployment.

## Install
### MacOS
Download the script in the MacOS directory. The script will install its required dependencies on the initial run. **Note :** This app requires sudo access to install its dependencies. If you want to run it as a non-admin user, you must first ask the sys-admin to install the required dependencies. See below for which dependencies this app uses.

#### Alternative Install - MacOS (from terminal)
```bash
curl https://raw.githubusercontent.com/amoreaulemay/batch-image-webp/main/macos/jpeg2webp --output jpeg2webp
chmod u+x jpeg2webp
```

### Linux (Debian-like)
Download the script in the Linux directory. The script will install its required dependencies on the initial run. **Note :** This app requires sudo access to install its dependencies. If you want to run it as a non-admin user, you must first ask the sys-admin to install the required dependencies. See below for which dependencies this app uses.

#### Alternative Install - Linux (from terminal)
```bash
curl https://raw.githubusercontent.com/amoreaulemay/batch-image-webp/main/linux/jpeg2webp --output jpeg2webp
chmod u+x jpeg2webp
```

### Windows (PowerShell)
Download the script in the Windows directory. The script will install its required dependencies on the initial run. **Note :** This script is unsigned. This is due to the fact that a public authority signature would cost about 200$ a year to get. You therefore have to options to run the script.
1. [Set the execution policy to unrestricted](#method-1-execute-the-script-with-unrestricted-execution-policy); or
2. [Self sign the script](#method-2-self-sign-the-script).

#### Alternative Install - Windows (from PowerShell)
To download the latest script version from the PowerShell terminal, run this command:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/amoreaulemay/batch-image-webp/main/windows/jpeg2webp.ps1" -Outfile "jpeg2webp.ps1"
```

##### Word of caution (PowerShell)
***In either cases, I would highly recommend you to review the code yourself and make sure you know what you are doing.*** While this script was tested for development purposes on a Windows machine, it has not been tested in a production environment. *You understand that it is provided without any guaranties or liabilities. You understand that this script install its required dependencies on your machine and that it will manipulate files on your computer in order to perform its task.*

#### Method 1: Execute the script with unrestricted execution policy
##### Step 1: Check if the execution policy is already set to unrestricted
Open the start menu and search for "Powershell" and click on "Run as administrator" (see picture)
<p align="center">
   <img src="https://i.imgur.com/YvRGDCp.png" width="380">
</p>

Once the PowerShell is open, run the following command:
```powershell
Get-ExecutionPolicy
```
If the policy is already set to "Unrestricted", skip to [Use](#Use).
##### Step 2: Change the execution policy
If the policy is not Unrestricted, run the following command:
```powershell
Set-ExecutionPolicy Unrestricted
```
And answer "Y" to the security question. **Note:** Make sure you run PowerShell as an administrator, or this step will not work.

<ins>**Word of warning:**</ins> Allowing your computer to execute script as Unrestricted is a potential security risk. I would strongly suggest you to review the source code of this project and use the self-signed method instead. You could also set the execution policy scope to the current process to only change it once, and redo that every time you want to run this script. To do this, run the following command:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process
```

#### Method 2: Self sign the script
The method for self-signing a script is well documented on Microsoft's Technet website, which you can consult [here](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_signing?view=powershell-7.1#create-a-self-signed-certificate).

## Use
### MacOS and Linux
You can launch the script without argument, the script will ask for the path.

```bash
bash jpeg2webp
```

Or you can provide the path as an argument

```bash
bash jpeg2webp /path/to/folder
```
### Windows
Navigate to the folder in PowerShell and launch the command:
```powershell
.\jpeg2webp.ps1
```

### Word of Caution (MacOS and Linux)
This script works in ***bash only***. As it currently is, the script fails in a zsh interpreter.

## Example

This is before the script

```
album_folder/
├─ image1.jpg
├─ image2.jpg
├─ image3.jpg
```

And this is after

```
album_folder/
├─ jpeg/
│  ├─ 9F721D48-2DF3-4570-8744-0790C3577454-500.jpg
│  ├─ 9F721D48-2DF3-4570-8744-0790C3577454-1000.jpg
│  ├─ 9F721D48-2DF3-4570-8744-0790C3577454-1500.jpg
│  ├─ 9F721D48-2DF3-4570-8744-0790C3577454-2000.jpg
│  ├─ FBC87CFF-BF75-4017-86B0-CE69910C0670-500.jpg
│  ├─ FBC87CFF-BF75-4017-86B0-CE69910C0670-1000.jpg
│  ├─ FBC87CFF-BF75-4017-86B0-CE69910C0670-1500.jpg
│  ├─ FBC87CFF-BF75-4017-86B0-CE69910C0670-2000.jpg
│  ├─ 6BA43107-8AAC-497A-83F9-5D13A1AEF29D-500.jpg
│  ├─ 6BA43107-8AAC-497A-83F9-5D13A1AEF29D-1000.jpg
│  ├─ 6BA43107-8AAC-497A-83F9-5D13A1AEF29D-1500.jpg
│  ├─ 6BA43107-8AAC-497A-83F9-5D13A1AEF29D-2000.jpg
├─ originals/
│  ├─ 9F721D48-2DF3-4570-8744-0790C3577454.jpg
│  ├─ FBC87CFF-BF75-4017-86B0-CE69910C0670.jpg
│  ├─ 6BA43107-8AAC-497A-83F9-5D13A1AEF29D.jpg
├─ webp/
│  ├─ 9F721D48-2DF3-4570-8744-0790C3577454-500.webp
│  ├─ 9F721D48-2DF3-4570-8744-0790C3577454-1000.webp
│  ├─ 9F721D48-2DF3-4570-8744-0790C3577454-1500.webp
│  ├─ 9F721D48-2DF3-4570-8744-0790C3577454-2000.webp
│  ├─ FBC87CFF-BF75-4017-86B0-CE69910C0670-500.webp
│  ├─ FBC87CFF-BF75-4017-86B0-CE69910C0670-1000.webp
│  ├─ FBC87CFF-BF75-4017-86B0-CE69910C0670-1500.webp
│  ├─ FBC87CFF-BF75-4017-86B0-CE69910C0670-2000.webp
│  ├─ 6BA43107-8AAC-497A-83F9-5D13A1AEF29D-500.webp
│  ├─ 6BA43107-8AAC-497A-83F9-5D13A1AEF29D-1000.webp
│  ├─ 6BA43107-8AAC-497A-83F9-5D13A1AEF29D-1500.webp
│  ├─ 6BA43107-8AAC-497A-83F9-5D13A1AEF29D-2000.webp
├─ album.json
```

And the file *album.json* would contain the following :

```json
{
   "name":"Album name",
   "description":"Album description",
   "year":2021,
   "city":"Album's city",
   "country":"Album's country",
   "pictures":[
      "9F721D48-2DF3-4570-8744-0790C3577454",
      "FBC87CFF-BF75-4017-86B0-CE69910C0670",
      "6BA43107-8AAC-497A-83F9-5D13A1AEF29D"
   ],
   "cover":"9F721D48-2DF3-4570-8744-0790C3577454",
   "sizes":[
      500,
      1000,
      1500,
      2000
   ]
}
```

## Dependencies (MacOS)

1. [Homebrew](https://brew.sh/)
2. [NodeJS](https://nodejs.org/en/)
3. [NPM](https://www.npmjs.com/)
4. [coreutils](https://formulae.brew.sh/formula/coreutils)
5. [ImageMagick](https://formulae.brew.sh/formula/imagemagick#default)
6. [spinner.sh](https://github.com/tlatsas/bash-spinner/blob/master/spinner.sh) (*embedded*)
7. [webp-converter-cli](https://www.npmjs.com/package/webp-converter-cli)

## Dependencies (Linux-Debian)

1. [ImageMagick](https://formulae.brew.sh/formula/imagemagick#default)
2. [coreutils](https://www.gnu.org/software/coreutils/)
3. [spinner.sh](https://github.com/tlatsas/bash-spinner/blob/master/spinner.sh) (*embedded*)

## Dependencies (Windows)
1. [Chocolatey](https://chocolatey.org/)
2. [ImageMagick](https://formulae.brew.sh/formula/imagemagick#default)
