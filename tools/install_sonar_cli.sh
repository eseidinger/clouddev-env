#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/versions.sh

mkdir -p ~/tools
wget  -q -P ~/ https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_CLI_VERSION}.zip
unzip ~/sonar-scanner-cli-${SONAR_CLI_VERSION}.zip -d ~/
rm ~/sonar-scanner-cli-${SONAR_CLI_VERSION}.zip
mv ~/sonar-scanner-${SONAR_CLI_VERSION} ~/tools/sonar-scanner
