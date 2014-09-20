#set to 1 if easyfind should ignore case
IGNORE_CASE=1

#ez find files in current directory with name
easyFind() {
  local NUM=0
  local RED_BOLD_FONT=$'\e[1m\e[91m'
  local NORMAL_FONT=$'\e[0m\e[39m'
  local QUERY
  if [[ $IGNORE_CASE -eq 1 ]]; then
    QUERY="-iname"
  else
    QUERY="-name"
  fi
  find . $QUERY "*$1*" |
  while IFS= read -r line; do
    printf "%s%s%s%s\n" $RED_BOLD_FONT $NUM $NORMAL_FONT $line
    ((NUM++))
  done
}

easyFindOpen() {
  #find our files
  local FILES=`ff $1`
  printf "%s" $FILES
  read NUM
  local i=0
  printf "%s" $FILES |
  while IFS= read -r line; do
    if [[ "$i" = $NUM ]]; then
      local start=`expr index $line ./`
      line=${line:($start-1)}
      if [[ -f $line ]]; then
        vim $line < /dev/tty
        return 0;
      else
        cd $line
        return 0;
      fi
    fi
    ((i++))
  done
}
