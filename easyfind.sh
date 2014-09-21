#set to 1 if easyfind should ignore case
EASYFIND_IGNORE_CASE=1

#command to run for files
EASYFIND_FILE_COMMAND="$EDITOR"
if [[ -z $EASYFIND_FILE_COMMAND ]]; then
  EASYFIND_FILE_COMMAND="vim"
fi

#ez find files in current directory with name
easyFind() {
  local QUERY
  if [[ $EASYFIND_IGNORE_CASE -eq 1 ]]; then
    QUERY="-iname"
  else
    QUERY="-name"
  fi
  if [[ -z $1 || $1 = "-h" || $1 = "--help" ]]; then
    echo "Usage: [directory] <search-string>" >&2
    echo "Example: easyFind ~/projects MainController" >&2
    echo "use -h or --help to see this help message again" >&2
    return 1;
  elif [[ -z $2 ]]; then
    find ./* $QUERY "*$1*"
  else
    find $1 $QUERY "*$2*"
  fi
}

easyFindOpen() {
  local NUM=1
  local RED_BOLD_FONT=$'\e[1m\e[91m'
  local NORMAL_FONT=$'\e[0m\e[39m'
  #find our files
  local FILES=""
  while IFS= read -r LINE || [[ -n "$LINE" ]]; do
    FILES=$FILES$LINE$'\n'
    printf "%s%s %s%s\n" $RED_BOLD_FONT $NUM $NORMAL_FONT $LINE
    ((NUM++))
  done < <(easyFind $1 $2)
  if [[ ${#FILES} -eq 0 ]]; then
    echo "No results found." >&2
    return 1;
  fi
  printf %s "Enter a number to open or 0 to quit: "
  read N
  re='^[0-9]+$'
  if ! [[ $N =~ $re ]] ; then
    echo "error: Not a number" >&2; return 1
  fi
  if [[ $N = "0" ]] ; then
    return 0
  fi
  LINE=$(printf "%s" "$FILES" | sed "${N}q;d")
  if [[ -f $LINE ]]; then
    $EASYFIND_FILE_COMMAND $LINE < /dev/tty
    return 0;
  elif [[ -d $LINE || -h $LINE ]]; then
    cd $LINE
    return 0;
  else
    echo "Not a directory or editable file" >&2
    return 1;
  fi
}
