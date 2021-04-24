# batch-image-webp
Batch converts images to webp and resize them for responsive web.

The script renames all images with random UUID, resize the images (with longest border) to 500, 1000, 1500 and 2000, then convert them to webp. Finally it moves the original in a folder, the minified jpegs in another folder, and the webp in another folder.

## Install
Simply download the script and run it in the Terminal. The script will manage to install its required dependencies (on Mac). **This app requires sudo access (so admin only) for the installation of its dependencies. To run it as a regular user, make sure to first install the dependencies required, the script should then run fine. (Check below for all dependencies)**

***This application is build for MacOS and will likely not work on Linux due to its dependecy on Homebrew***
### Update on Linux Compatibility
#### v1.1.3
Added initial compatibility layer via a dedicated linux script for debian like systems (in subdirectory linux/).

~~As of v1.1.1, the script does not run on Ubuntu 21.04 (at least in my tests). Script run into issues trying to install Homebrew. Although I could only test it as a root user on a linode server, so that could be the issue. Check the issue tab for more details, or if you want to contribute.~~

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
This script works in ***bash only***. As it currently is, the script fails in a zsh interpreter. This is currently being investigated.

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

## Dependencies

1. [Homebrew](https://brew.sh/)
2. [NodeJS](https://nodejs.org/en/)
3. [NPM](https://www.npmjs.com/)
4. [coreutils](https://formulae.brew.sh/formula/coreutils)
5. [ImageMagick](https://formulae.brew.sh/formula/imagemagick#default)
6. [spinner.sh](https://github.com/tlatsas/bash-spinner/blob/master/spinner.sh) (*embedded*)
7. [webp-converter-cli](https://www.npmjs.com/package/webp-converter-cli)
