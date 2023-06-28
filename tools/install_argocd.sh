#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

ARCH="$(dpkg --print-architecture)"

mkdir -p ~/tools/argocd
wget  -q -P ~/ https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-${ARCH}
mv ~/argocd-linux-${ARCH} ~/tools/argocd/argocd
chmod +x ~/tools/argocd/argocd
