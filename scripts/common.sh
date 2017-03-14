#!/bin/bash
if [ "$COMMON_DONE" = "true" ]; then
  return;
fi
COMMON_DONE="true"

function ensure_disk {
  set +e
  if ! gcloud compute disks describe "$1" &>/dev/null; then
    echo " - $1"
    echo "   Creating disk $1 with size $2"
    gcloud compute disks create --size=$2 $1
  else
    echo " + $1"
  fi                                                                                                                            
  set -e
}

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

function export_variable {
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
      export_variable "$ARG_NAME" "$ARG_VALUE"
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
        export_variable "$ARG_NAME" "$ARG_VALUE"
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

check_presence() {
  if [ -z "$1" ] ; then
    display_usage_and_exit
  fi
}

function ensure_gcloud_configuration {
  bold "Validating gcloud configuration..."
  if ! gcloud config list 2>/dev/null | grep "$GCP_PROJECT_NAME" &>/dev/null; then
    gcloud config set compute/region "$TARGET_REGION"
    gcloud config set compute/zone "$TARGET_ZONE_A"
    gcloud config set project "$GCP_PROJECT_NAME"
  else 
    echo " + $GCP_PROJECT_NAME"
  fi
  echo ""
  bold "Validating authentication status..."
  if gcloud auth list 2>&1 | grep "No credentialed accounts." &>/dev/null; then
    gcloud auth login 
    gcloud auth application-default login
  else
    echo " + $(gcloud auth list 2>/dev/null | grep ACTIVE | awk '{print $2}')"
  fi
  echo ""
}

function abs_path {
  echo $(cd $1 && echo $PWD)
}
called=$_
if [[ $called != $0 ]]; then 
  ROOT="$(abs_path $(dirname ${BASH_SOURCE[0]})/../)"
else
  ROOT=$(abs_path "$(dirname $0)/")
  if [ ! -f "$ROOT/start" ]; then
    ROOT=$(abs_path "$(dirname $0)/../")
  fi
  if [ ! -f "$ROOT/start" ]; then
    echo "ERROR: Unable to locate project root!"
    exit 1
  fi
fi

source "$ROOT/.env.default"
if [ -f "$ROOT/.env" ]; then
  source "$ROOT/.env"
fi

TEMP_DIR=$ROOT/.tmp
mkdir -p "$TEMP_DIR"
