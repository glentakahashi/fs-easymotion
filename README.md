# fs-easymotion
fs-easymotion is a collection of bash functions to help navigate the filesystem using built-in \*nix commands.
Inpsired by [vim-easymotion](https://github.com/Lokaltog/vim-easymotion) it tries to simplify navigation down
to long lists with few keystrokes.

As of now fs-easymotion contains 3 sets of functions each for a different purpose:
* easycd.sh - navigate to higher directories without having to use ../../../.. repeatedly
    * easyCdUp - will display pwd with first character of each folder replace. Press the letter
    of the desired folder and you will navigate there.
* easyfind.sh - find files and directories quickly and open them quickly
    * easyFind [directory-to-search] <search-string> - find all files recursively in a folder that have
    the search-string in their filename
    * easyFindOpen [directory-to-search] <search-string> - does the same as above, but asks for a line number
    of the file/directory you want to open
* easygrep.sh - find text in files and open their containing files quickly
    * easyGrep [directory-to-search] <search-string> - find all files recursively in a folder that have
    the search-string in their body text somewhere
    * easyGrepOpen [directory-to-search] <search-string> - does the same as above, but asks for a line number
    of the file/directory you want to open

## Installation

For each of the function sets you want to install, add the following line to the top of your zshrc:
> source /location/to/easyfile.sh

Now you can either type the commands listed above in terminal, or alias them for fast access like I do. I suggest:
> alias u='easyCdUp'
> alias f='easyFind'
> alias ff='easyFindOpen'
> alias g='easyGrep'
> alias gg='easyGrepOpen'

## Configuration

Currently, the files have the following configurable options.

* easycd.sh
    * REPLACE_FIRST_CHAR - whether or not to replace the first character of the dirs or just prepend it (default 1)
    * SHOW_ROOT_AS_A - whether or not to show the root directory as 'a' (default 1)
* easyfind.sh and easygrep.sh
    * IGNORE_CASE - 1 to ignore case, 0 to be case sensitive (default 1)
    * COMMAND_ON_FILE - the command to run when you select a file (default vim)

## Screenshots

### easycd.sh

!https://i.imgur.com/JEBvs6x.gif!

### easyfind.sh

!https://i.imgur.com/mkH2OMV.gif!

### easygrep.sh

!https://i.imgur.com/3xbIOwo.gif!
