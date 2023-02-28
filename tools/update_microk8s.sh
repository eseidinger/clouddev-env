#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

SUDO=
if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

${SUDO} snap refresh microk8s --channel=${MICROK8S_VERSION}
