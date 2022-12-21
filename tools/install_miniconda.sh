#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

wget -q -P ~/ https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-$(uname -m).sh
bash ~/Miniconda3-${MINICONDA_VERSION}-Linux-$(uname -m).sh -b -p
rm ~/Miniconda3-${MINICONDA_VERSION}-Linux-$(uname -m).sh
source ~/miniconda3/bin/activate
conda init
