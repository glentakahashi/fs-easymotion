#set to 1 if easygrep should ignore case
IGNORE_CASE=1
COMMAND_ON_FILE=vim

#ez find files which contain text
easyGrep() {
  local QUERY
  if [[ $IGNORE_CASE -eq 1 ]]; then
    QUERY="-riI"
  else
    QUERY="-rI"
  fi
  local DIR
  local STR
  if [[ -z $1 || $1 = "-h" || $1 = "--help" ]]; then
    echo "Usage: [directory] <filename-search-string>\nuse -h or --help to see this help message again" >&2
    return 1;
  elif [[ -z $2 ]]; then
    DIR=.
    STR=$1
  else
    DIR=$1
    STR=$2
  fi
  grep $QUERY $STR $DIR
}

easyGrepOpen() {
  local NUM=0
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
  read N
  re='^[0-9]+$'
  if ! [[ $N =~ $re ]] ; then
    echo "error: Not a number" >&2; return 1
  fi
  ((N++))
  LINE=$(printf "%s" "$FILES" | sed "${N}q;d")
  local INDEX=$(expr index "$LINE" ":")
  $COMMAND_ON_FILE ${LINE:0:($INDEX-1)} < /dev/tty
  return 0;
}
