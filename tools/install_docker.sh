#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

SUDO=
if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

${SUDO} apt-get update
${SUDO} apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

${SUDO} mkdir -p -m 0755 /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | ${SUDO} gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | ${SUDO} tee /etc/apt/sources.list.d/docker.list > /dev/null

${SUDO} apt-get update

${SUDO} apt-get install -y --allow-downgrades docker-ce=${DOCKER_VERSION} docker-ce-cli=${DOCKER_VERSION} containerd.io docker-buildx-plugin docker-compose-plugin
