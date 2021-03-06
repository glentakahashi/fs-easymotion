# fs-easymotion
fs-easymotion is a collection of bash functions to help navigate the filesystem using built-in \*nix commands.
Currently is has only been tested on zsh, but will eventually be updated to work on all the popular shells.

Inpsired by [vim-easymotion](https://github.com/Lokaltog/vim-easymotion), it tries to simplify navigation down
to long lists with few keystrokes rather than long or repeated commands.

As of now fs-easymotion contains 3 functions sets, each for a different purpose:
* easycd.sh - navigate to higher directories without having to use ../../../.. repeatedly
    * ```easyCdUp``` - Displays pwd with highlighted characters. Navigate to a dir just by pressing the corresponding character.
* easyfind.sh - find files and directories quickly and open them quickly
    * ```easyFind [directory-to-search] <search-string>``` - find all files recursively in a folder that have
    the search-string in their filename
    * ```easyFindOpen [directory-to-search] <search-string>``` - the above, plus asks for a line number
    of the file/directory you want to open
* easygrep.sh - find text in files and open their containing files quickly
    * ```easyGrep [directory-to-search] <search-string>``` - find all files recursively in a folder that have
    the search-string in their body text
    * ```easyGrepOpen [directory-to-search] <search-string>``` - the above, but asks for a line number
    of the file you want to open

## Installation

Add the following line to the top of your zshrc, and set FSEM to where the files live:
```
FSEM=/location/to/fs-easymotion
source $FSEM/easycd.sh
source $FSEM/easygrep.sh
source $FSEM/easyfind.sh
```

Now you can either type the commands listed above in terminal, or alias them for fast access like I do. I suggest:
```
alias u='easyCdUp'
alias f='easyFind'
alias ff='easyFindOpen'
alias g='easyGrep'
alias gg='easyGrepOpen'
```

## Configuration

Currently, the files have the following configurable options.

* easycd.sh
    * ```EASYCD_REPLACE_FIRST_CHAR=1``` - whether or not to replace the first character of the dirs or just prepend it (default 1)
    * ```EASYCD_SHOW_ROOT_AS_A=1``` - whether or not to show the root directory as 'a' (default 1)
* easyfind.sh
    * ```EASYFIND_IGNORE_CASE=1``` - 1 to ignore case, 0 to be case sensitive (default 1)
    * ```EASYFIND_COMMAND_ON_FILE="$EDITOR"``` - the command to run on a selected file (defaults to $EDITOR or vim if unset)
* easygrep.sh
    * ```EASYGREP_IGNORE_CASE=1``` - 1 to ignore case, 0 to be case sensitive (default 1)
    * ```EASYGREP_COMMAND_ON_FILE="$EDITOR"``` - the command to run on a selected file (defaults to $EDITOR or vim if unset)
    * ```EASYGREP_GREP_OPTION="--color=always"``` - extra options to add to the grep command (default --color=always)

## Screenshots

### easycd.sh

![easycd.sh](http://files.glentaka.com/easycd.gif)

### easyfind.sh

![easyfind.sh](http://files.glentaka.com/easyfind.gif)

### easygrep.sh

![easygrep.sh](http://files.glentaka.com/easygrep.gif)
