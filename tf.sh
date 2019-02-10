#!/usr/bin/env bash

platform="$(uname | tr '[:upper:]' '[:lower:]')"

TF_VERSION="0.11.11"
TF_ARCHIVE="terraform_${TF_VERSION}_${platform}_amd64.zip"
TF_URL="https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_ARCHIVE}"

toolkit="/tmp/${USER}-${UID}-tf-gcp-${TF_VERSION}"

if [ ! -z ${CLEAN} ]; then
    echo "Cleaning utilities in $toolkit"
    rm -rf ${toolkit}
fi

if [[ ! -x "$toolkit/bin/terraform" ]]; then
  echo "Bootstrapping utilities in $toolkit"
  rm -rf ${toolkit}
  mkdir -p ${toolkit}/var
  wget ${TF_URL} -P $toolkit/var
  unzip ${toolkit}/var/${TF_ARCHIVE} -d ${toolkit}/bin
  echo "Bootstrapping done"
fi

tfexec="${toolkit}/bin/terraform"

exec ${tfexec} ${@:1}
