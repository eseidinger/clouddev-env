#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java ${JAVA_VERSION}-zulu
sdk install gradle ${GRADLE_VERSION}
sdk install kotlin ${KOTLIN_VERSION}
