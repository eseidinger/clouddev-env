#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

wget -q -P ~/ https://go.dev/dl/go${GOLANG_VERSION}.linux-$(dpkg --print-architecture).tar.gz
tar -C /usr/local -xzf ~/go${GOLANG_VERSION}.linux-$(dpkg --print-architecture).tar.gz
rm ~/go${GOLANG_VERSION}.linux-$(dpkg --print-architecture).tar.gz
