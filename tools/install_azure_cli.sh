#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

pip install --force-reinstall -v "azure-cli==${AZURE_CLI_VERSION}"
