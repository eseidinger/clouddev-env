#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

source ~/miniconda3/bin/activate base

conda install -y -n base conda=${CONDA_VERSION}
conda install -y -n base python=${PYTHON_VERSION}
