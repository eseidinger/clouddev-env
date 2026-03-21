#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

mkdir -p ~/bin
mkdir -p ~/tools/terraform

wget -q -P ~/ https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_$(dpkg --print-architecture).zip
unzip ~/terraform_${TERRAFORM_VERSION}_linux_$(dpkg --print-architecture).zip terraform -d ~/tools/terraform/
rm ~/terraform_${TERRAFORM_VERSION}_linux_$(dpkg --print-architecture).zip
rm -f ~/bin/terraform
ln -s ~/tools/terraform/terraform ~/bin/terraform
