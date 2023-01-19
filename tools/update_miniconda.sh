#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

conda install -y -n base conda=${CONDA_VERSION}
conda install -y -n base python=${PYTHON_VERSION}
