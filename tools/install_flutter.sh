#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

wget -q -P ~/ https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
tar -xf ~/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
rm ~/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
mv flutter ~/tools/flutter
