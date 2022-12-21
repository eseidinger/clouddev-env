#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

curl -s "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m)-${AWS_CLI_VERSION}.zip" -o ~/awscliv2.zip
unzip -q ~/awscliv2.zip -d ~/
~/aws/install
rm -rf ~/aws
rm ~/awscliv2.zip
