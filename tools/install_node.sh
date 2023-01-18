#!/usr/bin/env bash

dpkgArch="$(dpkg --print-architecture)"
case "${dpkgArch##*-}" in
  amd64) ARCH='x64';;
  ppc64el) ARCH='ppc64le';;
  s390x) ARCH='s390x';;
  arm64) ARCH='arm64';;
  armhf) ARCH='armv7l';;
  i386) ARCH='x86';;
  *) echo "unsupported architecture"; exit 1 ;;
esac

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

wget -q -P ~/ https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${ARCH}.tar.xz
mkdir -p /usr/local/lib/nodejs
tar -xJvf ~/node-v${NODE_VERSION}-linux-${ARCH}.tar.xz -C /usr/local/lib/nodejs
rm ~/node-v${NODE_VERSION}-linux-${ARCH}.tar.xz

mv /usr/local/lib/nodejs/node-v${NODE_VERSION}-linux-${ARCH} /usr/local/lib/nodejs/node

export PATH=/usr/local/lib/nodejs/node/bin:${PATH}

npm install -g npm@${NPM_VERSION}
