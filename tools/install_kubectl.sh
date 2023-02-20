#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

SUDO=
if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

${SUDO} apt-get update
${SUDO} apt-get install -y apt-transport-https
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | ${SUDO} gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes.gpg] \
    https://apt.kubernetes.io/ kubernetes-xenial main" | \
    ${SUDO} tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
${SUDO} apt-get update
${SUDO} apt-get install -y --allow-downgrades kubectl=${KUBECTL_VERSION}
