#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk selfupdate force

sdk install java ${JAVA_VERSION}-zulu
sdk install kotlin ${KOTLIN_VERSION}
sdk install groovy ${GROOVY_VERSION}
sdk install gradle ${GRADLE_VERSION}
sdk install maven ${MAVEN_VERSION}
