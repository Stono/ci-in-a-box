#!/bin/bash
function kube {
  kubectl $*
}

acquire_credentials_for_cluster() {
  echo "Acquiring credentials for cluster $1"
  gcloud container clusters get-credentials $1 \
    --zone europe-west1-c --project $GCP_PROJECT_NAME 
}

function delete_secret {
  set +e
  kube delete secret $1 2>/dev/null
  set -e
}

function ensure_secret_literal {
  delete_secret $1
  kube create secret generic $1 --from-literal=$2=$3
}

function ensure_secret_file {
  delete_secret $1
  kube create secret generic $1 --from-file=$2=$3
}
