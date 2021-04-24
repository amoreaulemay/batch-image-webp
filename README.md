# batch-image-webp
Batch converts images to webp and resize them for responsive web.

The script renames all images with random UUID, resize the images (with longest border) to 500, 1000, 1500 and 2000, then convert them to webp. Finally it moves the original in a folder, the minified jpegs in another folder, and the webp in another folder.

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

## Use
You can launch the script without argument, the script will ask for the path.

```bash
bash jpeg2webp
```

Or you can provide the path as an argument

```bash
bash jpeg2webp /path/to/folder
```

### Word of Caution
This script works in ***bash only***. As it currently is, the script fails in a zsh interpreter. ~~This is currently being investigated.~~

## Example

This is before the script

```
parent_folder/
├─ image1.jpg
├─ image2.jpg
├─ image3.jpg
```

And this is after

```
parent_folder/
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
1. [PowerShell](https://github.com/PowerShell/PowerShell)
2. [Chocolatey](https://chocolatey.org/)
3. [ImageMagick](https://formulae.brew.sh/formula/imagemagick#default)
