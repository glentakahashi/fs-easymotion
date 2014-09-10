#change this to 1 if you would prefer to replace first character instead of add it
REPLACE_FIRST_CHAR=1

#TODO: make customizable and more easily configuraable
#TODO: add making root (/) as 'a' a preference
#TODO: also list folders in current directory as letters - maybe make this ,, (a different function)

chr() {
  printf \\$(printf '%03o' $1)
}

ord() {
  printf '%d' "'$1"
}

supercd() {
  local DIR=$1
  local j=$(($2+2))
  for (( i=0; i<${#DIR}; i++ )); do
    CHAR=${DIR:$i:1}
    if [[ $CHAR = "/" ]]; then
      ((j--))
    fi
    if [[ $j -eq 0 ]]; then
      cd ${DIR:0:$i}
      return;
    fi
  done
}

cdmotion() {
  #current dir
  local DIR=$(pwd)

  #color and settings variables
  #TODO: make customizable
  local special=$'\e[1m\e[91m'
  local normal=$'\e[0m\e[39m'

  #copy dir and change each letter after / into a letter
  #TODO: make this work for paths longer than 52 chars
  local DIR2=$DIR
  local j=0
  for (( i=0; i<${#DIR2}; i++ )); do
    local CHAR=${DIR2:$i:1}
    if [[ $CHAR = "/" ]]; then
      #TODO: refactor
      if [[ j -lt 26 ]]; then
        DIR2=${DIR2:0:$i+1}$special$(chr $(($j+97)))$normal${DIR2:$i+1+$REPLACE_FIRST_CHAR:${#DIR2}-$i}
      elif [[ j -lt 52 ]]; then
        DIR2=${DIR2:0:$i+1}$special$(chr $(($j+65)))$normal${DIR2:$i+1+$REPLACE_FIRST_CHAR:${#DIR2}-$i}
      else
        >&2 echo Path is too long!
        return;
      fi
      ((j++))
    fi
  done
  echo $DIR2
  while true; do
    #TODO: make work with bash or zsh
    builtin read -s -k 1 key
    local keyint=$(ord $key)
    if [[ $keyint -ge 97 ]]; then
      if [[ $(($keyint - 97)) -lt j ]]; then
        supercd $DIR $(($keyint - 97))
        return;
      else
        echo $DIR2
      fi
    elif [[ $keyint -ge 66 ]]; then
      if [[ $(($keyint - 65 + 26)) -lt j ]]; then
        supercd $DIR $(($keyint - 65 + 26))
        return;
      else
        echo $DIR2
      fi
    elif [[ $keyint -eq 27 ]]; then
      return;
    else
      echo $DIR2
    fi
  done
}
