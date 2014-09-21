#set to 1 if easygrep should ignore case
EASYGREP_IGNORE_CASE=1

#command to run for files
EASYGREP_FILE_COMMAND="$EDITOR"
if [[ -z $EASYGREP_FILE_COMMAND ]]; then
  EASYGREP_FILE_COMMAND="vim"
fi

#options for grep
EASYGREP_GREP_OPTIONS="--color=always"

#ez find files which contain text
easyGrep() {
  local QUERY
  if [[ $EASYGREP_IGNORE_CASE -eq 1 ]]; then
    QUERY="-riI"
  else
    QUERY="-rI"
  fi
  local DIR
  local STR
  if [[ -z $1 || $1 = "-h" || $1 = "--help" ]]; then
    echo "Usage: [directory] <search-string>" >&2
    echo "Example: easyGrep ~/projects somefunctionname" >&2
    echo "use -h or --help to see this help message again" >&2
    return 1;
  elif [[ -z $2 ]]; then
    DIR=.
    STR=$1
  else
    DIR=$1
    STR=$2
  fi
  grep $EASYGREP_GREP_OPTIONS $QUERY $STR $DIR
}

easyGrepOpen() {
  local NUM=1
  local RED_BOLD_FONT=$'\e[1m\e[91m'
  local NORMAL_FONT=$'\e[0m\e[39m'
  #find our files
  local FILES=""
  while IFS= read -r LINE || [[ -n "$LINE" ]]; do
    FILES=$FILES$LINE$'\n'
    printf "%s%s %s%s\n" $RED_BOLD_FONT $NUM $NORMAL_FONT $LINE
    ((NUM++))
  done < <(easyGrep $1 $2)
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
  #strip color if we have it
  if [[ $OSTYPE = "darwin"* ]]; then
    LINE=$(printf "%s" "$LINE" | sed -E 's/\E\[[0-9;]*[mK]//g')
  else
    LINE=$(printf "%s" "$LINE" | sed -r 's/\x1B\[[0-9;]*[mK]//g')
  fi
  local INDEX=$(expr index "$LINE" ":")
  $EASYGREP_FILE_COMMAND ${LINE:0:($INDEX-1)} < /dev/tty
  return 0;
}
