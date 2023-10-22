#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

SUDO=
if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

${SUDO} apt update -qq
${SUDO} apt install --no-install-recommends -y r-base=${R_VERSION} r-base-dev=${R_VERSION}
