#!/usr/bin/env bash

UPDATE_FLAG=$1

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

SUDO=
if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

curl -s "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m)-${AWS_CLI_VERSION}.zip" -o ~/awscliv2.zip
unzip -q ~/awscliv2.zip -d ~/
${SUDO} ~/aws/install ${UPDATE_FLAG}
rm -rf ~/aws
rm ~/awscliv2.zip
