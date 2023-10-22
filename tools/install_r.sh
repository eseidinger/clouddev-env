#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

SUDO=
if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

${SUDO} apt update -qq
${SUDO} apt install --no-install-recommends -y software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | ${SUDO} tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
${SUDO} add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

${SUDO} apt install --no-install-recommends -y r-base=${R_VERSION} r-base-dev=${R_VERSION}
