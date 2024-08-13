# How to use
- Move this script to the same folder as the files and folders you want to rename
- Rename all files and folders whose names you do not want to keep so that their names begin with `noname`
- Start this script and wait until it has reached 100%
> [!IMPORTANT]
> Check manually whether there are files/folders that have not been renamed. There may be a problem with the creation, modification and access date.
# How it works
It renames all files and folders except itself. It will only rename at the level it is at, it will not recursively go to each subfolder.
Files that have already been renamed are ignored.
It determines the creation, modification and access date and uses the oldest date for renaming.
If the name of a file/folder starts with `noname`, it will be replaced completely, otherwise a prefix will be appended.
If the new file name already exists, a counter is incremented and added as a suffix after the file name.
If an error occurs, the renaming of the current file/folder is skipped.
> [!WARNING]
> The oldest renamed date may not be the original creation date. This script cannot solve the problem that, for example, someone has forgotten to set the correct date in a camera.

> [!NOTE]
> New file name format if the file name starts with `noname`:
>   
>     YYYY-MM-DD hh-mm-ss.EXTENSION
>   
> else:
>   
>     YYYY-MM-DD hh-mm-ss FILENAME.EXTENSION
>
> `YYYY: Year in 4 digits`
> `MM: Month 2 digits`
> `DD: Day 2 digits`
> `hh: Hour 2 digits in 24h format`
> `mm: Minute 2 digits`
> `ss: Second 2 digits`
> `FILENAME: Previous file name`
> `EXTENSION: Extension in lowercase`
# Examples
| before               | after                              |
| -------------------- | ---------------------------------- |
| DCIM0157.JPEG        | 2008-12-23 09-55-04 DCIM0157.jpeg  |
| nonameDCIM3489.JPG   | 2011-02-10 18-36-02.jpg            |
| noname baumhaus.JPG  | 2015-09-28 13-00-49.jpg            |
| noname (24894).jpg   | 2024-08-13 16-58-11.jpg            |
# Requirements
`wmic` with dependencies installed
> [!WARNING]
> `wmic` is obsolete and may be removed from future versions of Windows. See https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/wmic
