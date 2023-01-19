#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

apt-get update

apt-get install -y --allow-downgrades docker-ce=${DOCKER_VERSION} docker-ce-cli=${DOCKER_VERSION}
