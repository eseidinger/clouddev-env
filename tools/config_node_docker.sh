#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

move ~/.nvm/versions/node/v${NODE_VERSION} ~/.nvm/versions/node/current
