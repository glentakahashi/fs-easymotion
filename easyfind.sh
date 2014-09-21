#set to 1 if easyfind should ignore case
IGNORE_CASE=1

#ez find files in current directory with name
easyFind() {
  local QUERY
  if [[ $IGNORE_CASE -eq 1 ]]; then
    QUERY="-iname"
  else
    QUERY="-name"
  fi
  find ./* $QUERY "*$1*"
}

easyFindOpen() {
  local NUM=0
  local RED_BOLD_FONT=$'\e[1m\e[91m'
  local NORMAL_FONT=$'\e[0m\e[39m'
  #find our files
  local FILES=""
  while IFS= read -r LINE || [[ -n "$LINE" ]]; do
    FILES=$FILES$LINE$'\n'
    printf "%s%s %s%s\n" $RED_BOLD_FONT $NUM $NORMAL_FONT $LINE
    ((NUM++))
  done < <(easyFind $1)
  read N
  local i=0
  printf %s "$FILES" |
  while IFS= read -r LINE2 || [[ -n "$LINE2" ]]; do
    if [[ "$i" = $N ]]; then
      if [[ -f $LINE2 ]]; then
        vim $LINE2 < /dev/tty
        return 0;
      elif [[ -d $LINE2 || -h $LINE2 ]]; then
        cd $LINE2
        return 0;
      else
        echo "Not a directory or editable file"
        return 1;
      fi
    fi
    ((i++))
  done
  echo "Invalid number!"
  return 1;
}
