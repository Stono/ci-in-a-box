#!/bin/bash

function bold {
  sbold=$(tput bold)
  snormal=$(tput sgr0)
  echo "${sbold}$*${snormal}"
}

function wait_for_url {
  echo -n Waiting for $1 to be available...
  set +e
  while ! curl -Lk -s -o /dev/null "$1"; do
    printf "."
    sleep 1
  done
  echo ""

  set -e
}

function exp {
  ARG_NAME=$1
  ARG_VALUE=$2
  ARG_NAME_LOWER=$(echo "$ARG_NAME" | awk '{print tolower($0)}') 
  eval "export $ARG_NAME=$ARG_VALUE"
  eval "export TF_VAR_$ARG_NAME_LOWER=$ARG_VALUE"
}

function enforce_arg {
  ARG_NAME="$1"
  ARG_DESC="$2"
  ARG_VALUE="${!1}"

  if [ -z "$ARG_VALUE" ]; then
    PROMPT=" - $ARG_DESC: " 
  else
    PROMPT=" + $ARG_DESC ($ARG_VALUE): " 
    if [ "$NO_PROMPT" = "true" ]; then
      echo "$PROMPT"
      exp "$ARG_NAME" "$ARG_VALUE"
      return;
    fi
  fi

  while read -rp "$PROMPT" REPLY
  do
    case "$REPLY" in
      '')
        if [ ! -z "$ARG_VALUE" ] ; then
          break;
        fi
        ;;
      *)
        exp "$ARG_NAME" "$ARG_VALUE"
        break;
    esac
  done
}

function confirm {
  if [ "$NO_CONFIRM" = "true" ]; then
    return 
  fi
  read -r -p "Do you want to continue? [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY])
      return; 
      ;;
    *)
      echo "Aborting."
      exit 1
      ;;
  esac
}

function version_check {
  if [[ $1 == $2 ]]
  then
    echo " + $3 ($1 >= $2)"
    return 0
  fi
  local IFS=.
  local i ver1=($1) ver2=($2)
  # fill empty fields in ver1 with zeros
  for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
  do
    ver1[i]=0
  done
  for ((i=0; i<${#ver1[@]}; i++))
  do
    if [[ -z ${ver2[i]} ]]
    then
      # fill empty fields in ver2 with zeros
      ver2[i]=0
    fi
    if ((10#${ver1[i]} > 10#${ver2[i]}))
    then
      echo " + $3 ($1 >= $2)"
      return 1
    fi
    if ((10#${ver1[i]} < 10#${ver2[i]}))
    then
      echo " - $3 ($2 < $1)"
      echo ""
      echo "Your version of $3 is $1, you need to have a minimum of $2."
      echo "Please update and try again"
      exit 1
    fi
  done
  echo " + $3 ($1 >= $2)"
  return 0
}

function command_check {
  if ! type "$1" &> /dev/null; then
    echo " - $1"
    echo "You need $1 installed, please get it and try again"
    if [ ! -z "$2" ]; then
      echo "$2"
    fi
    exit 1
  else
    echo " + $1"
  fi
}
