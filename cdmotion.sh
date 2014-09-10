#change this to 1 if you would prefer to replace first character instead of add it
REPLACE_FIRST_CHAR=1
SHOW_ROOT_AS_A=1

#TODO: make customizable and more easily configuraable
#TODO: also list folders in current directory as letters - maybe make this ,, (a different function)

chr() {
  printf \\$(printf '%03o' $1)
}

ord() {
  printf '%d' "'$1"
}

supercd() {
  local DIR=$1
  local j=$(($2+1+(1-$SHOW_ROOT_AS_A)))
  for (( i=0; i<${#DIR}; i++ )); do
    CHAR=${DIR:$i:1}
    if [[ $CHAR = "/" ]]; then
      ((j--))
    fi
    if [[ $j -eq 0 ]]; then
      cd ${DIR:0:$i+1}
      return 0;
    fi
  done
}

cdmotion() {
  local DIR=$(pwd)

  #color and settings variables
  #TODO: make customizable
  local RED_BOLD_FONT=$'\e[1m\e[91m'
  local NORMAL_FONT=$'\e[0m\e[39m'

  #copy dir and change each letter after / into a letter
  #TODO: make this work for paths longer than 52 chars
  local DIR2=$DIR
  local j=0
  if [[ $SHOW_ROOT_AS_A -eq 1 ]]; then
    DIR2=$RED_BOLD_FONT'a'$NORMAL_FONT$DIR
    j=1
  fi
  for (( i=0; i<${#DIR2}; i++ )); do
    local CHAR=${DIR2:$i:1}
    if [[ $CHAR = "/" ]]; then
      #TODO: refactor
      if [[ $j -lt 52 ]]; then
        local HEAD=${DIR2:0:$i+1}$RED_BOLD_FONT
        local TAIL=$NORMAL_FONT${DIR2:$i+1+$REPLACE_FIRST_CHAR:${#DIR2}-$i}
        local CHAR='Z'
        if [[ $j -lt 26 ]]; then
          CHAR=$(chr $(($j+97)))
        else
          CHAR=$(chr $(($j-26+65)))
        fi
        DIR2=$HEAD$CHAR$TAIL
      else
        >&2 echo Path is too long! Must be less than 52 dirs deep.
        return 1;
      fi
      ((j++))
    fi
  done
  echo $DIR2
  while true; do
    #TODO: make work with bash or zsh
    builtin read -s -k 1 key
    local keyint=$(ord $key)
    echo $keyint
    if [[ $keyint -ge 97 ]]; then
      if [[ $(($keyint - 97)) -lt j ]]; then
        supercd $DIR $(($keyint - 97))
        return 0;
      else
        echo $DIR2
      fi
    elif [[ $keyint -ge 65 ]]; then
      if [[ $(($keyint - 65 + 26)) -lt j ]]; then
        supercd $DIR $(($keyint - 65 + 26))
        return 0;
      else
        echo $DIR2
      fi
    elif [[ $keyint -eq 27 ]]; then
      return 0;
    else
      echo $DIR2
    fi
  done
}
